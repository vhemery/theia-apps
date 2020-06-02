FROM gitpod/workspace-full
#theiaide/theia-full

USER gitpod

# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && #     sudo apt-get install -yq bastet && #     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/
RUN sudo apt-get install -y g++ gcc make python2.7 pkg-config libx11-dev libxkbfile-dev
RUN sudo apt-get install -y lsof libnss3-dev
# This loads nvm and bash_completion
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && . $NVM_DIR/nvm.sh \
    && . $NVM_DIR/bash_completion \
    && nvm install 10 \
    && nvm alias default 10 \
    && nvm use default
RUN npm install -g yarn
# AppVeyor to build windows on linux
RUN curl -L https://www.appveyor.com/downloads/appveyor/appveyor-server.deb -o appveyor-server_7.0.2546_amd64.deb \
    && sudo dpkg -i appveyor-server_7.0.2546_amd64.deb
# To build app in 32 bit from a machine with 64 bit
RUN sudo apt-get install --no-install-recommends -y gcc-multilib g++-multilib
# Install Wine and mono to build for windows
RUN sudo apt install -y wine64 mono-complete
RUN sudo dpkg --add-architecture i386 \
    && sudo apt-get update -y \
    && sudo apt-get dist-upgrade -y -o APT::Immediate-Configure=0 \
    && sudo apt-get install -y libc6 libc6-i686 wine32
# From Wine dockerfile : https://github.com/electron-userland/electron-builder/blob/master/docker/wine/Dockerfile
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends software-properties-common && sudo dpkg --add-architecture i386 && \
    curl -L https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key > winehq.key && apt-key add winehq.key && \
    sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./' && \
    sudo apt-get update && \
    sudo apt-get -y purge software-properties-common libdbus-glib-1-2 python3-dbus python3-gi python3-pycurl python3-software-properties && \
    sudo apt-get install -y --no-install-recommends winehq-stable && \
    # clean
    sudo apt-get clean && rm -rf /var/lib/apt/lists/* && unlink winehq.key

RUN curl -L https://github.com/electron-userland/electron-builder-binaries/releases/download/wine-2.0.3-mac-10.13/wine-home.zip > /tmp/wine-home.zip && unzip /tmp/wine-home.zip -d /root/.wine && unlink /tmp/wine-home.zip

ENV WINEDEBUG -all,err+all
ENV WINEDLLOVERRIDES winemenubuilder.exe=d
