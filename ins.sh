#!/bin/bash
stty erase ^H
read -p "您需要部署单击版/社区版呢？请输入[1/2]:"  version

data='/data/install'
num="10.0.0"

one_install () {
    while :   
    do
      read -p "请输入您部署到哪台ip地址："  ip1
      ping  -c 2  -w 2 $ip1  &>/dev/null
        if [ $?  -ne 0 ];then
         echo  "ip格式错误，无法通信此ip" 
        else
          break
        fi
    done

cp $data/install.config.new.sample  $data/install.config
sed -i "8,15s/^/#/"  $data/install.config
sed -ri "4,6s/[0-9]{2}.[0-9]{1}.{2}.[0-9]{1}/$ip1/1"  $data/install.config
sed -i "s/bk.com/monkey.monkey.monkey/"  $data/globals.env
sed -ri "s/[a-z]{6}.[A-Z]{4}.[A-Z]{5}.[A-Z]{4}..[a-z]{1,}[0-9]{1,}+[A-Z]{1,}.*/export PAAS_ADMIN_PASS='123456'/"   $data/globals.env 
               }  


ping2 () {
    while :   
    do
      read -p "请输入中控机ip:"      ip2
      ping  -c 2  -w 2 $ip2   &>/dev/null
        if [ $?  -ne 0 ];then
         echo  "ip格式错误，无法通信此ip" 
        else
         break
        fi
    done
        }

ping3 () {
    while :   
    do
      read -p "请输入第一个节点ip:"  ip3
      ping  -c 2  -w 2 $ip3   &>/dev/null
        if [ $?  -ne  0 ];then
         echo  "ip格式错误，无法通信此ip" 
        else
         break
        fi
    done
        }

ping4 () {
    while :   
    do
      read -p "请输入第二个节点ip:"  ip4
      ping  -c 2  -w 2 $ip4   &>/dev/null
        if [ $? -ne 0  ];then
         echo  "ip格式错误，无法通信此ip" 
        else
         break
        fi
    done
        }


more_install () {
ping2
ping3
ping4
cp $data/install.config.new.sample  $data/install.config
sed -i "8,15s/^/#/"  $data/install.config
sed -i "4s/$num.1/$ip2/1"  $data/install.config
sed -i "5s/$num.2/$ip3/1"  $data/install.config
sed -i "6s/$num.3/$ip4/1"  $data/install.config
sed -i "s/bk.com/monkey.monkey.monkey/"  $data/globals.env 
sed -ri "s/[a-z]{6}.[A-Z]{4}.[A-Z]{5}.[A-Z]{4}..[a-z]{1,}[0-9]{1,}+[A-Z]{1,}.*/export PAAS_ADMIN_PASS='123456'/"   $data/globals.env
                 }

case $version in
 1)
  one_install ;;

 2)
  more_install
esac

if [ $? -eq 0 ]
then  
 echo '》》》开始进行安装《《《'
 /data/bk_install paas && /data/bk_install cmdb && /data/bk_install job && /data/bk_install app_mgr && /data/bk_install bkdata && /data/bk_install fta && /data/bkcec install gse_agent && /data/bkcec install saas-o 
fi 
