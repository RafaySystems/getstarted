#!/bin/bash
curl -s -o rctl-linux-amd64.tar.bz2 https://s3-us-west-2.amazonaws.com/rafay-prod-cli/publish/rctl-linux-amd64.tar.bz2
tar -xf rctl-linux-amd64.tar.bz2
chmod 0755 rctl

echo "Adding Cluster"
echo $ADD_CLUSTER_SPEC
echo "Modifying Cluster"
echo $MOD_CLUSTER_SPEC
echo "Deleting Cluster"
echo $REM_CLUSTER_SPEC

ls -l

if [ $IS_ADDED = "true" ]
then
    echo "Is added is true"
    tempSpec=$(basename $ADD_CLUSTER_SPEC)
    addSpec=$(find . -name $tempSpec)
    CLUSTER_NAME=`cat $addSpec |grep name|head -1|cut -d ':' -f2`
    PROJECT_NAME=`cat $addSpec |grep project|head -1|cut -d ':' -f2`
    echo $addSpec
    echo $PROJECT_NAME
    echo $CLUSTER_NAME
    echo "./rctl apply -f $addSpec -p ${PROJECT_NAME}"
    ./rctl apply -f $addSpec -p $PROJECT_NAME

    if [ $? -eq 0 ];
    then
        echo "[+] Successfully Created cluster ${CLUSTER_NAME}"
    fi

    CLUSTER_STATUS_ITERATIONS=1
    CLUSTER_HEALTH_ITERATIONS=1
    CLUSTER_STATUS=`./rctl get cluster ${CLUSTER_NAME} -o json |jq '.status'|cut -d'"' -f2`
    while [ "$CLUSTER_STATUS" != "READY" ]
    do
      sleep 60
      if [ $CLUSTER_STATUS_ITERATIONS -ge 50 ];
      then
        break
      fi
      CLUSTER_STATUS_ITERATIONS=$((CLUSTER_STATUS_ITERATIONS+1))
      CLUSTER_STATUS=`./rctl get cluster ${CLUSTER_NAME} -o json |jq '.status'|cut -d'"' -f2`
      if [ $CLUSTER_STATUS == "PROVISION_FAILED" ];
      then
        echo -e " !! Cluster provision failed !!  "
        echo -e " !! Exiting !!  " && exit -1
      fi

      PROVISION_STATUS=`./rctl get cluster ${CLUSTER_NAME} -o json |jq '.provision.status' |cut -d'"' -f2`

      if [ $PROVISION_STATUS == "INFRA_CREATION_FAILED" ];
      then
        echo -e " !! Cluster provision failed !!  "
        echo -e " !! Exiting !!  " && exit -1
      fi

      if [ $PROVISION_STATUS == "BOOTSTRAP_CREATION_FAILED" ];
      then
        echo -e " !! Cluster provision failed !!  "
        echo -e " !! Exiting !!  " && exit -1
      fi

      PROVISION_STATE=`./rctl get cluster ${CLUSTER_NAME} -o json | jq '.provision.running_state' |cut -d'"' -f2`

      echo "$PROVISION_STATE in progress"
    done
    if [ $CLUSTER_STATUS != "READY" ];
    then
        echo -e " !! Cluster provision failed !!  "
        echo -e " !! Exiting !!  " && exit -1
    fi
    if [ $CLUSTER_STATUS == "READY" ];
    then
        echo "[+] Cluster Provisioned Successfully waiting for it to be healthy"
        CLUSTER_HEALTH=`./rctl get cluster ${CLUSTER_NAME} -o json | jq '.health' |cut -d'"' -f2`
        while [ "$CLUSTER_HEALTH" != 1 ]
        do
          echo "Iteration-${CLUSTER_HEALTH_ITERATIONS} : Waiting 60 seconds for cluster to be healthy..."
          sleep 60
          if [ $CLUSTER_HEALTH_ITERATIONS -ge 15 ];
          then
            break
          fi
          CLUSTER_HEALTH_ITERATIONS=$((CLUSTER_HEALTH_ITERATIONS+1))
          CLUSTER_HEALTH=`./rctl get cluster ${CLUSTER_NAME} -o json | jq '.health' |cut -d'"' -f2`
        done
    fi

    if [[ $CLUSTER_HEALTH == 0 ]];
    then
        echo -e " !! Cluster is not healthy !!  "
        echo -e " !! Exiting !!  " && exit -1
    fi
    if [[ $CLUSTER_HEALTH == 1 ]];
    then
        echo "[+] Cluster Provisioned Successfully and is Healthy"
    fi
elif [ $IS_MODIFIED = "true" ]
then
    echo "Cluster update in progress!"
    tempSpec=$(basename $MOD_CLUSTER_SPEC)
    modSpec=$(find . -name $tempSpec)
    CLUSTER_NAME=`cat $modSpec |grep name|head -1|cut -d ':' -f2`
    PROJECT_NAME=`cat $modSpec |grep project|head -1|cut -d ':' -f2`
    echo $modSpec
    echo $PROJECT_NAME
    echo $CLUSTER_NAME
    echo "./rctl apply -f $modSpec -p $PROJECT_NAME"
    ./rctl apply -f $modSpec -p $PROJECT_NAME
elif [ $IS_REMOVED = "true" ]
then
    echo "Cluster deletion in progress!"
    remSpec=$(basename $REM_CLUSTER_SPEC)
    CLUSTER_NAME=`echo $remSpec |cut -d '.' -f1`
    echo $CLUSTER_NAME
    
    echo "Before getting projects"
    proj=( $(./rctl get projects -o json | jq -r '.results[].name') )
    echo "Projects: $proj"
    proj_len=${#proj[@]}
    echo "Project length is $proj_len"

    for ((i = 0 ; i < $proj_len ; i++)); do
      echo "Project: ${proj[$i]}"
      clusters=( $(./rctl get clusters -p ${proj[$i]} -o json | jq -r '.[].name') )
      cluster_len=${#clusters[@]}

      for ((j = 0 ; j < $proj_len ; j++)); do
        tmp_cluster=${clusters[$j]}
        echo "$tmp_cluster"
        if [ "$tmp_cluster" = "$CLUSTER_NAME" ]
        then
          echo "./rctl delete cluster $tmp_cluster -p  ${proj[$i]} -y"
          ./rctl delete cluster $tmp_cluster -p  ${proj[$i]} -y
          exit 0
        else
          echo "Cluster not found!"
        fi
      done
    done
else
    echo "No Op"
    exit 1;
fi
