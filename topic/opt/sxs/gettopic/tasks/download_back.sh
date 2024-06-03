#!/bin/bash 
back_camera_orinb_1A="/opt/cargo/camera/tools/2_pictures_4orin/0_1A_pics/orinb"
if [ ! -d ${back_camera_orinb_1A} ];then 
	back_camera_orinb_1A="/opt/cargo/camera/tools/2_pictures_4orin/0_1A_pics"
fi
back_camera_orinb_1B="/opt/cargo/camera/tools/2_pictures_4orin/1_1B_pics/orinb"
if [ ! -d ${back_camera_orinb_1B} ];then 
	back_camera_orinb_1B="/opt/cargo/camera/tools/2_pictures_4orin/1_1B_pics"
fi
role=`cat /opt/cargo/acu/info/type`
orin1A="192.168.5.48"
orin1B="192.168.5.64"
download_path_1A="orin1A"
download_path_1B="orin1B"
if [ ${role} = "4orin_B" ];then 
    if [ ! -d "/tmp/${download_path_1A}" ];then 
    mkdir /tmp/$download_path_1A 
    fi 
    if [ ! -d "/tmp/${download_path_1B}" ];then
    mkdir /tmp/$download_path_1B
    fi
    scp $orin1A:$back_camera_orinb_1A/*.jpg /tmp/$download_path_1A/
    scp $orin1B:$back_camera_orinb_1B/*.jpg /tmp/$download_path_1B/
fi