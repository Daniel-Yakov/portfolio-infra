#!/bin/bash

terraform init
terraform apply

# Congifure kubectl to work with created cluster
aws eks --region "$(terraform output -raw kube_config_region)" update-kubeconfig \
    --name "$(terraform output -raw kube_config_cluster_name)"

# Initial password
kubectl get -n argocd secret/argocd-initial-admin-secret -o=jsonpath='{.data.password}' | base64 -d

# Add repository to argocd
kubectl apply -f sealed_secret_connection.yml
