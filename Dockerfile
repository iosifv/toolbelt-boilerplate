# This file is inspired from these examples:
# https://github.com/BretFisher/php-docker-good-defaults/blob/master/Dockerfile
# https://github.com/BretFisher/node-docker-good-defaults/blob/master/Dockerfile

# Base image will be a clean ubuntu
FROM ubuntu:latest

# Set maintainer as myself
LABEL author="iosif v"
LABEL email="dev@iosifv.com"

# Add arguments from CLI
ARG ssh_private_key
ARG ssh_public_key

# Update aptitude with new repo
RUN apt-get -yqq update \
    # System
    && apt-get -yqq install \
    ssh git nano curl zsh apt-utils wget \
    # Monitoring
    && apt-get -yqq install \
    multitail iputils-ping speedtest-cli ncdu speedometer htop nmon && export NMON=clmnd \
    # Fun
    && apt-get -yqq install \
    screenfetch inxi ansiweather cowsay lolcat fortune telnet \
    # Utils
    && apt-get -yqq install \
    tmux ack mc pandoc lynx thefuck python-pygments

# cat whith a nicer interface
RUN wget -O bat.deb https://github.com/sharkdp/bat/releases/download/v0.11.0/bat_0.11.0_amd64.deb  && \
    dpkg -i bat.deb && rm bat.deb

# Git Configuration
RUN git config --global user.email "dev@iosifv.com" && \
    git config --global user.name "Iosif V."
# RUN git config --global core.autocrlf true

# Make ssh dir
RUN mkdir /root/.ssh/
WORKDIR /root/.ssh

# add bitbucket and github to known hosts for ssh needs
RUN touch /root/.ssh/known_hosts
# RUN chown root /root/.ssh
RUN chmod 0600 /root/.ssh
RUN ssh-keyscan -t rsa bitbucket.org >> /root/.ssh/known_hosts
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# Copy over private key, and set permissions
# Warning! Anyone who gets their hands on this image will be able
# to retrieve this private key file from the corresponding image layer
# Add the keys and set permissions
RUN echo "$ssh_private_key" > /root/.ssh/id_rsa && \
    echo "$ssh_public_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

# Create a new user
# RUN useradd -ms /bin/bash docker
# RUN mkdir /home/docker/www
# WORKDIR /home/docker/www


WORKDIR /www

# Install Oh my Zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

WORKDIR /www/github
# Install Terminal Toolbelt
RUN git clone git@github.com:iosifv/terminal-toolbelt.git && \
    echo "source /www/github/terminal-toolbelt/loader-docker.sh" >> ~/.zshrc

WORKDIR /www
