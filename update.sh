#!/bin/bash

echo namespace ${PLUGIN_NAMESPACE}
echo deployment ${PLUGIN_DEPLOYMENT}
echo container ${PLUGIN_CONTAINER}
echo repo ${PLUGIN_REPO}
echo tag ${PLUGIN_TAG}

if [ -z ${PLUGIN_NAMESPACE} ]; then
  PLUGIN_NAMESPACE="default"
fi

if [ -z ${PLUGIN_KUBERNETES_USER} ]; then
  PLUGIN_KUBERNETES_USER="default"
fi

if [ ! -z ${PLUGIN_KUBERNETES_TOKEN} ]; then
  KUBERNETES_TOKEN=$PLUGIN_KUBERNETES_TOKEN
fi

if [ ! -z ${PLUGIN_KUBERNETES_SERVER} ]; then
  KUBERNETES_SERVER=$PLUGIN_KUBERNETES_SERVER
fi

if [ ! -z ${PLUGIN_KUBERNETES_CERT} ]; then
  KUBERNETES_CERT=${PLUGIN_KUBERNETES_CERT}
fi

kubectl config set-credentials default --token=${KUBERNETES_TOKEN}
if [ ! -z ${KUBERNETES_CERT} ]; then
  echo ${KUBERNETES_CERT} | base64 -d > ca.crt
  kubectl config set-cluster default --server=${KUBERNETES_SERVER} --certificate-authority=ca.crt
else
  echo "WARNING: Using insecure connection to cluster"
  kubectl config set-cluster default --server=${KUBERNETES_SERVER} --insecure-skip-tls-verify=true
fi

kubectl config set-context default --cluster=default --user=${PLUGIN_KUBERNETES_USER}
kubectl config use-context default

echo Deploying to $KUBERNETES_SERVER

echo kubectl -n ${PLUGIN_NAMESPACE} set image deployment/${PLUGIN_DEPLOYMENT} ${PLUGIN_CONTAINER}=${PLUGIN_REPO}:${PLUGIN_TAG} --record

kubectl -n ${PLUGIN_NAMESPACE} set image deployment/${PLUGIN_DEPLOYMENT} \
      ${PLUGIN_CONTAINER}=${PLUGIN_REPO}:${PLUGIN_TAG} --record
