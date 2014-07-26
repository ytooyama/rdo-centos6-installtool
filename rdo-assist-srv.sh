#!/bin/bash

#RDO Install Assist v.140726-1930
#
# ディストリビューション名とバージョンを取得する(参考サイト)
#http://geektrainee.hatenablog.jp/entry/2013/11/27/022633

tmp=`cat /etc/issue | head -n 1`
DIST=`echo $tmp`

case $DIST in
"CentOS release 6.4 (Final)"|"CentOS release 6.5 (Final)")
  echo "You use the CentOS 6.4 or 6.5."
  echo "Please Use the kernel-2.6.32-358.123.2.openstack.el6,Because.This Kernel vxlan support!"
  yum install https://repos.fedorapeople.org/repos/openstack/openstack-icehouse/epel-6/kernel-2.6.32-358.123.2.openstack.el6.x86_64.rpm
  yum install vim traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
    [ "$REPLY" == "y" ] && (cp conf/sysctl.conf /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
    [ "$REPLY" == "n" ] && echo Skipped!
;;
"Scientific Linux release 6.5 (Carbon)")
  echo "You use the Scientific 6.5."
  echo "Please Use the kernel-2.6.32-358.123.2.openstack.el6,Because.This Kernel vxlan support!"
  yum install https://repos.fedorapeople.org/repos/openstack/openstack-icehouse/epel-6/kernel-2.6.32-358.123.2.openstack.el6.x86_64.rpm
  yum install vim traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
    [ "$REPLY" == "y" ] && (cp conf/sysctl.conf /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
    [ "$REPLY" == "n" ] && echo Skipped!
;;
"Fedora release 20 (Heisenbug)")
  echo "You use the Fedora 20."
  yum install vim net-tools traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
    [ "$REPLY" == "y" ] && (cat conf/source.txt >> /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
    [ "$REPLY" == "n" ] && echo Skipped!
;;
*)
  echo "You use the Unsupported version."
  exit 0
;;
esac

read -p "Do you want to Set SELinux(y/n)?"
[ "$REPLY" == "y" ] && (setenforce 0;sed -i -e s/^SELINUX=.*/SELINUX=permissive/ /etc/selinux/config)
[ "$REPLY" == "n" ] && echo Skipped!

read -p "Set the Repo(havana/icehouse/skip)?"
[ "$REPLY" == "havana" ]  &&  (yum install -y http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm;
                               yum -y update;
                               yum install -y openstack-packstack python-netaddr)
[ "$REPLY" == "icehouse" ] && (yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm;
                               yum -y update;
                               yum install -y openstack-packstack python-netaddr)
[ "$REPLY" == "skip" ] && echo Skipped!

read -p "Do you want to Custom installation of RDO OpenStack(auto/y/n/exit)?"
[ "$REPLY" == "auto" ] && (packstack --gen-answer-file=answer.txt;
                           sed -i -e s/^CONFIG_CINDER_INSTALL=.*/CONFIG_CINDER_INSTALL=n/ answer.txt;
                           sed -i -e s/^CONFIG_SWIFT_INSTALL=.*/CONFIG_SWIFT_INSTALL=n/ answer.txt;
                           sed -i -e s/^CONFIG_NAGIOS_INSTALL=.*/CONFIG_NAGIOS_INSTALL=n/ answer.txt;
                           sed -i -e s/^CONFIG_CEILOMETER_INSTALL=.*/CONFIG_CEILOMETER_INSTALL=n/ answer.txt;
                           sed -i -e s/^CONFIG_KEYSTONE_ADMIN_PW=.*/CONFIG_KEYSTONE_ADMIN_PW=admin/ answer.txt;
                           sed -i -e s/^CONFIG_NOVA_COMPUTE_PRIVIF=.*/CONFIG_NOVA_COMPUTE_PRIVIF=eth1/ answer.txt;
                           sed -i -e s/^CONFIG_NOVA_NETWORK_PUBIF=.*/CONFIG_NOVA_NETWORK_PUBIF=eth0/ answer.txt;
                           sed -i -e s/^CONFIG_NOVA_NETWORK_PRIVIF=.*/CONFIG_NOVA_NETWORK_PRIVIF=eth1/ answer.txt;
                           sed -i -e s/^CONFIG_PROVISION_DEMO=.*/CONFIG_PROVISION_DEMO=n/ answer.txt;
                           packstack --answer-file=answer.txt;
                           ln -s /root/keystonerc_admin /root/openrc;
                           echo "Please,Make the Neutron Networks.See README.md! https://github.com/ytooyama/rdo-centos6-installtool"
                           #workaraund see https://github.com/openstack/neutron/commit/a7da625571a5acb161246e62713da81526a8d86b
                           sed -i -e "s/# Example: mechanism drivers/# Example: mechanism_drivers/g" /etc/neutron/plugins/ml2/ml2_conf.ini
                           )
[ "$REPLY" == "y" ] && (packstack --gen-answer-file=answer.txt;
                        echo "Edit the answer.txt File,After that Run the 'packstack --answer-file=answer.txt' and System Update.")
[ "$REPLY" == "n" ] && (packstack --allinone;
                        ln -s /root/keystonerc_admin /root/openrc
                        #workaraund see https://github.com/openstack/neutron/commit/a7da625571a5acb161246e62713da81526a8d86b
                        sed -i -e "s/# Example: mechanism drivers/# Example: mechanism_drivers/g" /etc/neutron/plugins/ml2/ml2_conf.ini
                       )
[ "$REPLY" == "exit" ] && exit 0

yum -y update
echo "Need Reboot!"