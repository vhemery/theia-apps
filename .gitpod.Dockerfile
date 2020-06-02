FROM gitpod/workspace-full
# base from gitpod/workspace-full
# inspired from theiaide/theia-electron-builder
USER root

ENV DEBIAN_FRONTEND noninteractive

# RUN curl -L https://yarnpkg.com/latest.tar.gz | tar xvz && mv yarn-* /yarn && ln -s /yarn/bin/yarn /usr/bin/yarn
RUN apt-get -qq update && apt-get -qq dist-upgrade && \
    # add repo for git-lfs
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    # git ssh for using as docker image on CircleCI
    # python for node-gyp
    # rpm is required for FPM to build rpm package
    # libsecret-1-dev and libgnome-keyring-dev are required even for prebuild keytar
    apt-get -qq install --no-install-recommends qtbase5-dev \
    # removed bsdtar https://github.com/intel/lkp-tests/issues/50
    build-essential autoconf libssl-dev gcc-multilib g++-multilib lzip rpm python libcurl4 git git-lfs ssh unzip \
    # removed libgnome-keyring-dev not in focal
    libsecret-1-dev \
    libopenjp2-tools && \
    # git-lfs
    git lfs install && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*

# COPY test.sh /test.sh

WORKDIR /project

# fix error /usr/local/bundle/gems/fpm-1.5.0/lib/fpm/package/freebsd.rb:72:in `encode': "\xE2" from ASCII-8BIT to UTF-8 (Encoding::UndefinedConversionError)
# http://jaredmarkell.com/docker-and-locales/
# http://askubuntu.com/a/601498
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

ENV DEBUG_COLORS true
ENV FORCE_COLOR true

# Proper custom content

# AppVeyor to build windows on linux
#RUN curl -L https://www.appveyor.com/downloads/appveyor/appveyor-server.deb -o appveyor-server_7.0.2546_amd64.deb \
#    && dpkg -i appveyor-server_7.0.2546_amd64.deb
# To build app in 32 bit from a machine with 64 bit
# RUN sudo apt-get install --no-install-recommends -y gcc-multilib g++-multilib
# Install Wine and mono to build for windows
#RUN apt install -y wine64 mono-complete
#RUN dpkg --add-architecture i386 \
#    && sudo apt-get update -y \
#    && sudo apt-get dist-upgrade -y -o APT::Immediate-Configure=0 \
#    && sudo apt-get install -y cabextract libxext6 libxext6:i386 libfreetype6 libfreetype6:i386 libc6 libc6-i686 wine32

USER gitpod

WORKDIR ~

# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && #     sudo apt-get install -yq bastet && #     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/
RUN sudo apt-get install -y g++ gcc make python2.7 pkg-config libx11-dev
# libxkbfile-dev
RUN sudo apt-get install -y lsof
# libnss3-dev
# This loads nvm and bash_completion
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && . $NVM_DIR/nvm.sh \
    && . $NVM_DIR/bash_completion \
    && nvm install 10 \
    && nvm alias default 10 \
    && nvm use default
RUN npm install -g yarn
