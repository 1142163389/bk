
# mogodb 3.6 - 4.2 升级方案

## 整体思路：

\# 准备

\# 配置启动mongodb,写入数据,验证数据

\# 升级到4.0

\# 升级到4.2,进行最终结果验证

#### 准备

- 准备：下载mongodb3.6.18，mongodb4.0,mongodb4.2，如果慢可以把https改成http

  wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.6.18.tgz

  wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.0.19.tgz

  wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.2.8.tgz

#### 配置启动mongodb,写入数据,验证数据  

- 配置mongodb并启动服务

  tar  -zxvf  mongodb-linux-x86_64-rhel70-3.6.18.tgz

  mv mongodb-linux-x86_64-rhel70-3.6.18 /usr/local/mongodb

  ln -s /usr/local/mongodb/bin/* /usr/local/bin/


  ######编辑配置文件my.cnf   vim my.cnf

  bind_ip = 0.0.0.0

  port=27017

  dbpath=/data

  logpath=/usr/local/mongodb/mongodb.log

  pidfilepath=/usr/local/mongodb/mongo.pid

  fork=true

  logappend=true

  auth=false

  #######

  mongod --config /root/my.cnf&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;用配置启动mongodb

  mongo 127.0.0.1:27017&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;无鉴权登录

  use admin

  db.createUser({user:"root",pwd:"123456",roles:["root"]})

  use testdb

  db.info.insert({name:"zhangsan",age:18,love:{"eat":["bannaa","orange"],"play":["trv","sw"]}})

  db.createUser({user:"user01",pwd:"1234567",roles:[{role:"dbAdmin",db:"testdb"}]})

  exit         

  killall mongod             

  #######打开my.cnf,修改auth=true         vim my.cnf

  mongod --config /root/my.cnf

  mongo 127.0.0.1:27017     

  use testdb

  show tables&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;失败

  db.auth("user01","1234567")

  show tables&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;成功

  db.info.find()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;之前创建的权限无表查看权限

  exit



- 备份数据：

    **模板**：

    #mongodump --host HOST_NAME --port PORT_NUMBER&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;全量

    #mongodump -h dbhost -d dbname -o dirypath&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;单db

    #mongodump --collection COLLECTION --db DB_NAME&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;单集合
 
    **实例(全量备份)**：

    mongodump --host  127.0.0.1  --port 27017  -u root -p 123456&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;全量

    killall mongod

#### 升级到4.0

mkdir /root/4.0  


tar -xvf mongodb-linux-x86_64-rhel70-4.0.19.tgz  -C  /root/4.0/

rsync -av   /root/4.0/mongodb-linux-x86_64-rhel70-4.0.19/bin/mongod  /usr/local/bin/mongod

rsync -av /root/4.0/mongodb-linux-x86_64-rhel70-4.0.19/bin/mongod /usr/local/mongodb/bin/mongod

mongod --config /root/my.cnf

mongo -u root --host 127.0.0.1 --authenticationDatabase "admin" -p 123456&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;鉴权登陆

db.adminCommand( { setFeatureCompatibilityVersion: "4.0" } )&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;修改成4.0

db.adminCommand( { getParameter: 1, featureCompatibilityVersion: 1 } )&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;查看是4.0即可

exit

killall mongod

#### 升级到4.2

mkdir  /root/4.2

tar -xvf mongodb-linux-x86_64-rhel70-4.2.8.tgz -C /root/4.2

rsync -av /root/4.2/mongodb-linux-x86_64-rhel70-4.2.8/bin/mongod /usr/local/bin/mongod

rsync -av /root/4.2/mongodb-linux-x86_64-rhel70-4.2.8/bin/mongod /usr/local/mongodb/bin/mongod

mongod --config /root/my.cnf

mongo -u root --host 127.0.0.1 --authenticationDatabase "admin" -p 123456

db.adminCommand( { setFeatureCompatibilityVersion: "4.2" } )

db.adminCommand( { getParameter: 1, featureCompatibilityVersion: 1 } )

exit

killall mongod

mongod --version 

- 数据验证

  - 鉴权登陆

    mongod --config /root/my.cnf

    mongo -u root --host 127.0.0.1 --authenticationDatabase "admin" -p 123456

    show dbs

    use admin 

    db.system.users.find()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;可以看到之前的用户数据还在

    use testdb

    db.info.find()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;可以看到之前创建的数据还在

    exit

  - 无鉴权登陆

    mongo

    show dbs&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;失败,未鉴权

    use testdb 

    db.auth("user01","1234567")&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;登陆到库用户

    show tables&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;可以看到表

    db.info.find()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;之前创建的权限无表查看权限













