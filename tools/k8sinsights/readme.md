# Usage

## Step 1


## Step 2
export KUBECONFIG=kubeconfig.file

## Step 3 
bash k8s-insights.sh CLUSTER_NAME

---

# How does this work? 

## Step 1 

Verifies if given user inputs are valid i.e. cluster name & kubeconfig to access the cluster for discovery

## Step 2 

List all namespaces

## Step 3 

List all CRDs

## Step 4

Creates a list of all namespace-scoped resources using kubectl api-resources --verbs=list --namespaced=true

## Step 5

Uses the resource list from Step 4 and performs kubectl get $resource -A and saves the output into txt file

## Step 6

Creates a list of all Cluster-Scoped resources using kubectl api-resources --verbs=list --namespaced=false

## Step 7

Uses the resource list from step 6 and performs kubectl get $resource  and saves the output into txt file
