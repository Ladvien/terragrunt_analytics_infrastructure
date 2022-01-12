#!/bin/bash
######################################
# Create user ${OS_USER_NAME}
######################################
adduser -G wheel ${OS_USER_NAME}
passwd -d ${OS_USER_NAME} 
cp -rp /home/centos/.ssh /home/${OS_USER_NAME}/
cp -rp /home/centos/.bashrc /home/${OS_USER_NAME}/
cp -rp /home/centos/.profile /home/${OS_USER_NAME}/
chown -R ${OS_USER_NAME}:${OS_USER_NAME} /home/${OS_USER_NAME}

######################################
# General instance Setup
######################################
yum update -y
yum install -y git \
               python3 \
               python3-pip \
               epel-release \
               amazon-linux-extras \
               awscli 

########################################
# We must run everything with "runuser"
# as the "su - user" command is unavailable.
########################################

######################################
# Download Airflow Setup Script
######################################
runuser -u ${OS_USER_NAME} -- git clone https://github.com/Ladvien/airflow_setup.git /home/${OS_USER_NAME}/airflow_setup

######################################
# Install Python packages
######################################
pip3 install ${PYTHON3_PACKAGES}
runuser -u ${OS_USER_NAME} -- pip3 install ${PYTHON3_PACKAGES}

######################################
# Run Airflow Setup Script
######################################

runuser -u ${OS_USER_NAME} -- \
    /bin/python3 /home/af-admin/airflow_setup/airflow_setup.py \
    --user ${OS_USER_NAME} \
    --region ${AWS_REGION}
