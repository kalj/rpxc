FROM debian:stretch

ARG PI_TOOLS_GIT_REF=master
ARG RUST_VERSION=stable

# update system
RUN apt-get update
RUN apt-get install -y curl git gcc vim file xz-utils

RUN useradd -ms /bin/bash rust

USER rust
ENV HOME /home/rust
ENV USER rust
ENV SHELL /bin/bash
WORKDIR /home/rust

# get rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly
ENV PATH="$HOME/.cargo/bin:$PATH"

# set up rust for cross compilation
RUN rustup target add arm-unknown-linux-gnueabihf
RUN rustup target add armv7-unknown-linux-gnueabihf

USER root
RUN apt-get install -y gcc-arm-linux-gnueabihf
# RUN apt-get install -y gcc-armv7l-linux-gnueabihf

ARG RASPBERRY_PI_TOOLS_COMMIT_ID=49719d5544cd33b8c146235e1420f68cd92420fe
RUN curl -sL https://github.com/raspberrypi/tools/archive/$RASPBERRY_PI_TOOLS_COMMIT_ID.tar.gz \
        | tar xzf - -C /usr/local --strip-components=1 tools-${RASPBERRY_PI_TOOLS_COMMIT_ID}/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf

USER rust

# set configuration
COPY cargo-config $HOME/.cargo/config

# prepare shell
RUN echo "export PATH=~/.cargo/bin:$PATH" >> ~/.bashrc

COPY run.sh $HOME/run.sh
ENTRYPOINT ["./run.sh"]
