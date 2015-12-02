#!/usr/bin/env bash

##############
# Install deps
##############
# Ubuntu
apt-get update
apt-get install python-pip jq -y
#####################

# Amazon Linux (RHEL) - NAT instances
yum update
yum install python-pip jq -y
#####################

pip install --upgrade awscli

##############

BUCKET=${s3_bucket_name}
SSH_USER=${ssh_user}

mkdir -p /tmp/pub_key_files/

for key in `aws s3api list-objects --bucket $BUCKET | jq -r '.Contents[].Key'`
do
  echo $key
  aws s3 cp s3://$BUCKET/$key /tmp/pub_key_files/
done

cat /tmp/pub_key_files/*.pub > /tmp/new_authorized_keys

cp --force /tmp/new_authorized_keys /home/$SSH_USER/.ssh/authorized_keys
chown $SSH_USER:$SSH_USER /home/$SSH_USER/.ssh/authorized_keys
chmod 600 /home/$SSH_USER/.ssh/authorized_keys