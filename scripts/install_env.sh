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
#安装基础依赖
    which wget >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y wget
    fi
    if [ ! "$(rpm -qa | grep epel-release)" ]; then
        yum install -y epel-release
    fi
    if grep -q 'mirror.centos.org' /etc/yum.repos.d/CentOS-Base.repo; then
        wget -qO /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
        sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
        yum clean all
    fi
    if grep -q 'mirrors.fedoraproject.org' /etc/yum.repos.d/epel.repo; then
        wget -qO /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
        sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/epel.repo
        yum clean all
    fi
    which vim >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y vim
    fi
    which gcc >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y gcc
    fi
    which openssl >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y openssl
    fi
    which gcc-c++ >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y gcc-c++
    fi
    which chrony >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y chrony
    fi
    which zip >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y zip
    fi
    which unzip >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y unzip
    fi
    which openssl-devel >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y openssl-devel
    fi
    which lrzsz >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y lrzsz
    fi
    which net-tools >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y net-tools
    fi
      which  chrony  >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y  chrony 
    fi
     which  ntpdate  >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y  ntpdate
    fi
# 禁用selinux
    sed -i 's/SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
    setenforce 0
#firewall
    if [ ! "$(firewall-cmd --list-all | grep 80)" ]; then
    firewall-cmd --zone=public --add-port=80/tcp --permanent
    firewall-cmd --reload
    fi
    if [ ! "$(firewall-cmd --list-all | grep 22)" ]; then
        firewall-cmd --zone=public --add-port=22/tcp --permanent
        firewall-cmd --reload
    fi
    if [ ! "$(firewall-cmd --list-all | grep 3306)" ]; then
        firewall-cmd --zone=public --add-port=3306/tcp --permanent
        firewall-cmd --reload
    fi
    if [ ! "$(firewall-cmd --list-all | grep 443)" ]; then
        firewall-cmd --zone=public --add-port=443/tcp --permanent
        firewall-cmd --reload
    fi
    if [ ! "$(firewall-cmd --list-all | grep 6379)" ]; then
        firewall-cmd --zone=public --add-port=6379/tcp --permanent
        firewall-cmd --reload
    fi
    if [ ! "$(firewall-cmd --list-all | grep 8080)" ]; then
        firewall-cmd --zone=public --add-port=8080/tcp --permanent
        firewall-cmd --reload
    fi
#关闭swap
swapoff -a 
sed -ri 's/.*swap.*/#&/' /etc/fstab
#时间同步
cp -a /etc/chrony.conf /etc/chrony.conf.bak
sed -i "s%^server%#server%g" /etc/chrony.conf
echo "server ntp.aliyun.com iburst" >> /etc/chrony.conf
systemctl restart chronyd.service
systemctl enable  chronyd.service
#操作系统检测
echo -ne "CentOS7 Check \t........................ "
if [ -f /etc/redhat-release ];then
  osVersion=`cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+'`
  majorVersion=`echo $osVersion | awk -F. '{print $1}'`
  if [ "x$majorVersion" == "x" ];then
    echo -e "[\033[31m ERROR \033[0m] 操作系统类型版本不符合要求，请使用 CentOS 7 64 位版本"
    flag=1
  else
    if [[ $majorVersion == 7 ]];then
      is64bitArch=`uname -m`
      if [ "x$is64bitArch" == "xx86_64" ];then
         echo -e "[\033[32m OK \033[0m]"
      else
         echo -e "[\033[31m ERROR \033[0m] 操作系统必须是 64 位的，32 位的不支持"
         flag=1
      fi
    else
      echo -e "[\033[31m ERROR \033[0m] 操作系统类型版本不符合要求，请使用 CentOS 7"
      flag=1
    fi
  fi
else
    echo -e "[\033[31m ERROR \033[0m] 操作系统类型版本不符合要求，请使用 CentOS 7"
    flag=1
fi

#CPU检测
echo -ne "CPU2    Check \t........................ "
processor=`cat /proc/cpuinfo| grep "processor"| wc -l`
if [ $processor -lt 2 ];then
  echo -e "[\033[31m ERROR \033[0m] CPU 小于 2核，JumpServer 所在机器的 CPU 需要至少 2核"
  flag=1
else
  echo -e "[\033[32m OK \033[0m]"
fi

#内存检测
echo -ne "Memory4 Check \t........................ "
memTotal=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`
if [ $memTotal -lt 3750000 ];then
  echo -e "[\033[31m ERROR \033[0m] 内存小于 4G，JumpServer 所在机器的内存需要至少 4G"
  flag=1
else
  echo -e "[\033[32m OK \033[0m]"
fi

if [ $flag -eq 1 ]; then
  echo "安装环境检测未通过，请查阅上述环境检测结果"
  exit 1
fi
