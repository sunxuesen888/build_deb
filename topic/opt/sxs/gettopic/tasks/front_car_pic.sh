#!/bin/bash 
function camera(){ 
    sleep 5
    echo "got signal"
    pid=$(pgrep gst-launch)
    kill -2 $pid
}

camera &
gst-launch-1.0 -ev v4l2src device=/dev/video0 ! "video/x-raw, format=(string)UYVY, width=(int)1920, height=(int)1080" ! jpegenc ! filesink location=./0_fisheye_front.jpg
camera & 
gst-launch-1.0 -ev v4l2src device=/dev/video2 ! "video/x-raw, format=(string)UYVY, width=(int)2880, height=(int)1860" ! jpegenc ! filesink location=./2_camera_front_30.jpg
camera &
gst-launch-1.0 -ev v4l2src device=/dev/video3 ! "video/x-raw, format=(string)UYVY, width=(int)2880, height=(int)1860" ! jpegenc ! filesink location=./3_camera_front_60.jpg
camera & 
gst-launch-1.0 -ev v4l2src device=/dev/video6 ! "video/x-raw, format=(string)UYVY, width=(int)1920, height=(int)1080" ! jpegenc ! filesink location=./6_camera_fisheye_left.jpg
camera & 
gst-launch-1.0 -ev v4l2src device=/dev/video7 ! "video/x-raw, format=(string)UYVY, width=(int)1920, height=(int)1080" ! jpegenc ! filesink location=./7_camera_fisheye_right.jpg
exit 0

