#!/bin/bash
#1.3
PROJECTNAME="pe-training"
read -p "Enter VPC name" VpcName
echo "Creating Vpc"
gcloud compute --project="$PROJECTNAME" networks create "$VpcName"
gcloud compute --project=pe-training networks create "$VpcName" --subnet-mode=custom
read -p "Enter region 1" region1
read -p 'Enter Cidr Range for subnet1: 'CidrRange1
read -p 'Enter Cidr Range for subnet1: ' CidrRange2
read -p "Enter region 2" region2
read -p "Enter Nat Name" Nat_inst
read -p "Enter Private instance name "privateInstance

echo "Creating custom subnets"
gcloud compute --project=pe-training networks subnets create ${VpcName}1 --network="$VpcName" --region=$region1 --range="$CidrRange1" --enable-flow-logs
gcloud compute --project=pe-training networks subnets create ${VpcName}2 --network="$VpcName" --region=$region2 --range="$CidrRange2" --enable-private-ip-google-access

echo "Creating firewall rules....."
#firewall to allow ssh
gcloud compute firewall-rules create all-ssh-firewall-rule --allow tcp:22 --network="$VpcName"
#firewall to allow internal communication
gcloud compute firewall-rules create allow-internat-firewall-rule --allow icmp,tcp:1-65535,udp:1-65535 --source-ranges 10.0.0.0/16 --network="$VpcName"

#creating NAT instance
echo "Launching NAT ....."
gcloud compute instances create $Nat_inst --network="$VpcName" --can-ip-forward --zone "$region1" --image-family debian-8 --subnet ${VpcName}1 --image-project debian-cloud --tags my-nat-gateway --metadata=startup-script="sudo sysctl -w net.ipv4.ip_forward=1\nsudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"

#creating private instance
echo "Launching private instance....."
gcloud compute instances create $privateInstance --network "$VpcName" --no-address --zone "$region2" --image-family debian-8 --subnet ${VpcName}2 --image-project debian-cloud --tags private-instance

#creating route to internet
gcloud compute routes create private-access-route --network "$VpcName" --destination-range 0.0.0.0/0 --next-hop-instance my-nat-gateway --next-hop-instance-zone ${VpcName}1 --tags private-instance --priority 900

