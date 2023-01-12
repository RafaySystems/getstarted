function namespace_resources {
  for i in $(kubectl api-resources --verbs=list --namespaced=true -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    if [[ $i != "task"* ]]; then
        printf "Resource: $i\n"
        printf "\n########### Resource: $i ################\n" >> $filename
        kubectl get --ignore-not-found -A ${i} >> $filename
    fi
  done
}


function cluster_resources {
  for i in $(kubectl api-resources --verbs=list --namespaced=false -o name | sort | uniq); do
    printf "Resource: $i\n"
    printf "\n################ Resource: $i #####################\n" >> $filename
    kubectl get --ignore-not-found ${i} >> $filename
  done
}

# Check if any arguments were passed
if [ $# -eq 0 ]; then
  # No arguments were passed
  echo "Please pass the clustername from which you want to retrieve the information. For example ./k8s-insights.sh <my-cluster-name>"
  exit 1
fi

# Check if the cluster name is present in the kubeconfig file
if ! kubectl config get-clusters | grep -q "$1"; then
  # Cluster name is not present in the kubeconfig file
  echo "Cluster name not present . Pleas run 'kubectl config get-clusters' to find out the exact cluster name and pass the same"
  exit 1
fi


touch "$1.txt"

filename="$1.txt"

kube_version=`kubectl version --client=false --short=true |grep -i server`
echo "Kube API $kube_version" >> $filename
# Get the list of namespaces
namespaces=$(kubectl get namespaces --context=$1 -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}')

# Get the list of custom resource definitions (CRDs)
crds=$(kubectl get crds --context=$1 -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}')

echo "################### Namespaces #####################" > $filename
echo "$namespaces" >> $filename
echo "######################################" >> $filename
echo "" >> $filename

echo "########### Custom Resource Definitions(CRDs)############" >> $filename
echo "$crds" >> $filename
echo "######################################" >> $filename
echo "" >> $filename
namespace_resources $filename
cluster_resources $filename
