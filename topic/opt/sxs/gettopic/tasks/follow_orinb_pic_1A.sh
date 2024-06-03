#!/bin/bash 
back_camera_orinb_1A="/opt/cargo/camera/tools/2_pictures_4orin/0_1A_pics/orinb"
if [ ! -d ${back_camera_orinb_1A} ];then 
	back_camera_orinb_1A="/opt/cargo/camera/tools/2_pictures_4orin/0_1A_pics/"
fi
cd $back_camera_orinb_1A
for file in $(ls *.sh)
do 
	bash $file &>/dev/null &
	pid=$!
	sleep 2
	kill -9 $pid &>/dev/null 
done