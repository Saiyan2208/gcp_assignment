#1.2
PROJECTNAME="pe-training"
read -p "Enter VPC name" VpcName
echo "Creating Vpc"
gcloud compute --project="$PROJECTNAME" networks create "$VpcName"
gcloud compute --project=pe-training networks create "$VpcName" --subnet-mode=custom
read -p "Enter region 1" region1
read -p 'Enter Cidr Range for subnet1: 'CidrRange1
read -p 'Enter Cidr Range for subnet1: ' CidrRange2
read -p "Enter region 2" region2
echo "Creating subnets "
gcloud compute --project=pe-training networks subnets create ${VpcName}1 --network="$VpcName" --region=$region1 --range="$CidrRange1" --enable-flow-logs
gcloud compute --project=pe-training networks subnets create ${VpcName}2 --network="$VpcName" --region=$region2 --range="$CidrRange2" --enable-private-ip-google-access
echo "Subnets created."
