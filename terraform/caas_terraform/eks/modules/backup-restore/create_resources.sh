#!/bin/bash

# Download rctl binary and configure for use 
# (Linux)
#curl -s -o rctl-linux-amd64.tar.bz2 https://s3-us-west-2.amazonaws.com/rafay-prod-cli/publish/rctl-linux-amd64.tar.bz2
#tar -xf rctl-linux-amd64.tar.bz2
# (Mac)
curl -s -o rctl-darwin-amd64.tar.bz2 https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-darwin-amd64.tar.bz2
tar -xf rctl-darwin-amd64.tar.bz2

chmod 0755 rctl

echo "In Apply"
echo "PROJECT_NAME: " ${PROJECT_NAME}
echo "CLUSTER_NAME: " ${CLUSTER_NAME}

./rctl config init ../artifacts/credentials/config.json

./rctl config show

#./rctl get projects

./rctl download kubeconfig --cluster ${CLUSTER_NAME} -p ${PROJECT_NAME} -f ${CLUSTER_NAME}.yaml --wait

export KUBECONFIG=./${CLUSTER_NAME}.yaml

arn=$(kubectl get sa -n rafay-system velero-rafay -o jsonpath='{.metadata.annotations.eks\.amazonaws\.com/role-arn}')

echo "ARN is: " $arn
echo ""./rctl create credential aws rafay-backup-restore --cred-type data-backup --role-arn "$arn" -p ${PROJECT_NAME} --wait
./rctl create credential aws rafay-backup-restore --cred-type data-backup --role-arn "$arn" -p ${PROJECT_NAME} --wait

echo "./rctl create dp-location ${CLUSTER_NAME}-cp --backup-type controlplanebackup --target-type amazon --region ${CLUSTER_LOCATION} --bucket-name ${S3_BUCKET_NAME} -p ${PROJECT_NAME} --wait"
./rctl create dp-location ${CLUSTER_NAME}-cp --backup-type controlplanebackup --target-type amazon --region ${CLUSTER_LOCATION} --bucket-name ${S3_BUCKET_NAME} -p ${PROJECT_NAME} --wait

echo "./rctl create dp-location ${CLUSTER_NAME}-vol --backup-type volumebackup --target-type amazon --region ${CLUSTER_LOCATION} --bucket-name ${S3_BUCKET_NAME} -p ${PROJECT_NAME} --wait"
./rctl create dp-location ${CLUSTER_NAME}-vol --backup-type volumebackup --target-type amazon --region ${CLUSTER_LOCATION} --bucket-name ${S3_BUCKET_NAME} -p ${PROJECT_NAME} --wait

echo ""./rctl create dp-agent ${CLUSTER_NAME} --cloud-credentials rafay-backup-restore -p ${PROJECT_NAME} --wait
./rctl create dp-agent ${CLUSTER_NAME} --cloud-credentials rafay-backup-restore -p ${PROJECT_NAME} --wait

echo "./rctl deploy dp-agent ${CLUSTER_NAME} --cluster-name ${CLUSTER_NAME} -p ${PROJECT_NAME} --wait"
./rctl deploy dp-agent ${CLUSTER_NAME} --cluster-name ${CLUSTER_NAME} -p ${PROJECT_NAME} --wait

echo "Sleeping for 4 minutes"
sleep 240

echo "./rctl create dp-policy ${CLUSTER_NAME}-backup --type backup --location ${CLUSTER_NAME}-cp --snapshot-location ${CLUSTER_NAME}-vol --retention-period 720h -p ${PROJECT_NAME} --wait"
./rctl create dp-policy ${CLUSTER_NAME}-backup --type backup --location ${CLUSTER_NAME}-cp --snapshot-location ${CLUSTER_NAME}-vol --retention-period 720h -p ${PROJECT_NAME} --wait

echo "./rctl create dp-policy ${CLUSTER_NAME}-restore --type restore --restore-pvs -p ${PROJECT_NAME} --wait"
./rctl create dp-policy ${CLUSTER_NAME}-restore --type restore --restore-pvs -p ${PROJECT_NAME} --wait

echo "./rctl create dp-job --policy ${CLUSTER_NAME}-backup --cluster ${CLUSTER_NAME} -p ${PROJECT_NAME} --wait"
./rctl create dp-job --policy ${CLUSTER_NAME}-backup --cluster ${CLUSTER_NAME} -p ${PROJECT_NAME} --wait