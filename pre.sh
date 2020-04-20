#!/bin/bash
if [  ! -z $http_proxy  ];then
 echo  '$http_proxy'为非空，值为"$http_proxy"
 exit
fi

if [ ! -z $https_proxy ];then 
 echo '$https_proxy'为非空，值为"$https_proxy"
 exit
fi

systemctl stop NetworkManager
systemctl disable NetworkManager

chmod +x /etc/resolv.conf 
chattr -i /etc/resolv.conf 

systemctl stop firewalld
systemctl disable firewalld

setenforce 0  &>/dev/null
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

 

echo "root soft nofile 102400
root hard nofile 102400"  >>  /etc/security/limits.conf

echo  'ulimit -Hn 102400
ulimit -Sn 102400' >> /etc/profile


if   [ ! -d /data ];then 
mkdir /data
fi 
echo "开始解压，请稍等..."
tar xf /root/bkce_src-5.1.27.tar.gz  -C /data  && tar xf /root/install_ce-1.6.24.168.tgz  -C /data   &&tar xf /root/ssl_certificates.tar.gz  -C /data/src/cert 
if [ $? -ne 0 ];then 
echo "没有找到软件包，或者软件包名字不对"
fi

mkdir /etc/yum.repos.d/all                &>/dev/null
mv /etc/yum.repos.d/* /etc/yum.repos.d/all/  &>/dev/null
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.cloud.tencent.com/repo/centos7_base.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.cloud.tencent.com/repo/epel-7.repo
yum clean all
yum repolist 
 if [ $?  -ne 0 ];then
  echo "初始化失败"
  exit
 fi

which rsync   >/dev/null
if [ $? -ne 0 ];then
 yum -y install rsync
fi

chrony () {
 yum -y install chrony       &>/dev/null
 sed -ri  "s/^server.*iburst$/#server 3.centos.pool.ntp.org iburst/g"  /etc/chrony.conf
 echo  server ntp.aliyun.com  iburst  >> /etc/chrony.conf
 systemctl restart chronyd
 systemctl enable chronyd
 sleep 10s
 local b='^*'
 local a=`chronyc sources | awk  'NR==4{print $1}'`
 if   [ "$a"  != "$b" ];then
 echo "时间校时不通过,请手动校时"
 fi
  }

ntp () {
 systemctl stop ntpd
 systemctl disable ntpd
 yum -y remove ntp           &>/dev/null
 chrony
   }

ss -lnput | grep ntpd    &>/dev/null
 if [ $? -eq 0 ]; then
    ntp
 else
      ss -lnput | grep chronyd  &>/dev/null
       if [ $? -eq 0 ]; then
        sed -ri  "s/^server.*iburst$/#server 3.centos.pool.ntp.org iburst/g"  /etc/chrony.conf
        echo  server ntp.aliyun.com  iburst  >> /etc/chrony.conf
       else
        chrony
       fi
 fi

echo "蓝鲸准备已经完成，请执行source /etc/profile 或者重启后进行安装！"

