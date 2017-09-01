#!/usr/bin/env bash

# ----------------------------------------
# Globals
# ----------------------------------------
USER=dishmael

# ----------------------------------------
# This should be run as root
# ----------------------------------------
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

# ----------------------------------------
# Install packages
# ----------------------------------------
yum install -y \
	epel-release \
	vim \
	git \
	golang \
	java-1.8.0-openjdk-devel.x86_64 \
	java-1.8.0-openjdk.x86_64 

# ----------------------------------------
# Configure user
# ----------------------------------------
id -u ${USER} &>/dev/null
if [ $? -eq 1 ]; then
	useradd ${USER}
	cd /home/${USER}
	cp -R ~centos/.ssh .
	chown -R ${USER}:${USER} .ssh
	cat ~dishmael/id_rsa.pub >> ~dishmael/.ssh/authorized_keys
	cp /etc/sudoers /etc/sudoers.bak
	mv ~dishmael/sudoers /etc/sudoers
fi
