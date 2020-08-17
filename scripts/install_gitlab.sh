#!/usr/bin/env bash
# coding: utf-8
# Copyright (c) 2020
# Gmail: lucky@centoscn.vip
# blog:  www.centoscn.vip
flag=0
echo -ne "User   Check \t........................ "
isRoot=`id -u -n | grep root | wc -l`
if [ "x$isRoot" == "x1" ];then
  echo -e "[\033[32m OK \033[0m]"
else
  echo -e "[\033[31m ERROR \033[0m] 请用 root 用户执行安装脚本"
  flag=1
fi
echo
cat << EOF

       *.                  *.
      ***                 ***
     *****               *****
    .******             *******
    ********            ********
   ,,,,,,,,,***********,,,,,,,,,
  ,,,,,,,,,,,*********,,,,,,,,,,,
  .,,,,,,,,,,,*******,,,,,,,,,,,,
      ,,,,,,,,,*****,,,,,,,,,.
         ,,,,,,,****,,,,,,
            .,,,***,,,,
                ,*,.
  


     _______ __  __          __
    / ____(_) /_/ /   ____ _/ /_
   / / __/ / __/ /   / __ `/ __ \
  / /_/ / / /_/ /___/ /_/ / /_/ /
  \____/_/\__/_____/\__,_/_.___/
EOF
#安装基础依赖
    which policycoreutils-python >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y policycoreutils-python
    fi
    which openssh-server >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y openssh-server
    fi
    which postfix >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y postfix
    fi
    which cronie  >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y cronie 
    fi
    which curl  >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y curl 
    fi
    which wget >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y wget
    fi
#启动服务
function start_service() {
systemctl start sshd 
systemctl status sshd 
systemctl enable sshd
systemctl start postfix
systemctl status postfix 
systemctl enable postfix
}
#下载rpm包
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
#安装gitlab
     which gitlab-ce >/dev/null 2>&1
    if [ $? -ne 0 ];then
         yum install -y gitlab-ce
    fi 
#防火墙
    if [ ! "$(firewall-cmd --list-all | grep http)" ]; then
        firewall-cmd --permanent --add-service=http
        firewall-cmd --reload
    fi
    if [ ! "$(firewall-cmd --list-all | grep ssh)" ]; then
        firewall-cmd --permanent --add-service=https
        firewall-cmd --reload
    fi
#重新配置并启动
gitlab-ctl reconfigure