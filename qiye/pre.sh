#!/bin/bash
if [  ! -z $http_proxy  ];then
 echo  '$http_proxy'为非空，值为"$http_proxy"
 exit
fi

if [ ! -z $https_proxy ];then 
 echo '$https_proxy'为非空，值为"$https_proxy"
 exit
fi

systemctl stop NetworkManager       &>/dev/null
systemctl disable NetworkManager    &>/dev/null

chmod +x /etc/resolv.conf 
chattr -i /etc/resolv.conf 

systemctl stop firewalld
systemctl disable firewalld

setenforce 0  &>/dev/null
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

 

echo "* soft nofile 102400
* hard nofile 102400"  >>  /etc/security/limits.conf

echo  'ulimit -Hn 102400
ulimit -Sn 102400' >> /etc/profile

wget 10.0.5.138/2.5.1.17/bkee_common-2.0.3.11.tgz
wget 10.0.5.138/2.5.1.17/bkee_product-2.5.1.17-pretest.tgz
wget 10.0.5.138/2.5.1.17/cert_ee-1.2.4_pretest.tgz
wget 10.0.5.138/2.5.1.17/install_ee-iam-08b6126e.tgz
wget 10.0.5.138/2.5.1.17/src_2.5.tgz


if   [ ! -d /data ];then 
mkdir /data
fi 
echo "开始解压，需要一定时间，请稍等..."
tar xf /root/bk/qiye/bkee_common-2.0.3.11.tgz   -C /data  &&
tar xf /root/bk/qiye/bkee_product-2.5.1.17-pretest.tgz  -C /data  && 
tar xf /root/bk/qiye/cert_ee-1.2.4_pretest.tgz  -C /data/src/cert && 
tar xf /root/bk/qiye/install_ee-iam-08b6126e.tgz  -C /data &&
tar xf /root/bk/qiye/src_2.5.tgz  -C /data  && 
cd /data/src/job/job/ && zip -u0 job-exec.war WEB-INF/lib/*.jar
if [ $? -ne 0 ];then 
echo "没有找到软件包，或者软件包名字不对"
exit
fi
cp /root/bk/qiye/install.config  /data/install/
sed -i "s/bk.com/liu.com/"  /data/install/globals.env
sed -ri "s/export PAAS_ADMIN_PASS='(\w+)'/export PAAS_ADMIN_PASS='123456'/"   /data/install/globals.env

echo "正在配置yum源,请稍等..."
mkdir /etc/yum.repos.d/all                &>/dev/null
mv /etc/yum.repos.d/* /etc/yum.repos.d/all/   &>/dev/null
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

bash /root/bk/qiye/configure_ssh_without_pass


echo "蓝鲸准备已经完成，请执行source /etc/profile 或者重启后进行安装！"
