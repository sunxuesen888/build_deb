#!/bin/bash 
function camera(){ 
    sleep 5
    echo "got signal"
    pid=$(pgrep gst-launch)
    kill -2 $pid
}

camera &
gst-launch-1.0 -ev v4l2src device=/dev/video0 ! "video/x-raw, format=(string)UYVY, width=(int)2880, height=(int)1860" ! jpegenc ! filesink location=./0_camera_front.jpg
camera &
gst-launch-1.0 -ev v4l2src device=/dev/video1 ! "video/x-raw, format=(string)UYVY, width=(int)2880, height=(int)1860" ! jpegenc ! filesink location=./1_camera_front_1.jpg
camera &
gst-launch-1.0 -ev v4l2src device=/dev/video2 ! "video/x-raw, format=(string)UYVY, width=(int)2880, height=(int)1860" ! jpegenc ! filesink location=./2_camera_front_left_1.jpg
camera &
gst-launch-1.0 -ev v4l2src device=/dev/video3 ! "video/x-raw, format=(string)UYVY, width=(int)2880, height=(int)1860" ! jpegenc ! filesink location=./3_camera_front_left.jpg
camera &
gst-launch-1.0 -ev v4l2src device=/dev/video4 ! "video/x-raw, format=(string)UYVY, width=(int)2880, height=(int)1860" ! jpegenc ! filesink location=./4_camera_front_left_2.jpg
camera & 
gst-launch-1.0 -ev v4l2src device=/dev/video5 ! "video/x-raw, format=(string)UYVY, width=(int)2880, height=(int)1860" ! jpegenc ! filesink location=./5_camera_front_right_1.jpg
camera & 
gst-launch-1.0 -ev v4l2src device=/dev/video6 ! "video/x-raw, format=(string)UYVY, width=(int)2880, height=(int)1860" ! jpegenc ! filesink location=./6_camera_front_right.jpg
camera & 
gst-launch-1.0 -ev v4l2src device=/dev/video7 ! "video/x-raw, format=(string)UYVY, width=(int)2880, height=(int)1860" ! jpegenc ! filesink location=./7_camera_front_right_2.jpg
exit 0 