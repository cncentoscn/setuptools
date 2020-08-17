#!/usr/bin/env bash
# coding: utf-8
# Copyright (c) 2020
# Gmail: lucky@centoscn.vip
# blog:  www.centoscn.vip
which wget >/dev/null 2>&1
if [ $? -ne 0 ];then
    yum install -y wget
fi
#下载yum源
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
#安装key
rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
#安装基础服务
which upgrade >/dev/null 2>&1
if [ $? -ne 0 ];then
    yum install -y upgrade
fi
which jenkins >/dev/null 2>&1
if [ $? -ne 0 ];then
    yum install -y jenkins
fi
which java-1.8.0-openjdk-devel >/dev/null 2>&1
if [ $? -ne 0 ];then
    yum install -y java-1.8.0-openjdk-devel
fi
#启动服务
systemctl start jenkins
systemctl enable  jenkins
systemctl status jenkins
