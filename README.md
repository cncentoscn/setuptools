# 自动安装脚本

安装文档 https://www.centoscn.vip/3178.html

- 全新安装的 Centos7 (7.x)
- 需要连接 互联网
- 使用 root 用户执行
- 由于国内有墙，部分yum源会失效

注: 脚本包含 selinux 和 firewalld 处理功能, 可以在 selinux 和 firewalld 开启的情况下正常使用

Use:

```
cd /opt
yum -y install  git
git clone --depth=1 https://github.com/cncentoscn/setuptools.git
cd setuptools/scripts/
```
Install 检测服务是否满足和安装依赖
```
./install_env.sh
```
install 安装docker
```
./install_docker.sh 
```
install 安装mariadb
```
./install_mariadb.sh
```
install 安装redis
```
./install_redis.sh
```
install 安装python3
```
./install_py3.sh

```
install 安装gitlab
```
./install_gitlab

```
install 安装Jenkins
```
./install_jenkins

```
