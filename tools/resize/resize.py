#!/usr/local/bin/python3

import argparse
import csv
import json
import os
import requests
import sys
import time
from kubernetes import client, config
from prettytable import PrettyTable 


BASE_URL = "https://console.rafay.dev"
RESOURCE_BUFFER = 25

def getOptions(args=sys.argv[1:]):
    parser = argparse.ArgumentParser(description="Rafay K8S Application resize tool based on usage..", formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("-d", "--dry-run", help="Generate the report of resources Usage. It does not Update resources requests.", action='store_true')
    options = parser.parse_args(args)
    return options

def bytestogigabytes(bytes):
    return ((int(bytes) / 1000) / 1000 / 1000)

def bytestomegabytes(bytes):
    return (bytes / 1024) / 1024

def coretimillcore(cores):
    return (cores * 1000 )

def add_buffer(num):
    return (num + int(num * RESOURCE_BUFFER/100))

def send_request(method, url, headers, payload=None):
    if payload:
        return requests.request(method, url, headers=headers, data=payload)
    else:
        return requests.request(method, url, headers=headers)
    
def get_projectID(headers, project):
    uri = BASE_URL + "/auth/v1/projects/?limit=100"
    response = send_request("GET", uri, headers, {})
    response = json.loads(response.text)
    if response['count'] > 0:
        for prj in response['results']:
            if prj['name'] == project:
                return prj['id']
                      
def get_edgeID(headers, projectID, cluster):
    uri = BASE_URL + "/edge/v1/projects/" + projectID + "/edges/?limit=100"
    response = send_request("GET", uri, headers, {})
    response = json.loads(response.text)
    if response['count'] > 0:
        for cls in response['results']:
            if cls['name'] == cluster:
                return cls['id'], cls['edge_id']
            
def patch_deployment(client, ns, deploy, cpu=None, memory=None):
    # Read deployment   
    deployment = client.read_namespaced_deployment(name=deploy, namespace=ns)
    if cpu:
        deployment.spec.template.spec.containers[0].resources.requests['cpu'] = cpu
    if memory:
        deployment.spec.template.spec.containers[0].resources.requests['memory'] = memory
    #Pathch the deployment
    return client.patch_namespaced_deployment(name=deploy, namespace=ns, body=deployment)
        
def report_cluster_metrics(edge, headers, time):
     ## Cluster Metrics
    cluster_cpu_url = BASE_URL + "/cluster_metrics/cpu_details?duration=" + time +"&edgeId=" + edge + "&points=30"
    memory_cpu_url = BASE_URL + "/cluster_metrics/memory_details?duration=" + time + "&edgeId=" + edge + "&points=30"

    cluster_cpu_data = send_request("GET", cluster_cpu_url, headers, {})
    cluster_cpu_response = json.loads(cluster_cpu_data.text)

    memory_gb = []
    cluster_memory_data = send_request("GET", memory_cpu_url, headers, {})
    cluster_memory_response = json.loads(cluster_memory_data.text)
    for memory in cluster_memory_response['total'].values():
      memory_gb.append((int(bytestogigabytes(memory))))
    
    cluster_cpu_total_max = max(cluster_cpu_response['total'].values())
    cluster_memory_total_max = max(memory_gb)

    if time == "1h":
        cluster_cpu_request_max = list(cluster_cpu_response['request'])[-1]
        cluster_cpu_request_max = cluster_cpu_response['request'][cluster_cpu_request_max]
        cluster_cpu_request_max = round(float(cluster_cpu_request_max), 3)
        cluster_cpu_usage_max = list(cluster_cpu_response['usage'])[-1]
        cluster_cpu_usage_max = cluster_cpu_response['usage'][cluster_cpu_usage_max]
        cluster_cpu_usage_max = round(float(cluster_cpu_usage_max), 3)
        cluster_memory_request_max = list(cluster_memory_response['request'])[-1]
        cluster_memory_request_max = round(bytestogigabytes(float(cluster_memory_response['request'][cluster_memory_request_max])), 2)
        cluster_memory_usage_max = list(cluster_memory_response['usage'])[-1]
        cluster_memory_usage_max = round(bytestogigabytes(float(cluster_memory_response['usage'][cluster_memory_usage_max])), 2)
    else:
        cluster_cpu_request_max = max(cluster_cpu_response['request'].values())
        cluster_cpu_request_max = round(float(cluster_cpu_request_max), 3)
        cluster_cpu_usage_max = max(cluster_cpu_response['usage'].values())
        cluster_cpu_usage_max = round(float(cluster_cpu_usage_max), 3)
        cluster_memory_request_max = round(bytestogigabytes(float(max(cluster_memory_response['request'].values()))), 2)
        cluster_memory_usage_max = round(bytestogigabytes(float(max(cluster_memory_response['usage'].values()))), 2)

    return (cluster_cpu_total_max, cluster_cpu_request_max,cluster_cpu_usage_max, cluster_memory_total_max, cluster_memory_request_max, cluster_memory_usage_max)


def main():
    timestr = time.strftime("%m%d%Y-%H%M%S")
    options = getOptions(sys.argv[1:])
    row = ["Namespace", "POD", "CPU_REQUESTS (BEFORE)", "CPU_USAGE", "CPU_REQUESTS (AFTER)", "MEMORY_REQUESTS (BEFORE)", "MEMORY_USAGE", "MEMORY_REQUESTS (AFTER)"]
    cluster_row = ["CLUSTER_CPU_TOTAL", "CLUSTER_CPU_REQUEST", "CLUSTER_CPU_USAGE", "CLUSTER_MEMORY_TOTAL(GB)", "CLUSTER_MEMORY_REQUEST(GB)", "CLUSTER_MEMORY_USAGE(GB)"]
    clusterTable =  PrettyTable(cluster_row)
    appTable = PrettyTable(row) 
    clusterTableLater =  PrettyTable(cluster_row)

    config.load_kube_config()
    excluded_ns = ['kube-node-lease', 'kube-public', 'kube-system', 'rafay-infra', 'rafay-system']

    if not os.environ.get('PROJECT'):
        project = "defaultproject"
    else:
        project = os.environ['PROJECT']
    username = os.environ['USER']
    password = os.environ['PASSWORD']
    cluster = os.environ['CLUSTER']
    
    ##Rafay Authentication using SessionID
    auth_url = BASE_URL + "/auth/v1/login/"
    auth_headers = { 'Accept': 'application/json','Content-Type': 'application/json'}
    auth_payload = "{ \"username\": \"%s\", \"password\": \"%s\"}" %(username, password)
    auth_response = requests.request('POST', auth_url, headers=auth_headers, data=auth_payload)
    rsid = auth_response.cookies.get('rsid')
    csrf = auth_response.cookies.get('csrftoken')

    headers = {
               'Accept': 'application/json',
               'Content-Type': 'application/json',
               'x-csrftoken': csrf,
               'Cookie': 'csrftoken='+csrf,
               'Cookie': 'rsid='+rsid
              }
    
    projectID = get_projectID(headers, project)
    edge= get_edgeID(headers, projectID, cluster)
    # Setup CSV
    filename = cluster + "-resource-usage-" + timestr + ".csv"
    fd_csv = open(filename, 'w')
    csv_writer = csv.writer(fd_csv)
    csv_writer.writerow(cluster_row)

    (cluster_cpu_total_max, cluster_cpu_request_max,cluster_cpu_usage_max, \
     cluster_memory_total_max, cluster_memory_request_max, cluster_memory_usage_max) = report_cluster_metrics(edge[1], headers, "24h")
    clusterTable.add_row([cluster_cpu_total_max, cluster_cpu_request_max,cluster_cpu_usage_max, cluster_memory_total_max, cluster_memory_request_max, cluster_memory_usage_max])
    csv_writer.writerow([cluster_cpu_total_max, cluster_cpu_request_max,cluster_cpu_usage_max, cluster_memory_total_max, cluster_memory_request_max, cluster_memory_usage_max])
    csv_writer.writerow("\n\n")


    print("==========Report Generated By Rafay Systems===========\n")
    print("\nTotal Cluster Resource utilization (BEFORE)")
    print(clusterTable)
    csv_writer.writerow(row)

    #k8s part
    all_ns = []
    v1 = client.CoreV1Api()
    r1 = client.AppsV1Api()
    ret = v1.list_namespace()
    for i in ret.items:
        if i.metadata.name not in excluded_ns:
            all_ns.append(i.metadata.name)
    info = {}
    for ns in all_ns:
        ret_pod = v1.list_namespaced_pod(namespace=ns)
        if ret_pod.items:
            pod_list = []
            for pod in ret_pod.items:
                pod_name = pod.metadata.name
                pod_o_rs = pod.metadata.owner_references[0].name
                ret_rs =  r1.list_namespaced_replica_set(namespace=ns)
                if ret_rs.items:
                    for rs in ret_rs.items:
                       if rs.metadata.name == pod_o_rs:
                           rs_o_deploy = rs.metadata.owner_references[0].name
                           ret_deploy = r1.read_namespaced_deployment(name=rs_o_deploy, namespace=ns)
                           if ret_deploy.spec.template.spec.containers[0].resources.requests:
                               cpu_requests = ret_deploy.spec.template.spec.containers[0].resources.requests['cpu']
                               memory_requests = ret_deploy.spec.template.spec.containers[0].resources.requests['memory']
                               pod_list.append({"pod": pod_name , "rs": pod_o_rs, "deploy": rs_o_deploy, "cpu": cpu_requests, "memory": memory_requests})
            info[ns] = pod_list

    ## Pods Metrics
    for data in info.keys():
        for pod in info[data]:
            cpu_url = BASE_URL + "/pod_metrics/" + pod['pod'] + "/cpu_details?duration=24h&edgeId=" + edge[1] + "&points=30"
            memory_url = BASE_URL + "/pod_metrics/" + pod['pod'] + "/memory_details?duration=24h&edgeId=" + edge[1] + "&points=30"
            cpu_data = send_request("GET", cpu_url, headers, {})
            cpu_response = json.loads(cpu_data.text)
            cpu_max = max(cpu_response['usage'].values())
            #Convert to millcores and roundup.
            cpu_usage_round = round(float(cpu_max), 3)
            cpu_usage_millcore = coretimillcore(cpu_usage_round)
            cpu_usage = str(int(cpu_usage_millcore)) + "m"

            #Calculate new value for cpu requests.
            new_cpu = add_buffer(int(cpu_usage_millcore))
            # For output
            new_cpu_requests = str(new_cpu) + "m"

            mem_data = send_request("GET", memory_url, headers, {})
            mem_response = json.loads(mem_data.text)
            mem_max = max(mem_response['usage'].values())
            #Convert to Mi and roundup.
            mem_mi = bytestomegabytes(float(mem_max))
            mem_usage_round = round(float(mem_mi), 3)
            mem_usage = str(int(mem_usage_round)) + "Mi"

            #Calculate new value for memory requets
            new_mem = add_buffer(int(mem_usage_round))
            # For output
            new_mem_requests = str(new_mem) + "Mi" 

            #Sanatize CPU values.
            if "m" in pod['cpu']:
                pod_cpu_value = pod['cpu'][:-1]
            else:
                pod_cpu_value = int(pod['cpu']) * 1000 
                pod_cpu_value = str(pod_cpu_value) + "m"

            # If Usage is lower for CPU/Memory then update the values.
            if mem_usage_round < int(pod['memory'][:-2]) and cpu_usage_millcore < int(pod_cpu_value[:-1]):
                #Check if new values are not going above current set values.
                if new_mem < int(pod['memory'][:-2]) and new_cpu <  int(pod['memory'][:-2])  :
                    appTable.add_row([data, pod['pod'], pod['cpu'], cpu_usage, new_cpu_requests,  pod['memory'], mem_usage, new_mem_requests])
                    csv_writer.writerow([data, pod['pod'], pod['cpu'], cpu_usage, new_cpu_requests,  pod['memory'], mem_usage, new_mem_requests])
                    if not options.dry_run:
                        patch_deployment(r1, data, pod['deploy'],new_cpu_requests, new_mem_requests)
                elif new_mem < int(pod['memory'][:-2]):
                    appTable.add_row([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'],  pod['memory'], mem_usage, new_mem_requests])
                    csv_writer.writerow([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'],  pod['memory'], mem_usage, new_mem_requests])
                    if not options.dry_run:
                        patch_deployment(r1, data, pod['deploy'],new_cpu_requests, new_mem_requests)
                elif new_cpu <  int(pod_cpu_value[:-1]):
                    appTable.add_row([data, pod['pod'], pod['cpu'], cpu_usage, new_cpu_requests,  pod['memory'], mem_usage, pod['memory']])
                    csv_writer.writerow([data, pod['pod'], pod['cpu'], cpu_usage, new_cpu_requests,  pod['memory'], mem_usage,  pod['memory']])
                    if not options.dry_run:
                        patch_deployment(r1, data, pod['deploy'],new_cpu_requests, new_mem_requests)
                else:
                    appTable.add_row([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'], pod['memory'], mem_usage, pod['memory']])
                    csv_writer.writerow([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'], pod['memory'], mem_usage, pod['memory']])
            # Only update memory if usage is lower.
            elif mem_usage_round < int(pod['memory'][:-2]):
                #Check if new values are not going above current set values.
                if new_mem < int(pod['memory'][:-2]):
                    appTable.add_row([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'],  pod['memory'], mem_usage, new_mem_requests])
                    csv_writer.writerow([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'],  pod['memory'], mem_usage, new_mem_requests])
                    if not options.dry_run:
                        patch_deployment(r1, data, pod['deploy'], None, new_mem_requests)
                else:
                    appTable.add_row([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'], pod['memory'], mem_usage, pod['memory']])
                    csv_writer.writerow([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'], pod['memory'], mem_usage, pod['memory']])
            # Only update cpu if usage is lower.
            elif cpu_usage_millcore < int(pod_cpu_value[:-1]):
                #Check if new values are not going above current set values.
                if new_cpu < int(pod_cpu_value[:-1]):
                    appTable.add_row([data, pod['pod'], pod['cpu'], cpu_usage, new_cpu_requests,  pod['memory'], mem_usage, pod['memory']])
                    csv_writer.writerow([data, pod['pod'], pod['cpu'], cpu_usage, new_cpu_requests,  pod['memory'], mem_usage, pod['memory']])
                    if not options.dry_run:
                        patch_deployment(r1, data, pod['deploy'],new_cpu_requests, None)
                else:
                    appTable.add_row([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'], pod['memory'], mem_usage, pod['memory']])
                    csv_writer.writerow([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'], pod['memory'], mem_usage, pod['memory']])
            # Do not update values.
            else:
                print("loop4")
                appTable.add_row([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'], pod['memory'], mem_usage, pod['memory']])
                csv_writer.writerow([data, pod['pod'], pod['cpu'], cpu_usage, pod['cpu'], pod['memory'], mem_usage, pod['memory']])

    print("Cluster:", cluster)
    print(appTable)
    if not options.dry_run:
        print("\n Calculating Cluster resource utilization after the updates...It may take few mins..")
        time.sleep(300)
        csv_writer.writerow("\n\n")
        csv_writer.writerow(cluster_row)
        (cluster_cpu_total_max, cluster_cpu_request_max,cluster_cpu_usage_max, \
         cluster_memory_total_max, cluster_memory_request_max, cluster_memory_usage_max) = report_cluster_metrics(edge[1], headers, "1h")
        clusterTableLater.add_row([cluster_cpu_total_max, cluster_cpu_request_max,cluster_cpu_usage_max, cluster_memory_total_max, cluster_memory_request_max, cluster_memory_usage_max])
        csv_writer.writerow([cluster_cpu_total_max, cluster_cpu_request_max,cluster_cpu_usage_max, cluster_memory_total_max, cluster_memory_request_max, cluster_memory_usage_max])
        print("\nTotal Cluster Resource utilization (AFTER)")
        print(clusterTableLater)
    fd_csv.close()

if __name__== "__main__":
    main()