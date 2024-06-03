#!/bin/bash 
GT_BASHDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export GT_BASHDIR
cd "${GT_BASHDIR}" || exit 1
#####################################
export role_ID=$(cat /opt/cargo/acu/info/type)
export GT_NC='\033[0;0m'
export GT_RED='\033[0;31m'
export GT_GREEN='\033[0;32m'
export GT_ORANGE='\033[0;33m'
export GT_GREEN_BG='\033[0;42m'
export SUDOPASSWORD=""
export OB_RUNTIME_MACHINE=""
export num=""
export result=""
export camera_path=""
export time="$(date +%Y%m%d%H%M%S)"
export orin1A="192.168.5.48"
################
function GT_echo {
    RAW=1 
    COLOR=""
    target=""
    COLOR_NAME="GT_${1^^}"
    [ -v "${COLOR_NAME}" ] && COLOR=${!COLOR_NAME}
    if [ -z "${COLOR}" ];then 
        COLOR='\033[0;0m'
    [ "$1" != "raw" ] && printf "$(date +'%Y-%m-%d %H:%M:%S') " && target=${*:1}
    [ "$1" == "raw" ] && target=${*:2} && RAW=0
     elif [ $# -gt 1 ]; then
    # shellcheck disable=SC2059
    [ "$2" != "raw" ] && printf "$(date +'%Y-%m-%d %H:%M:%S') " && \
    target=${*:2}
    [ "$2" == "raw" ] && target=${*:3} && RAW=0
  fi
  #[ -n "${VIA_SSH}" ] && [ ${RAW} -eq 1 ] && COLOR="[${OB_RUNTIME_MACHINE}] ${COLOR}"
  # shellcheck disable=SC2059
  [ -n "${target[*]}" ] && printf "${COLOR}${target[*]}${GT_NC}"


  echo "${target[*]}" | systemd-cat -p info -t "onboard"
}
function delect_host {
    #根据tpye文件判断车辆的角色
    role=$(sshpass -p $SUDOPASSWORD ssh -t -q -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" cargo@100.100.100.$num  "cat /opt/cargo/acu/info/type"|tr -d '\r')
    [ "$role" == "4orin_B" ] && OB_RUNTIME_MACHINE="ORIN_B" && return 0
    [ "$role" == "4orin_C" ] && OB_RUNTIME_MACHINE="ORIN_C" && return 0 
    [ "$role" == "orin_single_A" ] && OB_RUNTIME_MACHINE="ORIN_single" && return 0
    #default single
    OB_RUNTIME_MACHINE="ORIN_single"

    return 0
    
}
#获取topic
function getTopic(){
    result=$(sshpass -p "${SUDOPASSWORD}" ssh -t -q -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" cargo@100.100.100.$num "\
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
#提示车辆角色
function prompt_role(){
    GT_echo "raw" " 当前车辆角色: "
    case ${OB_RUNTIME_MACHINE} in
    "ORIN_B")
    GT_echo "green" "raw" "[后车B样]\n"
    export orin_0="100.100.100.$num"
    export orin_1="100.100.101.$num"
    export orin_2="100.100.102.$num"
    export orin_3="100.100.103.$num"

    ;;
    "ORIN_C")
    GT_echo "green" "raw" "[后车C样]\n"
    export orin_0="100.100.100.$num"
    export orin_1="100.100.101.$num"
    export orin_2="100.100.102.$num"
    export orin_3="100.100.103.$num"
    ;;
    "ORIN_single")
    GT_echo "green" "raw" "[前车]\n"
    camera_path="/opt/cargo/camera/tools/3_pictures_Single_orin"
    export orin_0="100.100.100.$num"
    ;;
    esac
}

function prompt(){
    clear
    GT_echo "raw" "请按序号执行操作"
    prompt_role

    echo "1. 获取异常topic"
    echo "2. 下载jpg文件"
    echo "3. 生成jpg文件"
}

function download_pic(){
    case ${OB_RUNTIME_MACHINE} in 
    "ORIN_B")
       sshpass -p $SUDOPASSWORD  scp ${GT_BASHDIR}/tasks/download_back.sh cargo@$orin_0:/tmp
       sshpass -p "${SUDOPASSWORD}" ssh -t -q -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" cargo@$orin_0 "bash /tmp/download_back.sh" 
        echo "下载至orin完成"
        echo "开始下载只本地"
        if [ ! -d ${GT_BASHDIR}/1A_${time} ];then 
        mkdir ${GT_BASHDIR}/1A_${time}
        fi 
        if [ ! -d ${GT_BASEDIR}/1B_${time} ];then 
        mkdir ${GT_BASEDIR}/1B_${time}
        fi 
        sshpass -p $SUDOPASSWORD  scp cargo@$orin_0:/tmp/orin1A/*.jpg ${GT_BASHDIR}/1A_${time}/
        sshpass -p $SUDOPASSWORD  scp cargo@$orin_0:/tmp/orin1B/*.jpg ${GT_BASHDIR}/1B_${time}/

    ;;
    "ORIN_C")
        echo "此车是c样"
    ;;
    "ORIN_single")
     
     sshpass -p $SUDOPASSWORD  scp cargo@$orin_0:${camera_path}/*.jpg ${GT_BASHDIR}/${time}/
    ;;
    esac
 

}

function create_jpg(){
   sshpass -p $SUDOPASSWORD  scp ${GT_BASHDIR}/tasks/generate_jpg.sh ${GT_BASHDIR}/tasks/follow_orinb_pic_1A.sh ${GT_BASHDIR}/tasks/follow_orinb_pic_1B.sh cargo@$orin_0:/tmp
   
   sshpass -p "${SUDOPASSWORD}" ssh -t -q -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" cargo@$orin_0 "bash /tmp/generate_jpg.sh > /dev/null" 
}


export -f GT_echo 
export -f prompt_role
export -f delect_host
export -f getTopic
export -f download_pic
export -f create_jpg

