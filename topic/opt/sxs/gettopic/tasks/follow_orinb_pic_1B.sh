back_camera_orinb_1B="/opt/cargo/camera/tools/2_pictures_4orin/1_1B_pics/orinb"
if [ ! -d ${back_camera_orinb_1B} ];then 
	back_camera_orinb_1B="/opt/cargo/camera/tools/2_pictures_4orin/1_1B_pics"
fi
cd $back_camera_orinb_1B
for file in $(ls *.sh)
do 
	bash $file &>/dev/null &
	pid=$!
	sleep 2
	kill -9 $pid &>/dev/null 
done