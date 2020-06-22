#!/bin/sh


# copy template to config file, if empty or does not exist
if [ ! -f /etc/ssh/sshd_config ] || [ ! -s /etc/ssh/sshd_config ]
then
  cat /sshd_config > /etc/ssh/sshd_config
fi
# create ssh key, if not exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]
then
  /usr/bin/ssh-keygen -A
fi
# replace authorized_keys with env SSH_CLIENT_KEY, if SSH_CLIENT_KEY is defined
if [ ! -z ${SSH_CLIENT_KEY+x} ];
then
  echo "$SSH_CLIENT_KEY" > ~/.ssh/authorized_keys
fi

# configurate sshd_config for key only
cp /etc/ssh/sshd_config ~/sshd_config.temp
sed -i "s/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/g" ~/sshd_config.temp
sed -i "s/^#*UsePAM.*/UsePAM no/g" ~/sshd_config.temp
sed -i "s/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/g" ~/sshd_config.temp
sed -i "s/^#*PasswordAuthentication.*/PasswordAuthentication no/g" ~/sshd_config.temp
sed -i "s/^#*PermitRootLogin.*/PermitRootLogin no/g" ~/sshd_config.temp
sed -i "s/^#*GatewayPorts.*/GatewayPorts yes/g" ~/sshd_config.temp
sed -i "s/^#*AllowTcpForwarding.*/AllowTcpForwarding yes/g" ~/sshd_config.temp
sed -i "s/^#*Port.*/Port 2222/g" ~/sshd_config.temp
# if file mounted in docker, `mv` ist not allowed
cat ~/sshd_config.temp > /etc/ssh/sshd_config;
rm ~/sshd_config.temp

echo ~

/usr/sbin/sshd -D -e
