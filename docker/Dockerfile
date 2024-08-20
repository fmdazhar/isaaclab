# FROM ros:iron-ros-base

# Base image
ARG ISAACSIM_VERSION_ARG

FROM nvcr.io/nvidia/isaac-sim:${ISAACSIM_VERSION_ARG} AS base
ENV ISAACSIM_VERSION=${ISAACSIM_VERSION_ARG}

# Set default RUN shell to bash
SHELL ["/bin/bash", "-c"]

# Adds labels to the Dockerfile
LABEL version="1.1"
LABEL description="Dockerfile for building and running the Isaac Lab framework inside Isaac Sim container image."

# Arguments
# Path to Isaac Sim root folder
ARG ISAACSIM_ROOT_PATH_ARG
ENV ISAACSIM_ROOT_PATH=${ISAACSIM_ROOT_PATH_ARG}
# Path to the Isaac Lab directory
ARG ISAACLAB_PATH_ARG
ENV ISAACLAB_PATH=${ISAACLAB_PATH_ARG}
# Home dir of docker user, typically '/root'
ARG DOCKER_USER_HOME_ARG
ENV DOCKER_USER_HOME=${DOCKER_USER_HOME_ARG}

# Set environment variables
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
USER root

# Install dependencies and remove cache
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libglib2.0-0 \
    htop -y \
    curl \
    software-properties-common \
    net-tools \
    unzip \
    wget \
    python3-pip \
    ncurses-term && \
    apt -y autoremove && apt clean autoclean && \
    rm -rf /var/lib/apt/lists/*

# Install virtual display and related packages
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    x11-apps \
    libx11-6 libxext6 libxau6 libxxf86vm1 libxdmcp6 libxcb1 libxrender1 libxrandr2 libxfixes3 libxi6 libxinerama1 libxkbcommon-x11-0 libgl1-mesa-glx libgl1-mesa-dri mesa-utils \
    x11-xserver-utils \
    novnc \
    supervisor \
    x11vnc \
    xvfb \
    xfce4 \
    software-properties-common && \
    add-apt-repository ppa:mozillateam/ppa -y && \
    echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n' | tee /etc/apt/preferences.d/mozilla-firefox && \
    apt install firefox -y && \
    mkdir /tmp/.X11-unix && \
    add-apt-repository ppa:xubuntu-dev/staging -y && \
    apt install awesome -y && \
    apt-get install xterm && \
    apt update && apt upgrade -y && \
    apt -y autoremove && apt clean autoclean && \
    rm -rf /var/lib/apt/lists/*

ARG PROJECT_NAME
ENV PROJECT_NAME=${PROJECT_NAME}
RUN git config --global --add safe.directory /${PROJECT_NAME}

# Copy the Isaac Lab directory (files to exclude are defined in .dockerignore)
COPY ../ ${ISAACLAB_PATH}

# Set up a symbolic link between the installed Isaac Sim root folder and _isaac_sim in the Isaac Lab directory
RUN ln -sf ${ISAACSIM_ROOT_PATH} ${ISAACLAB_PATH}/_isaac_sim

# Install apt dependencies for extensions that declare them in their extension.toml
RUN --mount=type=cache,target=/var/cache/apt \
    ${ISAACLAB_PATH}/isaaclab.sh -p ${ISAACLAB_PATH}/tools/install_deps.py apt ${ISAACLAB_PATH}/source/extensions && \
    apt -y autoremove && apt clean autoclean && \
    rm -rf /var/lib/apt/lists/*

# for singularity usage, have to create the directories that will binded
RUN mkdir -p ${ISAACSIM_ROOT_PATH}/kit/cache && \
    mkdir -p ${DOCKER_USER_HOME}/.cache/ov && \
    mkdir -p ${DOCKER_USER_HOME}/.cache/pip && \
    mkdir -p ${DOCKER_USER_HOME}/.cache/nvidia/GLCache &&  \
    mkdir -p ${DOCKER_USER_HOME}/.nv/ComputeCache && \
    mkdir -p ${DOCKER_USER_HOME}/.nvidia-omniverse/logs && \
    mkdir -p ${DOCKER_USER_HOME}/.local/share/ov/data && \
    mkdir -p ${DOCKER_USER_HOME}/Documents

# for singularity usage, create NVIDIA binary placeholders
RUN touch /bin/nvidia-smi && \
    touch /bin/nvidia-debugdump && \
    touch /bin/nvidia-persistenced && \
    touch /bin/nvidia-cuda-mps-control && \
    touch /bin/nvidia-cuda-mps-server && \
    touch /etc/localtime && \
    mkdir -p /var/run/nvidia-persistenced && \
    touch /var/run/nvidia-persistenced/socket

# installing Isaac Lab dependencies
# use pip caching to avoid reinstalling large packages
RUN --mount=type=cache,target=${DOCKER_USER_HOME}/.cache/pip \
    ${ISAACLAB_PATH}/isaaclab.sh --install

# aliasing isaaclab.sh and python for convenience
RUN echo "export ISAACLAB_PATH=${ISAACLAB_PATH}" >> ${HOME}/.bashrc && \
    echo "alias isaaclab=${ISAACLAB_PATH}/isaaclab.sh" >> ${HOME}/.bashrc && \
    echo "alias python=${ISAACLAB_PATH}/_isaac_sim/python.sh" >> ${HOME}/.bashrc && \
    echo "alias python3=${ISAACLAB_PATH}/_isaac_sim/python.sh" >> ${HOME}/.bashrc && \
    echo "alias pip='${ISAACLAB_PATH}/_isaac_sim/python.sh -m pip'" >> ${HOME}/.bashrc && \
    echo "alias pip3='${ISAACLAB_PATH}/_isaac_sim/python.sh -m pip'" >> ${HOME}/.bashrc && \
    echo "alias tensorboard='${ISAACLAB_PATH}/_isaac_sim/python.sh ${ISAACLAB_PATH}/_isaac_sim/tensorboard'" >> ${HOME}/.bashrc && \
    echo "export TZ=$(date +%Z)" >> ${HOME}/.bashrc


COPY ./entrypoint.sh /entrypoint.sh
RUN sudo chmod 777 /entrypoint.sh


# make working directory as the Isaac Lab directory
# this is the default directory when the container is run
WORKDIR ${ISAACLAB_PATH}
CMD ["/entrypoint.sh"]
