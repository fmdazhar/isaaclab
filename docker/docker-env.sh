#!/bin/bash

# Default values can be changed manually during runtime.
export GROUP_NAME="docker"                                         
export PROJECT_NAME="isaac-lab-base"
export DOCKER_MEMORY="5g"
export DOCKER_NUM_CPUS="3.0"
export DOCKER_SHARED_MEMORY="5g"
export VNC_PORT="2200"
export VNC_PW="test"
# export USE_GPU=false                                                # or false for without GPU
export USE_GPU="true"                                                # or false for without GPU


# Dynamic values
export USER_NAME=${USER}                                           # Linux username
export USER_ID=$(id -u)                                            # Linux User ID  
#export GPU_ID=$(nvidia-smi -L | grep -oP '(?<=UUID: ).*?(?=\))')   # Dynamically gets the GPU UUID
export HOST_IP=$(hostname -I | awk '{print $1}')                   # Dynamically get the host IP
#export HOST_IP=localhost

# Overwrite default parameters with flags e.g: ./docker-build.sh -GPU_ID=1234 -VNC_PORT=3
while [ $# -gt 0 ]; do
    case "$1" in
        -USER_NAME=*)
            USER_NAME="${1#*=}"
            ;;
        -USER_ID=*)
            USER_ID="${1#*=}"
            ;;
        -GROUP_NAME=*)
            GROUP_NAME="${1#*=}"
            ;;
        -PROJECT_NAME=*)
            PROJECT_NAME="${1#*=}"
            ;;
        -DOCKER_MEMORY=*)
            DOCKER_MEMORY="${1#*=}"
            ;;
        -DOCKER_NUM_CPUS=*)
            DOCKER_NUM_CPUS="${1#*=}"
            ;;
        -DOCKER_SHARED_MEMORY=*)
            DOCKER_SHARED_MEMORY="${1#*=}"
            ;;
        -VNC_PORT=*)
            VNC_PORT="${1#*=}"
            ;;
        -GPU_ID=*)
            GPU_ID="${1#*=}"
            ;;
        -VNC_PW=*)
            VNC_PW="${1#*=}"
            ;;
        -HOST_IP=*)
            HOST_IP="${1#*=}"
            ;;
        -USE_GPU=*)
            USE_GPU="${1#*=}"
            ;;
        *)
            echo "Faulty flag: $1"
            exit 1
    esac
    shift
done




echo "========================"
echo "=== User Information ==="
echo "========================"

echo "USER_NAME: $USER_NAME"
echo "USER_ID: $USER_ID"
echo "GROUP_NAME: $GROUP_NAME"
echo "PROJECT_NAME: $PROJECT_NAME"
echo "DOCKER_MEMORY: $DOCKER_MEMORY"
echo "DOCKER_NUM_CPUS: $DOCKER_NUM_CPUS"
echo "DOCKER_SHARED_MEMORY: $DOCKER_SHARED_MEMORY"
echo "HOST_IP: $HOST_IP"
echo "VNC_PORT: $VNC_PORT"
#echo "GPU_ID: $GPU_ID"
#echo "USE_GPU: $USE_GPU"