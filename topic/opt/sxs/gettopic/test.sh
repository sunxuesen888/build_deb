#!/bin/bash
# 子脚本

handle_interrupt() {
    echo "Child script interrupted"
    exit 1
}

trap '' SIGINT

# 子脚本的其他代码...
while true;do 
	sleep 2
	echo 111
done
