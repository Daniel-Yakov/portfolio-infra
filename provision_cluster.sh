#!/bin/bash

terraform init
terraform apply

# Congifure kubectl to work with created cluster
aws eks --region "$(terraform output -raw kube_config_region)" update-kubeconfig \
    --name "$(terraform output -raw kube_config_cluster_name)"

# Initial password
echo "$(kubectl get -n argocd secret/argocd-initial-admin-secret -o=jsonpath='{.data.password}' | base64 -d)"

# Update record in aws hosted zone #
# get the dns name of elb
elb_dns_name=""
while [[ ! "$elb_dns_name" =~ .elb. ]]; do
  elb_dns_name=$(kubectl get -n app svc/ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  sleep 2
done

# cread the record (json format)
cat > record.json <<EOF
{
    "Comment": "Update record",
    "Changes": [{
    "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": "danielemployees.cloud",
                    "Type": "A",
                    "AliasTarget": {
                        "HostedZoneId": "Z3Q77PNBQS71R4",
                        "DNSName": "dualstack.$elb_dns_name",
                        "EvaluateTargetHealth": true
        }
    }}]
}
EOF

# update record in aws route 53
aws route53 change-resource-record-sets --hosted-zone-id Z09020131AOXZ3LFNC5KB --change-batch file://record.json