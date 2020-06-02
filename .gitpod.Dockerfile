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
    && sudo apt-get update \
    && sudo apt-get dist-upgrade -o APT::Immediate-Configure=0 \
    && sudo apt-get install -y libc6 libc6-i686 wine32
