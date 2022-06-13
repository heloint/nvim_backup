#!/bin/bash

# Previously check the download link on the official website if it's still not obsolete
wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh
sudo chmod +x Anaconda3-2021.11-Linux-x86_64.sh
./Anaconda3-2021.11-Linux-x86_64.sh

# Create and fetch Python 3.9 environment
conda create --name py39 python=3.9

