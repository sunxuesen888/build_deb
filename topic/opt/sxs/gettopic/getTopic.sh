#!/bin/bash 
SUDOPASSWORD=""
read -er -p "请输入车辆ID: " num
if ( timeout 5 ping -c 1 100.100.100.$num > /dev/null )
then 
    echo "车辆网络正常"
else
    echo "车辆无网络连接，请检查网络"
    exit
fi
printf "\n"
function ask_password(){
    while true 
    do 
        echo "请输入车辆的密码: "
        read -sr SUDOPASSWORD
        sudo -k
        if (timeout 3 sshpass -p "${SUDOPASSWORD}" ssh -t -q -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" cargo@100.100.100.$num  "ls" >/dev/null 2>&1)
        then 
            export sudopassword="${SUDOPASSWORD}"
            break  
        else 
            echo "密码错误" 
            continue
        fi
    done  
}
ask_password

function getTopic(){
    result=$(sshpass -p "${sudopassword}" ssh -t -q -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" cargo@100.100.100.$num "\
    docker exec -it cargo_orin_dev_cargo /usr/bin/bash -c \
    'export PS1=[\u@docker]; source /root/.profile; rostopic echo -n5 /alpas/monitor/system_error_info |\
     grep "reason"|sort |uniq'| cut -d: -f2")
    if [ -z "$result" ] 
    then 
         echo "节点无异常"
    else 
        printf "节点异常topic: \n $result \n"
        
    fi
    

}
clear 
while true 
do  
    echo "请按序号执行操作:"
    echo "1. 获取异常topic"
    echo "2. 退出"
    read -er option
    [ "${option}" == $'\x0a' ] && continue
    case ${option} in 
    1) 
        
        getTopic
    ;;
    2) 

        exit
    esac

done