#!/bin/bash
echo "Creating Instance"
gcloud sql instances create shell-instance16 --tier=db-f1-micro --region=us-east1 --authorized-networks=59.152.52.0/22
echo "Creating Database"
gcloud sql databases create employee_mgmt --instance=shell-instance16
gcloud sql instances describe shell-instance16 --format=json > opt.json
ip=$(python parse.py)

gcloud sql users create application_user --instance=shell-instance16
gcloud sql users list --instance=shell-instance16
gcloud sql connect shell-instance16 << EOF
USE employee_mgmt;
CREATE TABLE info (name VARCHAR(10),surname VARCHAR(10));
Insert into info values ('Ashwini','Swain');
Insert into info values ('Austin','3:16');
Select "Granting users permissions " as " ";
Grant Select,Insert on employee_mgmt.info to application_user;
Show Grants application_user@$ip;
Select "revoking permissions" as " ";
Revoke Select,Insert on employee_mgmt.info from application_user;
Show Grants application_user@$ip;
Select "Values in Table" as " " * from info;
Update info set name = Ashwin where name=='Ashwini';
Delete from info where name=='Ashwin';
rename table info to information;
drop table information;
EOF



