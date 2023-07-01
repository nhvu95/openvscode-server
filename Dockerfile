FROM gitpod/openvscode-server:latest

ENV VSCODE-WORKSPACE="/tmp/playground"
ENV OPENVSCODE_SERVER_ROOT="/home/.openvscode-server"
ENV OPENVSCODE="${OPENVSCODE_SERVER_ROOT}/bin/openvscode-server"

RUN sudo apt update
# the installation process for software needed

RUN sudo mkdir -m 777 /tmp/playground
RUN sudo usermod -l playground-nhvu95 openvscode-server
RUN sudo groupmod -n playground-nhvu95 openvscode-server

SHELL ["/bin/bash", "-c"]
RUN wget https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh
RUN bash install.sh
RUN echo "source ~/.nvm/nvm.sh" > ~/.bashrc
RUN echo "source ~/.nvm/nvm.sh" > ~/.profile

SHELL ["/bin/bash", "--login" , "-c"]
RUN nvm install 18
RUN nvm use 18
RUN npm install -g ts-node typescript '@types/node'
SHELL ["/bin/sh", "-c"]
SHELL ["/bin/bash", "-c"]
RUN \
    # Direct download links to external .vsix not available on https://open-vsx.org/
    # The two links here are just used as example, they are actually available on https://open-vsx.org/
    urls=(\
        https://github.com/angular/vscode-ng-language-service/releases/download/v16.0.0/ng-template.vsix \
        https://github.com/VSCodeVim/Vim/releases/download/v1.24.3/vim-1.24.3.vsix \
    )\
    # Create a tmp dir for downloading
    && tdir=/tmp/exts && mkdir -p "${tdir}" && cd "${tdir}" \
    # Download via wget from $urls array.
    && wget "${urls[@]}" && \
    # List the extensions in this array
    exts=(\
        # From https://open-vsx.org/ registry directly
        gitpod.gitpod-theme \
        # From filesystem, .vsix that we downloaded (using bash wildcard '*')
        "${tdir}"/* \
    )\
    # Install the $exts
    && for ext in "${exts[@]}"; do ${OPENVSCODE} ${VSCODE-WORKSPACE} --install-extension "${ext}"; done