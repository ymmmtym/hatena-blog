---
Title: LinuxにDockerをInstallするAnsible-Galaxy
Date: 2020-07-29T20:53:36+09:00
URL: https://ymmmtym.hateblo.jp/entry/2020/07/29/Linux%E3%81%ABDocker%E3%82%92Install%E3%81%99%E3%82%8BAnsible-Galaxy
EditURL: https://blog.hatena.ne.jp/ymmmtym/ymmmtym.hateblo.jp/atom/entry/26006613606657488
---

# はじめに

LinuxにDockerをインストールするたびに、

「ubuntu docker install」
「centos docker install」

などをググって、Docker公式サイトより手動でインストールしていました。

毎回インストールするのは手間なので、自動化したいと思っていた矢先、
OSSで素晴らしいansible-galaxyを見つけましたので、紹介したいと思います。

## 使用するansible-galaxy

- [Ansible Galaxy](https://galaxy.ansible.com/geerlingguy/docker)
- [geerlingguy/ansible-role-docker: Ansible Role - Docker](https://github.com/geerlingguy/ansible-role-docker)

## Ansible Playbookを書いてみる

VirtualBox上にUbuntu20.04のVMを作成します。
Vagrantを用いて、Provisioning ToolとしてAnsibleを使用し、そのPlaybookでDockerをインストールします。

### Vagrantfileを作成する

以下の`Vagrantfile`を作成します。
ホスト名は`ansible-docker`、IPアドレスは`192.168.0.3/24`としてあり、後ほどansibleで使用します。

```Vagrantfile
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.define "ansible-docker" do |node|
    node.vm.box = "bento/ubuntu-20.04"
    node.vm.hostname = "ansible-docker"
    node.vm.network "public_network", ip: "192.168.0.3", netmask: "255.255.255.0", bridge: "en1: Wi-Fi (AirPort)"
    node.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
  end


  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "./install_docker.yml"
    ansible.inventory_path = "./inventory.ini"
    ansible.limit = 'all'
  end

end
```

### roleをインストールする

rolesディレクトリを作成して、その中に今回使用するroleをインストールします。

```bash
mkdir roles
ansible-galaxy install geerlingguy.docker -p roles/
```

### InventoryとPlaybookを作る

`inventory.ini`を作成する

```ini
[ansible-docker]
192.168.0.3
```

今回のメインである`install_docker.yml`を作成する

```yml
---
- hosts: all
  roles:
    - role: geerlingguy.docker
      become: yes
```

## Playbookを実行する

ディレクトリ構造は以下のようになっていると思います。

```
.
├── Vagrantfile
├── install_docker.yml
├── inventory.ini
└── roles
     └── geerlingguy.docker
         ├── LICENSE
         ├── README.md
         ├── defaults
         │   └── main.yml
         ├── handlers
         │   └── main.yml
         ├── meta
         │   └── main.yml
         ├── molecule
         │   └── default
         │       ├── converge.yml
         │       └── molecule.yml
         └── tasks
             ├── docker-compose.yml
             ├── docker-users.yml
             ├── main.yml
             ├── setup-Debian.yml
             └── setup-RedHat.yml
```

以下のコマンドでプロビジョニングしてみます。

```bash
vagrant provision
```

docker,docker-composeがインストールされていることを確認できました。

```
vagrant@ansible-docker:~$ sudo docker -v
Docker version 19.03.12, build 48a66213fe
vagrant@ansible-docker:~$ sudo docker-compose -v
docker-compose version 1.26.0, build d4451659
```
