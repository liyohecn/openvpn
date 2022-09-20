# openvpn-as安装

> openvpn-as 2.9.0 版本安装激活
>
> 本文档 以 Ubuntu 18.04 为例



## 克隆项目

```bash
https://github.com/liyohecn/openvpn.git
```



## 进入软件目录&切换root

```bash
cd software/openvpn-as-2.9.0
su root
```



## 安装依赖

```bash
apt-get update 

apt-get install -y bridge-utils file gnupg iproute2 iptables libatm1 libelf1 libexpat1 libip4tc0 libip6tc0 libiptc0 liblzo2-2 libmagic-mgc libmagic1 libmariadb3 libmnl0 libmpdec2 libmysqlclient20 libnetfilter-conntrack3 libnfnetlink0 libpcap0.8 libpython3-stdlib libpython3.6-minimal libpython3.6-stdlib libxtables12 mime-support multiarch-support mysql-common net-tools python3 python3-decorator python3-ldap3 python3-migrate python3-minimal python3-mysqldb python3-pbr python3-pkg-resources python3-pyasn1 python3-six python3-sqlalchemy python3-sqlparse python3-tempita python3.6 python3.6-minimal sqlite3 xz-utils

```



## 安装软件

```bash
# 下载 bundled-clients（文件过大GitHub未上传，下载需要翻墙）
wget https://swupdate.openvpn.net/as/clients/openvpn-as-bundled-clients-25.deb

# 下载 openvpn-as (software中已经包含) 
# wget https://swupdate.openvpn.net/as/openvpn-as_2.9.0-5c5bd120-Ubuntu18_amd64.deb

# 安装
dpkg -i openvpn-as-bundled-clients-25.deb openvpn-as_2.9.0-5c5bd120-Ubuntu18_amd64.deb
```



## 设置用户密码

```bash
passwd openvpn
```



### 激活软件

```bash
# 关闭软件
systemctl stop openvpnas

# 拷贝激活文件
cp pyovpn-2.0-py3.6.egg /usr/local/openvpn_as/lib/python/

# 启动软件
systemctl start openvpnas
```



## UI中配置VPN

```bash
https://host:443
https://host:943
```

