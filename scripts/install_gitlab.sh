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
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
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
#启动服务
    if [ ! "$(systemctl status sshd | systemctl enable sshd|grep Active | grep running)" ]; then
        start_sshd
    fi
    if [ ! "$(systemctl status postfix |systemctl enable postfix| grep Active | grep running)" ]; then
        start_postfix
    fi
#安装gitlab
     which gitlab-ee >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y gitlab-ee
    fi 
#防火墙
    if [ ! "$(firewall-cmd --list-all | grep http)" ]; then
        firewall-cmd --permanent --add-service=http
        firewall-cmd --reload
    fi
    if [ ! "$(firewall-cmd --list-all | grep https)" ]; then
        firewall-cmd --permanent --add-service=https
        firewall-cmd --reload
    fi