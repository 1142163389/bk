#!/bin/bash
ping  -w 2 -c 2 192.168.4.$1 &>/dev/null 
if [ $? -eq 1 ];then
    nmcli connection modify ens33 ipv4.method manual ipv4.addresses  192.168.4.$1/24       connection.autoconnect yes  
    nmcli connection up ens33 &>/dev/null
    sed -ri  "s/192.168.4.[0-9]{0,3}/192.168.4.$1/"  /etc/yum.repos.d/centos.repo
    sed -ri  "s/^192.168.4.[0-9]{0,3}/192.168.4.$1/"   /etc/hosts
else
   echo "此ip已经存在"
   exit
fi
 
hostname   $2
hostnamectl set-hostname $2

echo "初始化操作已完成，ip已经改为192.168.4.$1"
#执行此脚本  /root/ip.sh  $1是ip（最后两位）  $2是主机名
