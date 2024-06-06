#!/bin/bash 
role=`cat /opt/cargo/acu/info/type`
orin1A="192.168.5.48"
orin1B="192.168.5.64"
picture="/tmp/pic"

if [ ${role} = "orin_single_A" ];then 
    cd ${picture} && bash $picture/front_car_pic.sh &>/dev/null
elif [ ${role} = "4orin_B" ];then 
   #orin1a拷贝jpg生成脚本并执行 
    ssh ${orin1A} -t -q -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" "[ ! -d ${picture} ] && mkdir ${picture}"
    scp ${picture}/follow_orinb_pic_1A.sh $orin1A:${picture}
    ssh ${orin1A} "cd ${picture} && bash ${picture}/follow_orinb_pic_1A.sh &>/dev/null" 
    [ ! -d ${picture}/orin1A ] && mkdir ${picture}/orin1A
    scp ${orin1A}:${picture}/*.jpg ${picture}/orin1A

    #orin1b拷贝jpg生成脚本并执行    
    ssh ${orin1B} -t -q -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" "[ ! -d ${picture} ] && mkdir ${picture} "
    scp ${picture}/follow_orinb_pic_1B.sh $orin1B:${picture}
    ssh ${orin1B} "cd ${picture} && bash ${picture}/follow_orinb_pic_1B.sh &>/dev/null" 
      [ ! -d ${picture}/orin1B ] && mkdir ${picture}/orin1B
    scp ${orin1B}:${picture}/*.jpg ${picture}/orin1B
fi