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

cat <<"EOF" > /home/${ssh_user}/update_ssh_authorized_keys.sh
#!/usr/bin/env bash

BUCKET=${s3_bucket_name}
SSH_USER=${ssh_user}
MARKER="# KEYS_BELOW_WILL_BE_UPDATED_BY_TERRAFORM"

mkdir -p /home/$SSH_USER/pub_key_files/

# Add marker, if not present
if ! grep -Fxq "$MARKER" /home/$SSH_USER/.ssh/authorized_keys;
then
  echo "
$MARKER" >> /home/$SSH_USER/.ssh/authorized_keys
fi

for key in `aws s3api list-objects --bucket $BUCKET | jq -r '.Contents[].Key'`
do
  aws s3 cp s3://$BUCKET/$key /home/$SSH_USER/pub_key_files/ > /dev/null
done

for f in /home/$SSH_USER/pub_key_files/*.pub ; do (cat "$f"; echo) >> /home/$SSH_USER/.ssh/tmp_authorized_keys; done

# Append keys fetched from S3 bucket
line=$(grep -n "$MARKER" /home/$SSH_USER/.ssh/authorized_keys | cut -d ":" -f 1)

{ head -n $line /home/$SSH_USER/.ssh/authorized_keys; cat /home/$SSH_USER/.ssh/tmp_authorized_keys; } > /home/$SSH_USER/.ssh/authorized_keys

sed -i /^$/d /home/$SSH_USER/.ssh/authorized_keys

chown $SSH_USER:$SSH_USER /home/$SSH_USER/.ssh/authorized_keys
chmod 600 /home/$SSH_USER/.ssh/authorized_keys

rm /home/$SSH_USER/.ssh/tmp_authorized_keys

EOF

chown ${ssh_user}:${ssh_user} /home/${ssh_user}/update_ssh_authorized_keys.sh
chmod 755 /home/${ssh_user}/update_ssh_authorized_keys.sh

# Execute now
su ${ssh_user} -c /home/${ssh_user}/update_ssh_authorized_keys.sh

# Add to cron
if (( ${enable_hourly_cron_updates} )); then
  croncmd="/home/${ssh_user}/update_ssh_authorized_keys.sh"
  cronjob="0 * * * * $croncmd"
  ( crontab -u ${ssh_user} -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -u ${ssh_user} -
fi

# Append addition user-data script
${additional_user_data_script}