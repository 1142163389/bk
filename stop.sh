#!/bin/bash
/usr/local/gse/agent/bin/gsectl stop    2>/dev/null  
cd /usr/local/gse/plugins/bin/ 2>/dev/null && ./stop.sh basereport   2>/dev/null
rm -rf /usr/local/gse /var/log/gse /var/run/gse /var/lib/gse  2>/dev/null
cd /data/install/  2>/dev/null && cp uninstall/uninstall.sh .     2>/dev/null 
bash uninstall.sh  
cd /data/  &&  ./bkcec clean cron 2>/dev/null  &&   ./bkcec stop all  2>/dev/null
chattr -i /data/install/.migrate/*                      2>/dev/null
rm -rf /data/install /data/bkce /data/src 	2>/dev/null
rpm -ev python27-2.7.9 python27-devel			2>/dev/null
yum remove nginx rabbitmq-server beanstalkd		2>/dev/null
mkdir /root/usrlocalbin.bak   &>/dev/null
mv /usr/local/bin/*  /root/usrlocalbin.bak  2>/dev/null
rm -f /root/.bkrc					2>/dev/null
rm -rf /etc/rc.d/bkrc.local					2>/dev/null
sed -ri "s/.*cloud.[a-z]{2}.[a-z]{3}//"  /etc/hosts
sed -ri  "/^nameserver 127.0.0.1$/d"  /etc/resolv.conf    

