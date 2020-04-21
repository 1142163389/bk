#!/bin/bash
/usr/local/gse/agent/bin/gsectl stop  &>/dev/null
cd /usr/local/gse/plugins/bin/ &>/dev/null && ./stop.sh basereport   &>/dev/null
rm -rf /usr/local/gse /var/log/gse /var/run/gse /var/lib/gse  &>/dev/null
cd /data/install/  &>/dev/null && cp uninstall/uninstall.sh .     &>/dev/null 
bash uninstall.sh   &> /dev/null
cd /data/  &&  ./bkcec clean cron &>/dev/null  &&   ./bkcec stop all  &>/dev/null
chattr -i /data/install/.migrate/*                      &>/dev/null
rm -rf /data/install /data/bkce /data/src 	&>/dev/null
rpm -ev python27-2.7.9 python27-devel			&>/dev/null
yum remove nginx rabbitmq-server beanstalkd		&>/dev/null
mkdir /root/bk   &>/dev/null
mv /usr/local/bin/*  /root/usrlocalbin.bak  &>/dev/null
rm -f /root/.bkrc					&>/dev/null
rm -rf /etc/rc.d/bkrc.local					&>/dev/null
sed -ri "s/.*cloud.[a-z]{2}.[a-z]{3}//"  /etc/hosts
sed -ri  "/^nameserver 127.0.0.1$/d"  /etc/resolv.conf    

