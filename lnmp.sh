yum -y install gcc openssl-devel pcre-devel 
yum -y install   mariadb   mariadb-server   mariadb-devel
yum -y install   php        php-mysql        php-fpm
tar -xf lnmp_soft.tar.gz 
cd lnmp_soft/
tar -xvf nginx-1.12.2.tar.gz  -C /root
cd ~
cd nginx-1.12.2/
useradd  -s /sbin/nologin  nginx
./configure --user=nginx   --group=nginx  --with-http_ssl_module  --with-http_stub_status_module  
make && make install
sed  -i  "45s/index /index index.php/1" /usr/local/nginx/conf/nginx.conf
sed  -i  "65,68s/#//" /usr/local/nginx/conf/nginx.conf
sed  -i  "70,71s/#//" /usr/local/nginx/conf/nginx.conf
sed -i  "s/fastcgi_params;/fastcgi.conf;/" /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx
echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.local
chmod +x /etc/rc.local
systemctl start   mariadb
systemctl enable  mariadb
systemctl start  php-fpm 
systemctl enable php-fpm
a=`ifconfig  | awk '/inet 192.168.4./{print $2}'`
mysql -e "create database wordpress character set utf8mb4;grant all on wordpress.* to wordpress@'localhost' identified by 'wordpress';grant all on wordpress.* to wordpress@"$a" identified by 'wordpress'; flush privileges;"
yum -y install unzip
cd ~
cp  -r  lnmp_soft/wordpress.zip  .
unzip wordpress.zip
cd wordpress
tar -xf wordpress-5.0.3-zh_CN.tar.gz
cp -r  wordpress/*  /usr/local/nginx/html/
chown -R apache.apache  /usr/local/nginx/html/
sed -i "s/username_here/wordpress/" /usr/local/nginx/html/wp-config-sample.php
sed -i "s/password_here/wordpress/"  /usr/local/nginx/html/wp-config-sample.php
sed -i "s/localhost/$a/"   /usr/local/nginx/html/wp-config-sample.php








