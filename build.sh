#!/bin/bash


release_flag=""
if [ $# -gt 0 ] && [ $1 == "-r" ] ; then
    release_flag="--release"
fi

docker run -tv ~/.cargo/registry:/home/rust/.cargo/registry -v $(pwd):/home/rust/package pizw build --target arm-unknown-linux-gnueabihf ${release_flag}
