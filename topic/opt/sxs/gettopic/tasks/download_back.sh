#!/bin/bash 
orin1A="192.168.5.48"
orin1B="192.168.5.64"
picture_path="/tmp/pic"

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