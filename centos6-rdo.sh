#!/bin/bash -x

#RDO Install Assist v.140525-1845
#
yum install vim tracerourte system-config-firewall-tui system-config-network-tui

read -p "Do you want to Copy the sysctl.conf(y/n)?"
[ "$REPLY" == "y" ] && (cp conf/sysctl.conf /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
[ "$REPLY" == "n" ] && Skipped!

read -p "Do you want to Set SELinux(y/n)?"
[ "$REPLY" == "y" ] && (sed -i -e s/^SELINUX=.*/SELINUX=permissive/ /etc/selinux/config;setenforce 0)
[ "$REPLY" == "n" ] && Skipped!

read -p "Set the Repo(havana/icehouse/skip)?"
[ "$REPLY" == "havana" ] && yum install -y http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm
[ "$REPLY" == "icehouse" ] && yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm
[ "$REPLY" == "skip" ] && Skipped!

yum -y update
yum install -y openstack-packstack python-netaddr

read -p "Do you want to Custom installation of RDO OpenStack(y/n)?"
[ "$REPLY" == "y" ] && (packstack --gen-answer-file=answer.txt;echo "Edit the answer.txt File,After that Run the packstack command.")
[ "$REPLY" == "n" ] && packstack --allinone

