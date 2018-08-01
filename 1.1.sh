#1.1
PROJECTNAME="pe-training"
read -p "Enter VPC name" VpcName
echo "Creating Vpc"
gcloud compute --project="$PROJECTNAME" networks create "$VpcName"
echo "Attaching firewall to VPC"
gcloud compute firewall-rules create austin-firewall --action allow --rules tcp:22 --source-ranges 59.152.52.0/22 --direction ingress --network "$VpcName"
