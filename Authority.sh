 #
 # Copyright © 2016, Aayush Jain   "AayushJainRd7"   <aayush835@gmail.com>
 #
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image
DTBTOOL=$KERNEL_DIR/dtbToolCM
TOOLCHAIN_DIR="/home/aayushrd7/UBERTC-aarch64-linux-android-5.3-kernel-1144fd2773c1/bin/"
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
# Modify the following variable if you want to build
export TOOLCHAIN_DIR="/home/aayushrd7/UBERTC-aarch64-linux-android-5.3-kernel-1144fd2773c1/bin/aarch64-linux-android-"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="AayushRd7"
export KBUILD_BUILD_HOST="AutHoRiTy-PoWeR"
STRIP="/home/aayushrd7/UBERTC-aarch64-linux-android-5.3-kernel-1144fd2773c1/bin/aarch64-linux-android-strip"
MODULES_DIR=/home/aayushrd7/yu_msm8916/common
OUT_DIR=/home/aayushrd7/yu_msm8916/Tomato

compile_kernel ()
{
echo -e "**********************************************************************************************"
echo "                    "
echo "                                        Compiling AUTHORITY Kernel                    "
echo "                    "
echo -e "**********************************************************************************************"
make cyanogenmod_tomato-64_defconfig
make Image -j8
make dtbs -j8
make modules -j8
if ! [ -a $KERN_IMG ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
strip_modules
}

strip_modules ()
{
echo "Copying modules"
rm $MODULES_DIR/*
find . -name '*.ko' -exec cp {} $MODULES_DIR/ \;
cd $MODULES_DIR
echo "Stripping modules for size"
$STRIP --strip-unneeded *.ko
zip -9 modules *
cd $KERNEL_DIR
}

case $1 in
clean)
make ARCH=arm64 -j8 clean mrproper
rm -rf $KERNEL_DIR/arch/arm/boot/dt.img
;;
*)
compile_kernel
;;
esac

rm -rf $OUT_DIR/AuthorityKernel*.zip
rm -rf $OUT_DIR/tools/*
rm -rf $OUT_DIR/system/lib/modules/*
cp -r $KERNEL_DIR/Authority/tools $OUT_DIR
cp $KERNEL_DIR/arch/arm64/boot/Image  $OUT_DIR/tools
cp $KERNEL_DIR/arch/arm64/boot/dt.img  $OUT_DIR/tools
mv $OUT_DIR/tools/Image $OUT_DIR/tools/Image
cp $MODULES_DIR/*.ko $OUT_DIR/system/lib/modules/
cd $OUT_DIR
zip -r AuthorityKernel_UBTC-v3.0-$(date +"%Y-%m-%d"-%H%M).zip *
cd $KERNEL_DIR
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
echo -e "**********************************************************************************************"
echo "                    "
echo "                                        Enjoy Authority Kernel                    "
echo "                             AuthorityKernel-v3.0-$(date +"%Y-%m-%d"-%H%M).zip  " 
echo " "
echo -e "**********************************************************************************************"
