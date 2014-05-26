RDO Install Assist Tool 
==========

###これはなに
RDOでOpenStack環境を作るスクリプトです。ただ、公式の手順のコマンドを並べただけです｡

###環境について
以下の環境で実行することを想定しています｡

- CentOS 6.5
- Fedora (Testing)
  - havana = Fedora 19   
  - icehouse = Fedora 20
 

###使いかた
- OSをインストールしてyum updateを実施します。
- リポジトリーからパッケージをダウンロードします｡
- シェルスクリプトを実行可能にします｡

```
	chmod +x centos6-rdo.sh
```

- シェルスクリプトを実行します｡

```
	./centos6-rdo.sh
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

- カスタムインストールを実行する場合、アンサーファイル(answer.txt)が作られてスクリプトは終了します｡
- answer.txtに設定を書き込んだ後、以下のコマンドを実行する必要があります｡

```
	packstack --answer-file=answer.txt
```

- 複数台構成にする場合は、カーネルパラメーターの修正やSELinuxの修正、IPアドレスの設定は予め各ノードの設定を行ってからpackstackコマンドを実施してください。

###RDOってなに？

[公式サイト](http://jp-redhat.com/openstack/rdo/)をご覧ください。