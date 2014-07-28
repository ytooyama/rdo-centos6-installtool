RDO Install Assist Tool
==========

###これはなに
RDOでOpenStack環境を作るスクリプトです。ただ、公式の手順のコマンドを並べただけです｡

###RDOってなに？

[公式サイト](http://jp-redhat.com/openstack/rdo/)をご覧ください。

###環境について
以下の環境で実行することを想定しています｡

- CentOS 6.4以降 or Scientific Linux 6.5
  - havana
  - icehouse
- Fedora 20
  - icehouse

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
※Fedora 20ではNetworkManagerを使って構築したほうがうまくいくようです。

- リポジトリーからパッケージをダウンロードします｡

```
# git clone -b v3.0 https://github.com/ytooyama/rdo-centos6-installtool.git
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
	Do you want to Custom installation of RDO OpenStack(auto/y/n/exit)?
	（RDO OpenStackをカスタムインストールするか）
```
- カスタムインストールを"auto"と入力すると自動インストールが行われます｡シェルスクリプトに追記すれば、その他の設定を書き換えてインストールすることができます。
- カスタムインストールを"y"と入力するとアンサーファイル(answer.txt)が作られます。
- カスタムインストールを"n"と入力するとall-in-oneインストールが行われます｡
- カスタムインストールを"exit"と入力するとpackstackコマンドを中止します。

- カスタムインストールで"y"を選択した場合はanswer.txtが生成されますので、
設定を書き込んだ後に以下のコマンドを実行すると、packstackによるOpenStackコンポーネントのインストールを続行します。

```
 # packstack --answer-file=answer.txt
```

- スクリプトが終わったら、NICの設定とNeutron Networkの設定を行います。

####Icehouseの場合

- <https://github.com/ytooyama/rdo-icehouse/blob/master/1-1-RDO-QuickStart-Local.md#step-7-ネットワーク設定の変更>
- <https://github.com/ytooyama/rdo-icehouse/blob/master/2-RDO-QuickStart-Networking.md>

####Havanaの場合

- <https://github.com/ytooyama/rdo-havana/blob/master/RDO-QuickStart-1.txt> など
