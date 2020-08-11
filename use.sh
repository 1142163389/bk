source "${CTRL_DIR}/utils.fc"
#调用API
get_agent_status (){
    ip=$1
    API="http://$PAAS_FQDN//api/c/compapi/v2/gse/get_agent_status/"
    request_json=$(cat <<EOF
{
    "bk_app_code": "bk_cmdb",
    "bk_app_secret": "947fd105-b8d9-4f22-aabc-5ca065041e96",
    "bk_username": "admin",
    "bk_supplier_account": "0",
    "hosts": [
        {
            "ip": "$ip",
            "bk_cloud_id": 0
        }
    ]
}
EOF
)
    res=$(curl -s -X POST "$API" \
            -H 'Content-Type: application/json' \
            -H 'cache-control: no-cache' \
            --data "$request_json")
    echo "$res"
}

#cmdb重置
reset_cmdb_topo (){
    source "${CTRL_DIR}"
    "${CTRL_DIR}"/bkeec sync cmdb
    for ip in "${CMDB_IP[@]}";do
        rcmd "${ip}" "chattr -i /root/.tag/init_cmdb_bk_proc"
        rcmd "${ip}" "rm -f  /root/.tag/init_cmdb_bk_proc"
    done
    "${CTRL_DIR}"/bkeec initdata cmdb
    echo "1111111"
}

#重装机器
reset_host(){
for i in ${ALL_IP[@]};do ssh $i "curl -s http://metadata.tencentyun.com/meta-data/instance-id;echo """;done
}

#删除组件所有目录 (zk为例)
de() {
source "${CTRL_DIR}/utils.fc"
for i in ${$1_IP[@]}; do  rcmd $i "rm -rf  $INSTALL_PATH/public/zk*;  rm -rf  $INSTALL_PATH/service/zk* ;  rm  -rf $INSTALL_PATH/logs/zk* ; rm -rf $INSTALL_PATH/etc/zoo* "; done
}

#查看状态
se() {
cd /data/install && ./bkeec status $1
}

#获取所有IP
ge2(){
source "${CTRL_DIR}/utils.fc"
for i in ${ALL_IP[@]};do echo "$i";done
}

#获取组件IP，远程
ge(){
echo  "NGINX_IP -> ${NGINX_IP[@]}"     
echo  "PAAS_IP  -> ${PAAS_IP[@]}" 
echo  "CMDB_IP  -> ${CMDB_IP[@]}"   
echo  "MYSQL_IP -> ${MYSQL_IP[@]}"
echo  "REDIS_IP -> ${REDIS_IP[@]}" 
echo  "USERMGR_IP -> ${REDIS_IP[@]}"
echo  "IAM_IP -> ${REDIS_IP[@]}" 
echo  "GSE_IP -> ${REDIS_IP[@]}" 
echo  "JOB_IP -> ${REDIS_IP[@]}" 
echo  "ZK_IP -> ${REDIS_IP[@]}" 
echo  "RABBITMQ_IP -> ${REDIS_IP[@]}" 
echo  "MONGODB_IP -> ${REDIS_IP[@]}" 
echo  "ES_IP -> ${ES_IP[@]}" 
rcmd $1  &>/dev/null
}

#登陆组件
go_mysql () 
{
    mysql -h$MYSQL_IP -p$MYSQL_PASS -u$MYSQL_USER
}

go_redis () 
{
    redis-cli -h $REDIS_HOST -a $REDIS_PASS
}

go_mongo () 
{
    mongo mongodb://$MONGODB_IP:$MONGODB_PORT/admin -u $MONGODB_USER -p $MONGODB_PASS
}

go_zk () 
{
    echo $ZK_USER
    echo $ZK_PASS
    /data/src/service/zk/bin/zkCli.sh -server $ZK_HOST
}

