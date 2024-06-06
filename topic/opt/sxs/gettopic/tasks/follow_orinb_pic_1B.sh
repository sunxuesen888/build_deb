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
gst-launch-1.0 -ev v4l2src device=/dev/video1 ! "video/x-raw, format=(string)UYVY, width=(int)1920, height=(int)1080" ! jpegenc ! filesink location=./1_fisheye_left.jpg
camera &
gst-launch-1.0 -ev v4l2src device=/dev/video2 ! "video/x-raw, format=(string)UYVY, width=(int)1920, height=(int)1080" ! jpegenc ! filesink location=./2_fisheye_right.jpg
camera &
gst-launch-1.0 -ev v4l2src device=/dev/video4 ! "video/x-raw, format=(string)UYVY, width=(int)640, height=(int)514" ! jpegenc ! filesink location=./4_infrared.jpg
exit 0 
