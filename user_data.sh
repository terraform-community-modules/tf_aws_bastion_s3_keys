#!/usr/bin/env bash

##############
# Install deps
##############
# Ubuntu
apt-get update
apt-get install python-pip jq -y
#####################

# Amazon Linux (RHEL) - NAT instances
yum update -y
# epel provides python-pip & jq
yum install -y epel-release
yum install python-pip jq -y
#####################

pip install --upgrade awscli

##############

# Add ${ssh_user} to system
useradd ${ssh_user} -m
mkdir /home/${ssh_user}/.ssh
chmod 0700 /home/${ssh_user}/.ssh
chown ${ssh_user}:${ssh_user} /home/${ssh_user}/.ssh

cat <<"EOF" > /home/${ssh_user}/update_ssh_authorized_keys.sh
#!/usr/bin/env bash

set -e

BUCKET_NAME=${s3_bucket_name}
BUCKET_URI=${s3_bucket_uri}
SSH_USER=${ssh_user}
MARKER="# KEYS_BELOW_WILL_BE_UPDATED_BY_TERRAFORM"
KEYS_FILE=/home/$SSH_USER/.ssh/authorized_keys
TEMP_KEYS_FILE=$(mktemp /tmp/authorized_keys.XXXXXX)
PUB_KEYS_DIR=/home/$SSH_USER/pub_key_files/
PATH=/usr/local/bin:$PATH

[[ -z $BUCKET_URI ]] && BUCKET_URI="s3://$BUCKET_NAME/"

mkdir -p $PUB_KEYS_DIR

# Add marker, if not present, and copy static content.
grep -Fxq "$MARKER" $KEYS_FILE || echo -e "\n$MARKER" >> $KEYS_FILE
line=$(grep -n "$MARKER" $KEYS_FILE | cut -d ":" -f 1)
head -n $line $KEYS_FILE > $TEMP_KEYS_FILE

# Synchronize the keys from the bucket.
aws s3 sync --delete $BUCKET_URI $PUB_KEYS_DIR
for filename in $PUB_KEYS_DIR/*; do
    sed 's/\n\?$/\n/' < $filename >> $TEMP_KEYS_FILE
done

# Move the new authorized keys in place.
chown $SSH_USER:$SSH_USER $KEYS_FILE
chmod 600 $KEYS_FILE
mv $TEMP_KEYS_FILE $KEYS_FILE
if [[ $(command -v "selinuxenabled") ]]; then
    restorecon -R -v $KEYS_FILE
fi
EOF

cat <<"EOF" > /home/${ssh_user}/.ssh/config
Host *
    StrictHostKeyChecking no
EOF
chmod 600 /home/${ssh_user}/.ssh/config
chown ${ssh_user}:${ssh_user} /home/${ssh_user}/.ssh/config

chown ${ssh_user}:${ssh_user} /home/${ssh_user}/update_ssh_authorized_keys.sh
chmod 755 /home/${ssh_user}/update_ssh_authorized_keys.sh

# Execute now
su ${ssh_user} -c /home/${ssh_user}/update_ssh_authorized_keys.sh

# Be backwards compatible with old cron update enabler
if [ "${enable_hourly_cron_updates}" = 'true' -a -z "${keys_update_frequency}" ]; then
  keys_update_frequency="0 * * * *"
else
  keys_update_frequency="${keys_update_frequency}"
fi

# Add to cron
if [ -n "$keys_update_frequency" ]; then
  croncmd="/home/${ssh_user}/update_ssh_authorized_keys.sh"
  cronjob="$keys_update_frequency $croncmd"
  ( crontab -u ${ssh_user} -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -u ${ssh_user} -
fi

# Append addition user-data script
${additional_user_data_script}
