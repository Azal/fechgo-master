#!/bin/bash

[ -f ~/.profile ] && source ~/.profile
set -e
cd ~/

# Script para configurar una maquina ubuntu para soportar OTP + Elixir.
# Probado en Ubuntu 16.04

# Language fix
sudo locale-gen "es_CL.UTF-8"

# Setup instructions for Erlang Node
sudo apt-get update && \
  sudo apt-get install nginx-full htop unzip build-essential libncurses5-dev openssl libssl-dev fop xsltproc unixodbc-dev openjdk-11-jdk-headless -y

# Install NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Instal Node v5.6
nvm install 5.6 && nvm use 5.6 --default

# Installing EVM
wget https://github.com/robisonsantos/evm/archive/master.zip && \
  unzip master.zip && \
  (cd evm-master && ./install) && \
  rm master.zip* && \
  rm -rf evm-master && \
  echo "" >> ~/.bashrc && \
  echo 'test -s "$HOME/.evm/scripts/evm" && source "$HOME/.evm/scripts/evm"' >> ~/.bashrc && \
  echo "" >> ~/.profile && \
  echo 'test -s "$HOME/.evm/scripts/evm" && source "$HOME/.evm/scripts/evm"' >> ~/.profile && \
  source ~/.profile && \
  yes | evm install OTP_20.2 && \
  evm default OTP_20.2 && \
  cd ~/

# Installing Kiex
\curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s && \
  echo "" >> ~/.bashrc && \
  echo 'test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"' >> ~/.bashrc && \
  echo "" >> ~/.profile && \
  echo 'test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"' >> ~/.profile && \
  source ~/.profile && \
  kiex install 1.6.5 && \
  kiex use 1.6.5 --default && \
  cd ~/

# Installation of Docker CE using repository
#sudo apt-get update && \
#  sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y && \
#  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
#  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
#  sudo apt-get update && \
#  sudo apt-get install docker-ce -y && \
#  sudo usermod -a -G docker $USER # Configures docker not sudo runs

# After install docker, should restart machine and later, start docker service with:
# sudo service docker start

# Test docker with:
# docker run hello-world
