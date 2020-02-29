FROM centos/s2i-core-centos7
MAINTAINER Juan Luis Goldaracena

## INSTALL REQUISITES
RUN yum repolist && yum install epel-release -y
RUN yum -y install openssh-server curl openssh openssh-clients net-tools bind-utils nmap telnet nc ed -y
RUN yum clean all
RUN rm -rf /var/cache/yum

## SETUP OPENSSH
RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
RUN sed -i 's/#Port.*$/Port 2222/' /etc/ssh/sshd_config
RUN chmod 775 /var/run
RUN mkdir /var/sftp && chmod 775 /var/sftp
RUN rm -f /var/run/nologin

## SETUP SFTP USER
RUN adduser --system -s /bin/bash -u 10001 -g 0 sftp_user # uid to replace later
RUN chmod 775 /etc/ssh /home # keep writable for openshift user group (root)
ADD sshd_conf /etc/ssh/sshd_config
RUN chmod 660 /etc/ssh/sshd_config
RUN chmod 664 /etc/passwd /etc/group # to help uid fix
RUN touch /var/log/sshd.log && chgrp -R 0 /var/log/sshd.log && chmod 0775 /var/log/sshd.log

## COPY 'authorized_keys' FILE PROVIDED IN DOCKERFILE BUILD AND ALWAYS WITH SAME AUTHORIZED USERS
COPY /authorized_keys/authorized_keys /tmp
RUN  chmod 775 /tmp/authorized_keys

## COPY SSH RSA HOST KEYS PROVIDED IN DOCKERFILE BUILD AND ALWAYS SAME
COPY /host_keys/ssh_host_dsa_key /tmp
RUN  chmod 775 /tmp/ssh_host_dsa_key
COPY /host_keys/ssh_host_rsa_key /tmp
RUN  chmod 775 /tmp/ssh_host_rsa_key

## COPY ENTRYPOINT
COPY entrypoint.sh /tmp/entrypoint.sh

## EXPOSE PORT
EXPOSE 2222

## USER
USER sftp_user

CMD ["/tmp/entrypoint.sh"]