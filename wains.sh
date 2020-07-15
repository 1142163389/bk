#!/bin/bash
source /data/install/utils.fc 
cd /data/bkce/miniweb/download/ &&  tar xf pypkgs.tgz &&  /opt/py27/bin/pip install --no-index --find-links=/data/bkce/miniweb/download/pypkgs -r pypkgs/requirements.txt  &>/dev/null

stty erase ^H
read -p "请输入您的密码:"  password
while :
do
    read -p "请输入您的ip地址:"  ip
    ping  -c 2  -w 2 $ip   &>/dev/null
    if [ $?  -ne 0 ];then
     echo  "ip格式错误，无法通信此ip" 
    else
     break
    fi
done

  
w_pkg=`ls gse_client-windows-x86_64.tgz   gse_client-windows-x86.tgz winagent_install.zip   7z.dll  7z.exe  normaliz.dll`

pkg_copy () {
 for i in $w_pkg
 do 
  wmiexec.py Administrator:$password@$ip "put $i"
 done 
            }
pkg_copy
wmiexec.py Administrator:$password@$ip "7z.exe -y x winagent_install.zip -oC:\\"

wmiexec.py Administrator:$password@$ip "winagent_install\\gse_install.bat $ip 0 "


