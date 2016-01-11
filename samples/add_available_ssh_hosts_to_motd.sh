#!/bin/bash

# This script will update motd and list available instances to login
# Script is far from perfect, so please consider improving it and send pull-request.

cat <<"INSTANCES_SCRIPT" > /etc/update-motd.d/60-update-list-of-running-instances
#!/bin/bash

aws configure set region eu-west-1

echo ""
echo ""
echo "Current instances grouped by AutoScaling Groups:"

# get all ASG
for asg in `aws autoscaling describe-auto-scaling-groups --output text  --query 'AutoScalingGroups[*].AutoScalingGroupName'`; do
echo ""
echo "Autoscaling group name: $asg"

# get all instances in ASG
for ip in `aws ec2 describe-instances --filters Name=tag-key,Values='aws:autoscaling:groupName' Name=tag-value,Values=$asg --output text --query 'Reservations[*].Instances[*].[PrivateIpAddress]'`; do
  echo $ip
done

echo ""
echo "========================================================================="

done

echo ""
echo "Log on to the boxes with: ssh <IP address>"
echo ""
INSTANCES_SCRIPT

chmod +x /etc/update-motd.d/60-update-list-of-running-instances
