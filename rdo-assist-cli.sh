#!/bin/bash -x

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

yum -y update
echo "Need Reboot!"