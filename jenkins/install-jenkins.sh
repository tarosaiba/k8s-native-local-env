#!/bin/bash

## Helm
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm upgrade --install \
    jenkins jenkinsci/jenkins \
    --namespace jenkins \
    --create-namespace \
    --values install-values.yaml \
    --wait

## Get password
kubectl --namespace jenkins \
    get secret jenkins \
    --output jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode && echo

## Create Cluster Role
kubectl apply -f clusterrole.yaml
