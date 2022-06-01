#!/bin/bash -xe
# Copyright (c) 2016 Arduino LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.



function build_linux () {
	local dist_dir="$1"
	local arch_name="$2"


	export CROSS_TRIPLE=$arch_name
	mkdir -p $dist_dir

	cd libusb
	export LIBUSB_DIR=`pwd`
	./configure --enable-static --disable-shared --disable-udev --host="$arch_name"
	make clean
	make
	cd ..

	cd dfu-util
	USB_CFLAGS="-I$LIBUSB_DIR/libusb/" USB_LIBS="-L$LIBUSB_DIR/libusb/.libs/ -lusb-1.0 -lpthread" ./configure --host="$arch_name"
	make clean
	CFLAGS=-static make
	cp src/dfu-suffix src/dfu-prefix src/dfu-util "../$dist_dir"
	cd ..
}

# Intel builds want -lrt. ARM builds don't
export CFLAGS="-lrt"
if [ -n $BUILD_IN_DOCKER ]; then
build_linux "distrib/linux64" "i386-linux-gnu"
build_linux "distrib/linux32" "x86_64-linux-gnu"
else
build_linux "distrib/linux64" "x86_64-ubuntu16.04-linux-gnu"
build_linux "distrib/linux32" "i686-ubuntu16.04-linux-gnu"
fi

export CFLAGS=""

build_linux "distrib/arm" "arm-linux-gnueabihf"
build_linux "distrib/arm64" "aarch64-linux-gnu"

