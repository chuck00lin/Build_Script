#!/bin/bash
#LIBREALSENSE_VERSION=v2.41.0
INSTALL_DIR=${HOME}/TOOL/librealsense
cd $INSTALL_DIR
echo $PWD

read -p "Are you sure? (y for yes) " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

echo ""

#read -n 1 -s -r -p "Press any key to continue"
#read -p "Press enter to continue"
#echo ""

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

#echo "${green}Cloning librealsense${reset}"
#git clone https://github.com/IntelRealSense/librealsense.git

# installDependencies
#echo "${green}adding universe repository and updating${reset}"
#sudo apt-add-repository universe
#sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade -y

echo "${green}Adding dependencies, graphics libraries and tools${reset}"
sudo apt-get install libusb-1.0-0-dev pkg-config libglfw3-dev libssl-dev -y

#pyhton
sudo apt-get install -y python3 python3-dev

mkdir -p build && cd build

cmake -DBUILD_EXAMPLES=true \
	-DBUILD_SHARED_LIBS=false \
       	-DCMAKE_BUILD_TYPE=release ..
#     	-DBUILD_PYTHON_BINDINGS=bool:true ..

echo "${red}Make success${reset}"
read -p "Press Anter to Continue"

NUM_CPU=$(nproc)
time make -j$(($NUM_CPU))
if [ $? -eq 0 ] ; then
  echo "librealsense make successful"
else
  echo "librealsense did not successfully build" >&2
  exit 1
fi

sudo make install

echo "${green}Library Installed${reset}"
echo " "
echo " -----------------------------------------"
echo "The library is installed in /usr/local/lib"
echo "The header files are in /usr/local/include"
echo "The demos and tools are located in /usr/local/bin"
echo " "
echo " -----------------------------------------"
echo " "
cd $INSTALL_DIR
echo "${green}Applying udev rules${reset}"
# Copy over the udev rules so that camera can be run from user space
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger

