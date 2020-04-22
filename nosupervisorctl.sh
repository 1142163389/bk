#!/bin/bash
for dir in `ls -l /data/bkce/paas_agent/apps/Envs/ |awk '{print $9}'`
do
rm -rf /data/bkce/paas_agent/apps/projects/$dir/run/supervisord.sock
supervisord -c /data/bkce/paas_agent/apps/projects/$dir/conf/supervisord.conf
supervisorctl -c /data/bkce/paas_agent/apps/projects/$dir/conf/supervisord.conf start all
supervisorctl -c /data/bkce/paas_agent/apps/projects/$dir/conf/supervisord.conf status all
done 
