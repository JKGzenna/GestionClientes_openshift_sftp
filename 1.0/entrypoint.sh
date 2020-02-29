#!/bin/bash
## SETUP HOST KEYS ALWAYS WITH SAME RSA KEYS PROVIDED IN DOCKERFILE WITH 'authorized_keys_chile'
## FOLDER, THIS ALLOWS THAT USER DON'T CHANGE THE LINE OF THIS SFTP HOST IN YOUR 'know_hosts' FILE
## OR DELETE THIS FILE WITH EACH REBOOT OF SERVICE POD OR ANY UPDATE
echo -e ",s/10001/`id -u`/g\\012 w" | ed -s /etc/passwd && \
# Always generate new host keys for replace then with 'authorized_keys_chile'
ssh-keygen -A && \
# Create /home/sftp_user folder, then create authorized_keys file for replace then, and finally fix permissions
mkdir -p /home/sftp_user/.ssh && \
touch /home/sftp_user/.ssh/authorized_keys && \
chmod 700 /home/sftp_user/.ssh && \
chmod 600 /home/sftp_user/.ssh/authorized_keys && \
# Create /var/sftp/sftp_user folder where mounts persistent volume 'sftpfiles'
mkdir -p /var/sftp/sftp_user && \
# Copy 'authorized_keys' file provided in Dockerfile from /tmp/ to /home/sftp_user/.ssh and replace the created before
cat  /tmp/authorized_keys > /home/sftp_user/.ssh/authorized_keys && \
# Replace the new generated host keys with keys of 'authorized_keys_chile' folder and fix permissions
cat  /tmp/ssh_host_dsa_key > /etc/ssh/ssh_host_dsa_key && \
chmod 600 /etc/ssh/ssh_host_dsa_key && \

#creo que la ecdsa no hace falta ya que el protocol 2 del sshd.conf no la necesita
cat  /tmp/ssh_host_ecdsa_key > /etc/ssh/ssh_host_ecdsa_key && \
chmod 600 /etc/ssh/ssh_host_ecdsa_key && \

cat  /tmp/ssh_host_rsa_key > /etc/ssh/ssh_host_rsa_key && \
chmod 600 /etc/ssh/ssh_host_rsa_key && \
# Restart bash
exec /usr/sbin/sshd -D