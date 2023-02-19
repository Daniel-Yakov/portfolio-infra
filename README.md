# Employees DevOps portfolio
## Infrastracture repository
This repository contains all the code necessary for provisioning the infrastructure required to run the application in the employees-gitops-config repository.

The infrastructure includes an EKS cluster with Kubernetes infrastructure.
![Project architecture image](architecture.jpg)
The Kubernetes infrastructure is managed using Helm charts, which are stored in the employees-gitops-config repository.

To build the infrastructure, run the provision_cluster.sh script.

## Requirments
To run the code in this repository, you will need:
1. To run the code in this repository, you will need:
2. To run the provision_cluster.sh script and update the DNS record in a specific hosted zone to a specific domain using the AWS CLI. Therefore, you will need to modify the script and configure your AWS CLI as necessary.

It is important to note that this repository is intended to be used in conjunction with the employees-gitops-config repository to provide a complete DevOps solution for the application.