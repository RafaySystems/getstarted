#!/bin/bash

# Download rctl binary and configure for use 
# (Linux)
#curl -s -o rctl-linux-amd64.tar.bz2 https://s3-us-west-2.amazonaws.com/rafay-prod-cli/publish/rctl-linux-amd64.tar.bz2
#tar -xf rctl-linux-amd64.tar.bz2
# (Mac)
curl -s -o rctl-darwin-amd64.tar.bz2 https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-darwin-amd64.tar.bz2
tar -xf rctl-darwin-amd64.tar.bz2

chmod 0755 rctl

# Trigger path in pipeline
path="gitops/specfiles/"

echo "In Destroy"
echo "PROJECT_NAME: " ${PROJECT_NAME}
echo "CLUSTER_NAME: " ${CLUSTER_NAME}

./rctl config init ../artifacts/credentials/config.json

./rctl config show

./rctl get projects

./rctl download kubeconfig --cluster terraform-caas-63 -p terraform-caas-63 -f terraform-caas-63.yam

