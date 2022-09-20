# docker-openvpn
## 需求

通过vpn直接访问内网容器ip可以直接登录，不再需要先登入公网IP再跳转到内网容器内部。



### 访问示意图

```bash
互联网（openvpn client）-->（公网ip）服务器（私网ip:172.18.0.10）-->服务器端容器（内网172.18.0.8）
```



## 克隆项目

```bash
git clone https://github.com/liyohecn/docker-openvpn.git
```



## openvpn服务端配置

### 拉取镜像

```bash
docker pull kylemanna/openvpn
```

### 创建映射目录

```bash
mkdir conf
```

### 生成配置文件(run.sh中已经初始化，无需操作)

```bash
ovpn_genconfig -u tcp://localhost
```

### 生成密钥文件(run.sh中已经初始化，无需操作)

```bash
ovpn_initpki nopass
```

### 生成客户端证书(run.sh中已经初始化，无需操作)

liyohe 改成其他名字

```bash
easyrsa build-client-full liyohe nopass
```

### 启动openvpn

```bash
docker-compose up -d
```



## openvpn用户管理

### 添加用户脚本(docker-compse中已经挂载，无需操作)

`vim add_user.sh`

```bash
#!/bin/bash
read -p "please your username: " NAME
easyrsa build-client-full $NAME nopass
ovpn_getclient $NAME > /etc/openvpn/"$NAME".ovpn
```

### 删除用户脚本(docker-compse中已经挂载，无需操作)

`vim del_user.sh`

```bash
#!/bin/bash
read -p "Delete username: " DNAME
easyrsa revoke $DNAME
easyrsa gen-crl
kylemanna/openvpn rm -f /etc/openvpn/pki/reqs/"DNAME".req
rm -f /etc/openvpn/pki/private/"DNAME".key
rm -f /etc/openvpn/pki/issued/"DNAME".crt
```

### 添加用户

#### 进入容器

```bash
docker exec -it openvpn /bin/bash
```

#### 执行脚本

```bash
sh /script/add_user.sh 
# 输入要添加的用户名，回车后输入刚才创建的私钥密码

# 退出容器
exit
```

#### 重启容器

```bash
docker-compose restart
```

创建的证书在`./conf`目录下。



## 划分网段

### 设置 vpn网段

```bash
vim conf/openvpn.conf

# 修改 server 192.168.255.0 255.255.255.0
server 10.10.1.0 255.255.0.0

# 修改 route 192.168.255.0 255.255.255.0
route 10.10.1.0 255.255.0.0

```

### 重启生效

```bash
docker-compose restart
```



## 设置客户端固定IP

### 修改服务器配置

```bash
vim conf/openvpn.conf

# 添加一行
client-config-dir ccd
```

### 设置固定IP

```bash
# 这里将 liyohe 替换为 需要的 用户名
cat conf/ccd/liyohe
ifconfig-push 10.10.1.5 10.10.1.6
```

### 重启生效

```bash
docker-compose restart
```



## 配置 出站流量 网卡(正常无需设置)

```bash
iptables -t nat -I POSTROUTING -p all -s 10.10.167.0/32 -j SNAT --to-source 10.0.0.11

iptables -t nat -I POSTROUTING -p all -s 10.10.212.0/32 -j SNAT --to-source 10.0.0.12
```



## openvpn客户端配置

官网下载[客户端](https://openvpn.net/vpn-client/)

从服务端把证书拷贝到桌面上，并将证书`liyohe.ovpn`直接导入到客户端内。然后输入容器内部IP就可以直接访问docker内部容器了。
