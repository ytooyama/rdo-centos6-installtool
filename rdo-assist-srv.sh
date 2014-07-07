#!/bin/bash -x

#RDO Install Assist v.140707-1100
#
# ディストリビューション名とバージョンを取得する(参考サイト)
#http://geektrainee.hatenablog.jp/entry/2013/11/27/022633

tmp=`cat /etc/issue | head -n 1`
DIST=`echo $tmp | awk '{print $1}'`

if [[ $DIST =~ "CentOS" ]]; then
  yum install vim traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
  [ "$REPLY" == "y" ] && (cp conf/sysctl.conf /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
  [ "$REPLY" == "n" ] && echo Skipped!
elif [[ $DIST =~ "Fedora" ]]; then
  yum install vim net-tools traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
  [ "$REPLY" == "y" ] && (cat conf/source.txt >> /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
  [ "$REPLY" == "n" ] && echo Skipped!
fi

read -p "Do you want to Set SELinux(y/n)?"
[ "$REPLY" == "y" ] && (setenforce 0;sed -i -e s/^SELINUX=.*/SELINUX=permissive/ /etc/selinux/config)
[ "$REPLY" == "n" ] && echo Skipped!

read -p "Set the Repo(havana/icehouse/skip)?"
[ "$REPLY" == "havana" ] && yum install -y http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm
[ "$REPLY" == "icehouse" ] && yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm
[ "$REPLY" == "skip" ] && echo Skipped!

yum -y update
yum install -y openstack-packstack python-netaddr

read -p "Do you want to Custom installation of RDO OpenStack(y/n/exit)?"
[ "$REPLY" == "y" ] && (packstack --gen-answer-file=answer.txt;echo "Edit the answer.txt File,After that Run the packstack command.")
[ "$REPLY" == "n" ] && (packstack --allinone;ln -s /root/keystonerc_admin /root/openrc)
[ "$REPLY" == "exit" ] && exit 0

file1=/root/keystonerc_admin
file2=/root/keystonerc_demo

echo "Access the Horizon by Web Browser."

if [ -e $file1 ]; then
echo "The default users are: admin,Password is";
cat /root/keystonerc_admin |grep OS_PASSWORD
else
echo "User admin is Not Found!"
fi

if [ -e $file2 ]; then
echo "The default users are: demo,Password is";
cat /root/keystonerc_demo |grep OS_PASSWORD
else
echo "User demo is Not Found!"
fi

echo "Finished!"