#!/bin/bash 
role=`cat /opt/cargo/acu/info/type`
orin1A="192.168.5.48"
orin1B="192.168.5.64"
single_camera_path="/opt/cargo/camera/tools/3_pictures_Single_orin"
back_camera_orinb_1A="/opt/cargo/camera/tools/2_pictures_4orin/0_1A_pics/orinb"
back_camera_orinb_1B="/opt/cargo/camera/tools/2_pictures_4orin/1_1B_pics/orinb"

if [ ${role} = "orin_single_A" ];then 
    cd $single_camera_path
    for file in $(ls *.sh)
do 
	bash $file &>/dev/null &
	pid=$!
	sleep 2
	kill -9 $pid &>/dev/null 
done
elif [ ${role} = "4orin_B" ];then 
    scp /tmp/follow_orinb_pic_1A.sh $orin1A:/tmp
    ssh $orin1A "bash /tmp/follow_orinb_pic_1A.sh > /dev/null"
    scp /tmp/follow_orinb_pic_1B.sh $orin1B:/tmp
    ssh $orin1B "bash /tmp/follow_orinb_pic_1B.sh > /dev/null"
fi