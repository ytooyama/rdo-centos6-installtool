#!/bin/bash
#
echo "RDO Install Assist v.140807-1020"
#
#
# ディストリビューション名とバージョンを取得する(参考サイト)
#http://geektrainee.hatenablog.jp/entry/2013/11/27/022633

function REPOSET
{
  read -p "Set the Repo(havana/icehouse/skip)?"
  [ "$REPLY" == "havana" ]  &&  (yum install -y http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm;
    selver=havana;
    yum -y update;
    yum install -y openstack-packstack python-netaddr)
  [ "$REPLY" == "icehouse" ] && (yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm;
    selver=icehouse;
    yum -y update;
    yum install -y openstack-packstack python-netaddr)
  [ "$REPLY" == "skip" ] && echo Skipped!
}

function REPOSETIH
{
  read -p "Set the Repo(icehouse/skip)?"
  [ "$REPLY" == "icehouse" ] && (yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm;
    selver=icehouse;
    yum -y update;
    yum install -y openstack-packstack python-netaddr)
  [ "$REPLY" == "skip" ] && echo Skipped!
}

##Workaround see https://github.com/openstack/neutron/commit/a7da625571a5acb161246e62713da81526a8d86b
function BUG1
{
if test $selver = "icehouse" ; then
    sed -i -e "s/# Example: mechanism drivers/# Example: mechanism_drivers/g" /etc/neutron/plugins/ml2/ml2_conf.ini
elif test $selver = "havana" ; then
    echo "Skiped!"
else
    read -p "Do you want to Fix the ml2_conf.ini(y/n)?"
      [ "$REPLY" == "y" ] && (sed -i -e "s/# Example: mechanism drivers/# Example: mechanism_drivers/g" /etc/neutron/plugins/ml2/ml2_conf.ini)
      [ "$REPLY" == "n" ] && echo Skipped!
fi
}

#Check OSVersion
DIST=`cat /etc/redhat-release | head -n 1`

case $DIST in
"CentOS release 6.5 (Final)")
  echo "You use the CentOS 6.5."
  yum install traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
    [ "$REPLY" == "y" ] && (cp conf/sysctl.conf /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
    [ "$REPLY" == "n" ] && echo Skipped!
#read function
REPOSET
;;
"Scientific Linux release 6.4 (Carbon)"|"Scientific Linux release 6.5 (Carbon)")
  echo "You use the Scientific 6.4 or 6.5."
  yum install traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
    [ "$REPLY" == "y" ] && (cp conf/sysctl.conf /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
    [ "$REPLY" == "n" ] && echo Skipped!
#read function
REPOSET
;;
"Fedora release 20 (Heisenbug)")
  echo "You use the Fedora 20."
  yum install net-tools traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
    [ "$REPLY" == "y" ] && (cat conf/source.txt >> /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
    [ "$REPLY" == "n" ] && echo Skipped!
#read function
REPOSETIH
;;
"Scientific Linux release 7.0 rolling (Nitrogen)"|"Scientific Linux release 7.0 (Nitrogen)")
  echo "You use the Scientific 7."
  yum install net-tools traceroute
  read -p "Do you want to Copy the sysctl.conf(y/n)?"
    [ "$REPLY" == "y" ] && (cat conf/source.txt >> /etc/sysctl.conf;sysctl -e -p /etc/sysctl.conf)
    [ "$REPLY" == "n" ] && echo Skipped!
#read function
REPOSETIH
;;
*)
  echo "You use the Unsupported Version."
  exit 0
;;
esac

read -p "Do you want to Set SELinux(y/n)?"
[ "$REPLY" == "y" ] && (setenforce 0;sed -i -e s/^SELINUX=.*/SELINUX=permissive/ /etc/selinux/config)
[ "$REPLY" == "n" ] && echo Skipped!

read -p "Do you want to Customise installation of RDO OpenStack(auto/y/n/exit)?"
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
                           ##if "all-in-one install" then set "local",else "Multi" then Comment Out.
                           sed -i -e s/^CONFIG_NEUTRON_ML2_TYPE_DRIVERS=.*/CONFIG_NEUTRON_ML2_TYPE_DRIVERS=local/ answer.txt;
                           sed -i -e s/^CONFIG_NEUTRON_ML2_TENANT_NETWORK_TYPES=.*/CONFIG_NEUTRON_ML2_TENANT_NETWORK_TYPES=local/ answer.txt;
                           sed -i -e s/^CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE=.*/CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE=local/ answer.txt;
                           ## ex. The list of IP addresses of the server on which to install the
                           ## network service such as Nova network or Neutron
                           ##if "all-in-one install" then Comment out,else "Multi" then set "IP Address".
                           #sed -i -e s/^CONFIG_NETWORK_HOSTS=.*/CONFIG_NETWORK_HOSTS=192.168.1.102/ answer.txt;

                           ##Run Packstack!
                           packstack --answer-file=answer.txt;
                           ln -s /root/keystonerc_admin /root/openrc;
                           #read function
                           BUG1
                           echo "Please,Make the Neutron Networks.See README.md! https://github.com/ytooyama/rdo-centos6-installtool"
                           )
[ "$REPLY" == "y" ] && (packstack --gen-answer-file=answer.txt;
                        echo "Edit the answer.txt File,After that Run the 'packstack --answer-file=answer.txt' and System Update.")
[ "$REPLY" == "n" ] && (packstack --allinone;
                        ln -s /root/keystonerc_admin /root/openrc
                        #read function
                        BUG1
                        )
[ "$REPLY" == "exit" ] && exit 0

read -p "Do you want to System Update now(y/n)?"
  [ "$REPLY" == "y" ] && yum -y update
  [ "$REPLY" == "n" ] && echo "Skip the Updates!"
echo "Finished,Need Reboot!"
