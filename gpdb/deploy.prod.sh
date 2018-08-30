#!/bin/bash
. ./init.prod.sh

# 可否一次性定义inventory
INVENTORY=./inventory.prod

# 添加私有仓库地址
# ansible -i $INVENTORY all -m shell -a "echo '10.99.170.92    harbor.remote.inventec.com' >> /etc/hosts" -b
ansible -i $INVENTORY all -m copy -a "src=../docker-daemon.json dest=/etc/docker/daemon.json" -b
# ansible -i $INVENTORY all -m service -a "name=docker state=restarted" -b

# 初始化 Swarm
# ansible -i $INVENTORY gpdb-master -m command -a "sudo docker swarm init --advertise-addr 10.99.170.58" -b
# 添加 Swarm Worker 节点
# ansible -i $INVENTORY gpdb-segment -m command -a "docker swarm join --token SWMTKN-1-44xebmqerko0v8y3mxlaz00xc6supwol8ub4sbs9kvtl1k2rv3-1o9ohpmzpmapl5atgi069w017 10.190.5.110:2377" -b
# 自定义标签
# ansible -i $INVENTORY gpdb-master -m command -a "docker node ls" -b
# ansible -i $INVENTORY gpdb-segment-node1 -m command -a "docker node update --label-add alias=node60 gpdb-segment-node1" -b
# ansible -i $INVENTORY gpdb-segment-node2 -m command -a "docker node update --label-add alias=node62 gpdb-segment-node2" -b
# ansible -i $INVENTORY gpdb-segment-node3 -m command -a "docker node update --label-add alias=node64 gpdb-segment-node3" -b
# ansible -i $INVENTORY gpdb-segment-node4 -m command -a "docker node update --label-add alias=node66 gpdb-segment-node4" -b
# ansible -i $INVENTORY gpdb-segment-node5 -m command -a "docker node update --label-add alias=node68 gpdb-segment-node5" -b

# 初始化网络
# record=`docker network ls | awk '($2=="gpdb"){print $1}' | wc -l`
# if [ $record -gt 0 ]; then
#     docker network rm gpdb
# fi
# ansible -i $INVENTORY gpdb-master -m command -a "docker network create --driver overlay gpdb" -b

# 移除历史目录
# ansible -i $INVENTORY gpdb-master  -m file -a "path=/disk1/greenplum state=absent"
# ansible -i $INVENTORY gpdb-segment -m file -a "path=/disk1/greenplum state=absent" -f 5
# ansible -i $INVENTORY gpdb-segment -m file -a "path=/disk2/greenplum state=absent" -f 5
# ansible -i $INVENTORY gpdb-segment -m file -a "path=/disk3/greenplum state=absent" -f 5
# 创建数据目录
# ansible -i $INVENTORY gpdb-master  -m file -a "dest=/disk1/greenplum/master mode=777 state=directory"
# ansible -i $INVENTORY gpdb-segment -m file -a "dest=/disk1/greenplum/primary mode=777 state=directory" -f 5
# ansible -i $INVENTORY gpdb-segment -m file -a "dest=/disk1/greenplum/mirror mode=777 state=directory" -f 5
# ansible -i $INVENTORY gpdb-segment -m file -a "dest=/disk2/greenplum/primary mode=777 state=directory" -f 5
# ansible -i $INVENTORY gpdb-segment -m file -a "dest=/disk2/greenplum/mirror mode=777 state=directory" -f 5
# ansible -i $INVENTORY gpdb-segment -m file -a "dest=/disk3/greenplum/primary mode=777 state=directory" -f 5
# ansible -i $INVENTORY gpdb-segment -m file -a "dest=/disk3/greenplum/mirror mode=777 state=directory" -f 5

# 同步配置文件
# ansible -i $INVENTORY gpdb-master -m copy -a "src='deploy.prod/' dest='/opt/greenplum'"
# ansible -i $INVENTORY gpdb-segment -m copy -a "src='deploy.prod/config' dest='/opt/greenplum'" -f 5

# 执行启动命令
ansible -i $INVENTORY all -m command -a "docker pull ${REGISTRY}/${TAGNAME}" -b -f 5
# ansible -i $INVENTORY gpdb-master -m command -a "/opt/greenplum/start.sh ${REGISTRY} ${TAGNAME}" -b

# 添加附加程序
# ansible -i $INVENTORY all  -m apt -a "name=iftop state=latest install_recommends=no" -b -f 5
