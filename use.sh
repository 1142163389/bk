get_agent_status (){
    ip=$1
    API="http://$PAAS_FQDN//api/c/compapi/v2/gse/get_agent_status/"
    request_json=$(cat <<EOF
{
    "bk_app_code": "bk_cmdb",
    "bk_app_secret": "8182e9c5-b251-4691-b1ee-9d99b0acee6a",
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

de() {
source "${CTRL_DIR}/utils.fc"
for i in ${ZK_IP[@]}; do  rcmd $i "rm -rf  $INSTALL_PATH/public/zk*;  rm -rf  $INSTALL_PATH/service/zk* ;  rm  -rf $INSTALL_PATH/logs/zk* ; rm -rf $INSTALL_PATH/etc/zoo* "; done
}

se() {
cd /data/install && ./bkeec status $1
}


ge2(){
source "${CTRL_DIR}/utils.fc"
for i in ${ALL_IP[@]};do echo "$i";done
}

ge(){
echo  "NGINX_IP -> ${NGINX_IP[@]}" 
echo  "PAAS_IP  -> ${PAAS_IP[@]}" 
echo  "CMDB_IP  -> ${CMDB_IP[@]}"   
echo  "MYSQL_IP -> ${MYSQL_IP[@]}"
echo  "REDIS_IP -> ${REDIS_IP[@]}" 
rcmd $1
}

