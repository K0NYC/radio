#!/bin/bash

apt install -y vim git libusb-1.0-0-dev librtlsdr-dev libpulse-dev libgtk-3-dev freeglut3 freeglut3-dev automake cmake libsndfile1-dev libliquid-dev libsox-fmt-all sox vlc net-tools lame audacity ssh xrdp

mkdir $HOME/gits
cd $HOME/gits

# Install RTL-SDR
git clone https://github.com/keenerd/rtl-sdr
cd rtl-sdr
mkdir build
cd build
cmake -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON ../
sudo make install
ldconfig

echo "blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
blacklist dvb_usb_rtl2832u
blacklist dvb_usb_v2
blacklist dvb_core" \
 > /etc/modprobe.d/rtlsdr-blacklist.conf

echo "dtparam=audio=on" >> /boot/firmware/usercfg.txt

# Build and install SoapySDR
cd $HOME/gits/
git clone https://github.com/pothosware/SoapySDR.git
cd SoapySDR
mkdir build
cd build
cmake ../ -DCMAKE_BUILD_TYPE=Release
sudo make -j4
sudo make install
ldconfig
SoapySDRUtil --info

#Build and install liquid-dsp
cd $HOME/gits/
git clone https://github.com/jgaeddert/liquid-dsp
cd liquid-dsp
./bootstrap.sh
CFLAGS="-march=native -O3" ./configure --enable-fftoverride 
sudo make -j4
sudo make install
ldconfig

# Build static wxWidgets
cd $HOME/Downloads/
wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.4/wxWidgets-3.1.4.tar.bz2
tar -xvjf wxWidgets-3.1.4.tar.bz2
cd wxWidgets-3.1.4/
mkdir -p ~/Develop/wxWidgets-staticlib
./autogen.sh
./configure --with-opengl --disable-shared --enable-monolithic --with-libjpeg --with-libtiff --with-libpng --with-zlib --disable-sdltest --enable-unicode --enable-display --enable-propgrid --disable-webkit --disable-webview --disable-webviewwebkit --prefix=`echo ~/Develop/wxWidgets-staticlib` CXXFLAGS="-std=c++0x"
sudo make -j4 && sudo make install

# Build CubicSDR
cd $HOME/gits/
git clone https://github.com/cjcliffe/CubicSDR.git
cd CubicSDR
mkdir build
cd build
cmake ../ -DCMAKE_BUILD_TYPE=Release -DwxWidgets_CONFIG_EXECUTABLE=~/Develop/wxWidgets-staticlib/bin/wx-config
sudo make
cd x64/
cd ..
sudo make install

# SoapyRTLSDR
cd $HOME/gits/
git clone https://github.com/pothosware/SoapyRTLSDR.git
cd SoapyRTLSDR
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
sudo make
sudo make install
sudo ldconfig
# should now show RTL-SDR device if connected
SoapySDRUtil --info

# Install Deinvert
cd $HOME/gits/
git clone https://github.com/windytan/deinvert.git
cd deinvert/
./autogen.sh
./configure
sudo make
ldconfig
