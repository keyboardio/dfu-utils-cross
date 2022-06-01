# dfu-utils-cross

This repo contains the scripts to compile (and cross-compile from a Linux machine) `dfu-utils` package for Linux (x86_64, x86, arm), OSX and Windows.

For doing so it also compiles `libusb` statically so the resulting binary has zero external dependencies.

Prerequisites:
[osxcross](https://github.com/tpoechtrager/osxcross)
mingw32-w64

Some patches were added to target a bunch of problems with [Arduino101](https://www.arduino.cc/en/Main/ArduinoBoard101) upload procedure

# Building in Docker

Set up your Docker image:

$ docker build -q -t arduino/dfu-utils-builder .

Run the build in Docker:

$ docker run -i -t -v $(pwd):/home/builder/dfu-utils arduino/dfu-utils-builder bash

# License

The bash scripts are GPLv2 licensed. Every other software used by these bash scripts has its own license. Consult them to know the terms.
