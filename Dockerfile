FROM centos:6.4
MAINTAINER David Watson <david@bashton.com>

#
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# install asterisk
RUN yum install -y asterisk

# install supervisord
RUN yum install -y python-pip && pip install pip --upgrade
RUN pip install supervisor

# install sshd
RUN yum install -y openssh-server openssh-clients passwd

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && echo 'root:password' | chpasswd


ADD supervisord.conf /etc/
ADD asterisk /etc/asterisk/
EXPOSE 22
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
