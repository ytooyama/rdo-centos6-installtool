#!/bin/bash

echo "RDO Install Assist v.4.1.141202-1700"
#
# ディストリビューション名とバージョンを取得する(参考サイト)
#http://geektrainee.hatenablog.jp/entry/2013/11/27/022633

#Check OSVersion
DIST=`cat /etc/redhat-release | head -n 1`

case $DIST in
"CentOS release 6.4 (Final)"|"CentOS release 6.5 (Final)"|"CentOS release 6.6 (Final)")
  echo "You use the CentOS 6.x."
  yum install traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
    [ "$REPLY" == "y" ] && (cp conf/sysctl.conf /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
    [ "$REPLY" == "n" ] && echo Skipped!
;;
"Scientific Linux release 6.4 (Carbon)"|"Scientific Linux release 6.5 (Carbon)"|"Scientific Linux release 6.6 (Carbon)")
  echo "You use the Scientific 6.x."
  yum install traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
    [ "$REPLY" == "y" ] && (cp conf/sysctl.conf /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
    [ "$REPLY" == "n" ] && echo Skipped!
;;
"Fedora release 20 (Heisenbug)")
  echo "You use the Fedora 20."
  yum install net-tools traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
    [ "$REPLY" == "y" ] && (cat conf/source.txt >> /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
    [ "$REPLY" == "n" ] && echo Skipped!
;;
"Red Hat Enterprise Linux Client release 7.0 (Maipo)")
echo "You use the RHEL7 Desktop."
yum install net-tools traceroute
read -p "Do you want to Copy the sysctl.conf(y/n)?"
[ "$REPLY" == "y" ] && (cat conf/source.txt >> /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
[ "$REPLY" == "n" ] && echo Skipped!
;;
"Scientific Linux release 7.0 (Nitrogen)")
echo "You use the Scientific 7."
yum install net-tools traceroute
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
echo "Finished!"