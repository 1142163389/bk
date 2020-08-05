## 手动openresty 配置yum仓库


### 1.安装openresty
>蓝鲸2.5.0.14版本后 /data/src/service 下面有rpm包和对应的nginx示例配置文件，这里将使用rpm包安装；

```bash
#使用rpm包安装openresty
[root@]#rpm -ivh openresty-1.15.8.3-13.x86_64.rpm

#nginx 配置文件添加 include conf.d/*.conf
[root@]#sed -i  '$i '"include conf.d/*.conf;"'' /usr/local/openresty/nginx/conf/nginx.conf

#创建conf.d目录
mkdir -p /usr/local/openresty/nginx/conf/conf.d
```

### 2.配置openresty
```bash
cat >> /usr/local/openresty/nginx/conf/conf.d/yum.conf <<EOF
server {
    listen   8080;
    server_name 10.0.0.1;
    location /yum {
        root   /html;
        index  index.php index.html index.htm;
        autoindex on;	#enable listing of directory index
    }
}
EOF

#启动openreaty
[root@]#systemctl start openresty
```


### 3.生成/etc/yum.repo.d/bk-custom.repo
```bash
cat >> /etc/yum.repos.d/bk-custom.repo <<EOF
[bk-custom]
name=BlueKing Custom Repo
baseurl=http://10.0.0.1:8080/yum
enabled=1
gpgcheck=0
EOF
```
### 4.创建yum 存储库
```bash
mkdir -p /html/yum
chown -R  nobody. /html
createrepo  /html/yum
```
### 5.拷贝rpm包

### 测试
>注: 查看当前可用yum源，本地源显示为零，可执行createrepo 更新。 ```createrepo --update  /html/yum/```
