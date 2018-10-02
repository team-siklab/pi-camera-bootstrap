#!/usr/bin/env bash

# :: establish working directory
OGPWD=$(pwd)
TMPFRAGMENT="tmp-picamerabootstrap"
mkdir ~/$TMPFRAGMENT
cd ~/$TMPFRAGMENT

# :: ensure our system is baseline upgraded
apt-get update
apt-get upgrade

# :: install dependencies
apt-get install -y \
  build-essential \
  cmake \
  pkg-config

# :: dependencies: image packages
t-get install -y \
  libjpeg-dev \
  libtiff5-dev \
  libjasper-dev \
  libpng12-dev

# :: dependencies: video packages
apt-get install -y \
  libavcodec-dev \
  libavformat-dev \
  libswscale-dev \
  libv4l-dev \
  libxvidcore-dev \
  libx264-dev

# :: dependencies: highgui modules
apt-get install -y \
  libgtk2.0-dev \
  libgtk-3-dev

# :: dependencies: optimizations
apt-get install -y \
  libatlas-base-dev \
  gfortran

# :: Python ---
#    1. Ensure python is installed and updated
#    2. Install and activate virtualenvs
apt-get install -y \
  python2.7-dev \
  python3-dev

wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py

pip install \
  virtualenv \
  virtualenvwrapper

rm -rf ~/.cache/pip

echo -e "\n# virtualenv" >> ~/.profile
echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.profile
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.profile
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.profile

source ~/.profile

# this activates your virtualenv
mkvirtualenv cv -p python3

pip install numpy

# :: OpenCV ---
cd ~/$TMPFRAGMENT
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.3.0.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv/archive/3.3.0.zip
unzip opencv.zip
unzip opencv_contrib.zip

mkdir ~/$TMPFRAGMENT/opencv-3.3.0/build
cd ~/$TMPFRAGMENT/opencv-3.3.0/build

cmake \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D OPENCV_EXTRA_MODULES_PATH=~/$TMPFRAGMENT/opencv_contrib-3.3.0/modules \
  -D BUILD_EXAMPLES=ON ..

echo "\nStarting build. This will take a while.\n"

make -j4
make install
ldconfig

echo "\nBuild completed. Performing final adjustments.\n"

COMPILED=$(ls -l /usr/local/lib/python3.5/site-packages | awk =F' +' '{print $8}' | grep "^cv2.*\.so$")
mv /usr/local/lib/python3.5/site-packages/$COMPILED /usr/local/lib/python3.5/site-packages/cv2.so
ln -s /usr/local/lib/python3.5/site-packages/cv2.so ~/.virtualenvs/cv/lib/python3.5/site-packages/cv2.so

echo "\nPerforming cleanup.\n"

cd $OGPWD
rm -rf ~/$TMPFRAGMENT

echo "\nSetup complete.\nDon't forget to bring your swapfile size back to normal.\n"
