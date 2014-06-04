RDO Install Assist Tool
==========

###これはなに
RDOでOpenStack環境を作るスクリプトです。ただ、公式の手順のコマンドを並べただけです｡

###環境について
以下の環境で実行することを想定しています｡

- CentOS 6.5
  - havana
  - icehouse
- Fedora
  - icehouse = Fedora 20

###使いかた
- OSをインストールしてyum updateを実施します。
- IPアドレスを設定します｡
- NetworkManagerを終了して、networkサービスを実行します｡

```
# service NetworkManager stop
# service network start
# chkconfig NetworkManager off
# chkconfig network on
```
- Fedoraの場合はFirewalldを無効化してiptablesサービスを導入します｡

```
# systemctl disable firewalld
# systemctl stop firewalld

# yum install iptables-services

# touch /etc/sysconfig/iptables
# touch /etc/sysconfig/ip6tables
# systemctl start iptables
# systemctl start ip6tables
# systemctl enable iptables
# systemctl enable ip6tables
```

- リポジトリーからパッケージをダウンロードします｡

```
# git clone -b master https://github.com/ytooyama/rdo-centos6-installtool.git
```
-bオプションでバージョンを指定。最新版はmaster。

- シェルスクリプトを実行可能にします｡

```
# chmod +x rdo-assist-srv.sh
# chmod +x rdo-assist-cli.sh
```

- コントロールノード以外のノードでシェルスクリプトを実行します(単体構成時は不要)｡

```
 # ./rdo-assist-cli.sh
```

- コントロールノードでシェルスクリプトを実行します｡

```
 # ./rdo-assist-srv.sh
```

- 質問に答えます

```
	Do you want to Copy the sysctl.conf(y/n)?
	（デフォルトのカーネルパラメータを上書きするか）
	Do you want to Set SELinux(y/n)?
	（SELinuxを設定変更するか）
	Set the Repo(havana/icehouse/skip)?
	（インストールするOpenStackのバージョンを指定）
	Do you want to Custom installation of RDO OpenStack(y/n)?
	（RDO OpenStackをカスタムインストールするか）
```
- カスタムインストールをnと入力するとall-in-oneインストールが行われます｡
- カスタムインストールを実行する場合、アンサーファイル(answer.txt)が作られてスクリプトは終了します｡
- answer.txtに設定を書き込んだ後、以下のコマンドを実行する必要があります｡

```
 # packstack --answer-file=answer.txt
```

- 複数台構成にする場合は、カーネルパラメーターの修正やSELinuxの修正、IPアドレスの設定は予め各ノードの設定が正しく行われているか確認してからpackstackコマンドを実施してください。

###RDOってなに？

[公式サイト](http://jp-redhat.com/openstack/rdo/)をご覧ください。
