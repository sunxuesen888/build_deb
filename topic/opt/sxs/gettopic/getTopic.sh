#!/bin/bash 
GT_BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export GT_BASHDIR
cd "${GT_BASEDIR}" || exit 1
source ${GT_BASEDIR}/tasks/public.sh

############################################################################
GT_echo "green" "请输入车辆ID: "
read -er num
if ( timeout 5 ping -c 1 100.100.100.$num > /dev/null )
then 
    GT_echo "green" "车辆网络正常"
else
    GT_echo "red" "车辆无网络连接，请检查网络"
    exit
fi
printf "\n"


function ask_password(){
    while true 
    do 
        GT_echo "green" "请输入密码: \n"
        read -sr SUDOPASSWORD
        sudo -k
        if (timeout 3 sshpass -p "${SUDOPASSWORD}" ssh -t -q -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" cargo@100.100.100.$num  "ls" >/dev/null 2>&1)
        then 
            break  
        else 
            GT_echo "red" "密码错误 \n" 
            continue
        fi
    done  
}
ask_password

if ! delect_host;then 
    GT_echo "red" "获取本地运行环境失败,请按任意键退出 ErrCode:13\n"
    read -ern 1 
    exit 20;
fi 
 prompt_role
 
 
 while true 
do  
    # if [ "${OB_RUNTIME_MACHINE}" == "ORIN_single" ];then 
    #     prompt_front
    # elif [ "${OB_RUNTIME_MACHINE}" == "ORIN_C" ];then 
    #     prompt_orin_c
    # fi
    prompt
    read -er option
    [ "${option}" == $'\x0a' ] && continue
    case ${option} in 
    1) 
        start_time=$(date +"%s")
        getTopic
        echo $orin_2
        ret=$?
    ;;
    2) 
        start_time=$(date +"%s")
        #mkdir $time
        download_pic
        ret=$?
    ;;
    3)
        start_time=$(date +"%s")
        create_jpg
        ret=$?
    ;;
    esac
    if [ ! "${ret}" == 0 ]
    then
         err_msg=". ErrCode: ${ret}"
    [[ ! "${ret}" =~ ^[0-9]+$ ]] && err_msg=": ${ret}"
    GT_echo "red" "执行失败${err_msg}\n"
    fi
  stop_time=$(date +"%s")
  GT_echo "=== 消耗时间: "$((stop_time - start_time))" S ===\n"

    read -ern 1 -p "按任意键继续..."

done