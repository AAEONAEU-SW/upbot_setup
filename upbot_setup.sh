#!/bin/bash


## Install ROS
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt-get install ros-kinetic-desktop-full
sudo rosdep init
rosdep update
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
sudo apt install python-rosinstall python-rosinstall-generator python-wstool build-essential


## Add RealSense Support
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
source /opt/ros/kinetic/setup.bash
catkin_make
echo "RealSense camera must be connected at this point"
read -n 1 -s -r -p "Press any key to continue"
sleep 5
sudo apt-get install linux-headers-4.15.0-37-generic
sudo ln -s /usr/src/linux-headers-4.15.0-37-generic/ /lib/modules/4.15.0-37-generic/build
sudo apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE
sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main" -u
sudo apt-get install librealsense2-dkms
sudo apt-get install librealsense2-utils
sudo apt-get install librealsense2-dev
sudo apt-get install librealsense2-dbg
echo "unplug and re-plug the RealSense camera"
read -n 1 -s -r -p "Press any key to continue"

# Install ROS RealSense
cd ~/catkin_ws/src/
git clone https://github.com/intel-ros/realsense.git
git clone https://github.com/pal-robotics/ddynamic_reconfigure.git
cd ..
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc
source ~/catkin_ws/devel/setup.bash
catkin_make -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release
catkin_make install


## Install ROS OpenVINO with RealSense, Myriad-X support
echo "source /opt/intel/computer_vision_sdk/bin/setupvars.sh" >> ~/.bashrc
source ~/.bashrc
source /opt/intel/computer_vision_sdk/bin/setupvars.sh
cd ~/catkin_ws/src
git clone https://github.com/gbr1/ros_openvino.git
cd ..
catkin_make
catkin_make install


## Install UP Squared leds with ROS

sudo usermod -a -G gpio ${USER}
sudo usermod -a -G leds ${USER}
sudo usermod -a -G spi ${USER}
sudo usermod -a -G i2c ${USER}
sudo usermod -a -G dialout ${USER}
cd ~/catkin_ws/src
git clone https://github.com/gbr1/upboard_ros.git
cd ..
source /opt/ros/kinetic/setup.bash
catkin_make
catkin_make install

#Setup complete rebooting now
echo "Setup complete, reboting now..."
sleep 5 
sudo reboot




