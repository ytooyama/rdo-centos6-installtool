#!/bin/bash -x

#RDO Install Assist v.140604-950
#
# ディストリビューション名とバージョンを取得する(参考サイト)
#http://geektrainee.hatenablog.jp/entry/2013/11/27/022633

tmp=`cat /etc/issue | head -n 1`
DIST=`echo $tmp | awk '{print $1}'`

if [[ $DIST =~ "CentOS" ]]; then
  yum install vim traceroute system-config-firewall-tui system-config-network-tui
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
  [ "$REPLY" == "y" ] && (cp conf/sysctl.conf /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
  [ "$REPLY" == "n" ] && echo Skipped!
elif [[ $DIST =~ "Fedora" ]]; then
  yum install vim net-tools traceroute system-config-network-tui
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
  [ "$REPLY" == "y" ] && (cat conf/source.txt >> /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
  [ "$REPLY" == "n" ] && echo Skipped!
fi

read -p "Do you want to Set SELinux(y/n)?"
[ "$REPLY" == "y" ] && (setenforce 0;sed -i -e s/^SELINUX=.*/SELINUX=permissive/ /etc/selinux/config)
[ "$REPLY" == "n" ] && echo Skipped!

yum -y update