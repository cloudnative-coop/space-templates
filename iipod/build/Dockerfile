FROM ubuntu:lunar-20230615

RUN DEBIAN_FRONTEND=noninteractive \
    apt update \
    && apt upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
      software-properties-common \
      gpg-agent \
      curl \
    && add-apt-repository ppa:git-core/ppa -y \
    && add-apt-repository ppa:mozillateam/ppa -y \
    && add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" -y \
    && add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y \
    && apt-add-repository "deb http://packages.cloud.google.com/apt cloud-sdk main" -y \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/google.gpg \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash -x - \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
    tmux \
    ttyd \
    tmate \
    bash-completion \
    less \
	git \
	golang \
	xz-utils \
	sudo \
	vim \
	wget \
    dpkg-dev \
    devscripts \
    libgccjit-12-dev \
    libgtk-3-bin \
    openssh-client \
    postgresql-client \
    jq \
    apache2-utils \
    inotify-tools \
    xtermcontrol \
    tzdata \
    silversearcher-ag \
    direnv \
    rsync \
    lsof \
    htop \
    file \
    unzip \
    psmisc \
    iproute2 \
    tcpdump \
    openjdk-17-jdk \
    rlwrap \
    fonts-powerline \
    flatpak-xdg-utils \
    google-cloud-sdk \
    bsdmainutils \
    awscli \
    python3-pip \
    dnsutils \
    net-tools \
    tree \
    iputils-ping \
    iftop \
    ripgrep \
    python-is-python3 \
    pipenv \
    gettext-base \
    locate \
    fd-find \
    graphviz \
    netcat-openbsd \
    asciinema \
    ssh-import-id \
    docker-ce-cli \
    novnc \
    tigervnc-standalone-server \
    icewm \
    kitty \
    plasma-desktop \
    dbus-x11 \
    firefox-esr \
    websockify \
    code \
	&& ln -s /usr/bin/fdfind /usr/local/bin/fd \
	&& rm -rf /var/lib/apt/lists/*
    # ubuntu-desktop \
    # && apt-key fingerprint 0EBFCD88 \

COPY arch-helper.sh /usr/local/lib/arch-helper.sh
# Settings for GO and crictl
ENV GOROOT=/usr/local/go \
  GO_VERSION=1.20.5 \
  PATH="$PATH:/usr/local/go/bin:/usr/libexec/flatpak-xdg-utils:/home/ii/go/bin" \
  CONTAINERD_NAMESPACE=k8s.io
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://dl.google.com/go/go${GO_VERSION}.linux-${ARCH_TYPE_2}.tar.gz \
    | tar --directory /usr/local --extract --ungzip
# kind binary
ENV KIND_VERSION=0.20.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -Lo /usr/local/bin/kind \
    https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/kind-linux-${ARCH_TYPE_2} \
    && chmod +x /usr/local/bin/kind
# kubectl binary
ENV KUBECTL_VERSION=1.27.3
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH_TYPE_2}/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl
# tilt binary
ENV TILT_VERSION=0.32.4
RUN . /usr/local/lib/arch-helper.sh \
  && curl -fsSL \
    https://github.com/tilt-dev/tilt/releases/download/v${TILT_VERSION}/tilt.${TILT_VERSION}.linux.${ARCH_TYPE_1}.tar.gz \
    | tar --directory /usr/local/bin --extract --ungzip tilt
# gh cli
ENV GH_VERSION=2.30.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -sSL https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${ARCH_TYPE_2}.tar.gz \
    | tar --directory /usr/local --extract --ungzip \
     --strip-components 1 gh_${GH_VERSION}_linux_${ARCH_TYPE_2}/bin/gh \
    && chmod +x /usr/local/bin/gh
# tmate
ENV TMATE_VERSION=2.4.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L \
    https://github.com/tmate-io/tmate/releases/download/${TMATE_VERSION}/tmate-${TMATE_VERSION}-static-linux-${ARCH_TYPE_3}.tar.xz \
    | tar --directory /usr/local/bin --extract --xz \
  --strip-components 1 tmate-${TMATE_VERSION}-static-linux-${ARCH_TYPE_3}/tmate
# helm binary
ENV HELM_VERSION=3.12.1
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH_TYPE_2}.tar.gz | tar --directory /usr/local/bin --extract -xz --strip-components 1 linux-${ARCH_TYPE_2}/helm
# talosctl
ENV TALOSCTL_VERSION=1.1.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L -o /usr/local/bin/talosctl https://github.com/talos-systems/talos/releases/download/v${TALOSCTL_VERSION}/talosctl-linux-${ARCH_TYPE_2} && \
  chmod +x /usr/local/bin/talosctl
# terraform
ENV TERRAFORM_VERSION=1.5.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH_TYPE_2}.zip \
  | gunzip -c - > /usr/local/bin/terraform && \
  chmod +x /usr/local/bin/terraform
ENV CRICTL_VERSION=1.27.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/v${CRICTL_VERSION}/crictl-v${CRICTL_VERSION}-linux-${ARCH_TYPE_2}.tar.gz \
  | tar --directory /usr/local/bin --extract --gunzip crictl
ENV KUBECTX_VERSION=0.9.4
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz | tar --directory /usr/local/bin --extract --ungzip kubectx
ENV FZF_VERSION=0.26.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${ARCH_TYPE_2}.tar.gz | tar --directory /usr/local/bin --extract --ungzip fzf
ENV NERDCTL_VERSION=1.4.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-${ARCH_TYPE_2}.tar.gz | tar --directory /usr/local/bin --extract --ungzip nerdctl
# Leiningen for clojure
ENV CLOJURE_VERSION=1.11.1 LEIN_VERSION=stable
RUN curl -fsSL https://raw.githubusercontent.com/technomancy/leiningen/${LEIN_VERSION}/bin/lein \
    -o /usr/local/bin/lein \
    && chmod +x /usr/local/bin/lein \
    && lein version
ENV KN_VERSION=1.37.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://github.com/knative/client/releases/download/knative-v${KN_VERSION}/kn-linux-${ARCH_TYPE_2} -o /usr/local/bin/kn \
  && chmod +x /usr/local/bin/kn
ENV DIVE_VERSION=0.10.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_${ARCH_TYPE_2}.tar.gz | tar --directory /usr/local/bin --extract --ungzip dive
ENV UPTERM_VERSION=0.10.0
RUN . /usr/local/lib/arch-helper.sh \
  && curl -L https://github.com/owenthereal/upterm/releases/download/v${UPTERM_VERSION}/upterm_linux_${ARCH_TYPE_2}.tar.gz | tar --directory /usr/local/bin --extract --ungzip upterm
ENV METALCLI_VERSION=0.14.1 \
  KO_VERSION=0.13.0 \
  GOPLS_VERSION=0.10.0
RUN set -x \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install golang.org/x/tools/gopls@v$GOPLS_VERSION \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/mikefarah/yq/v4@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/stamblerre/gocode@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/fatih/gomodifytags@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/cweill/gotests/...@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/motemen/gore/cmd/gore@v0.5.2 \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install golang.org/x/tools/cmd/guru@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/minio/mc@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/jessfraz/dockfmt@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install gitlab.com/safesurfer/go-http-server@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/google/go-containerregistry/cmd/crane@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/google/go-containerregistry/cmd/gcrane@latest \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/equinix/metal-cli/cmd/metal@v$METALCLI_VERSION \
  && /bin/env GO111MODULE=on GOPATH=/usr/local/go /usr/local/go/bin/go install github.com/google/ko@v$KO_VERSION


RUN curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
RUN sudo su -c "helm completion bash > /etc/bash_completion.d/helm"
RUN curl -s https://fluxcd.io/install.sh | bash
RUN sudo su -c "flux completion bash > /etc/bash_completion.d/flux"
RUN sudo su -c "kubectl completion bash > /etc/bash_completion.d/kubectl"

# Ensure we have the depes for building emacs from HEAD
RUN add-apt-repository ppa:ubuntu-elisp/ppa --yes && \
  sed -i -e 's/^#\ //' /etc/apt/sources.list.d/ubuntu-elisp-ubuntu-ppa-lunar.list && \
  DEBIAN_FRONTEND="noninteractive" apt-get update && \
  DEBIAN_FRONTEND="noninteractive" apt-get -y build-dep emacs-snapshot

# Get emacs src
RUN mkdir -p /usr/local/src && \
  cd /usr/local/src && \
  git clone --depth 1 https://git.savannah.gnu.org/git/emacs.git

# Get emacs src
RUN cd /usr/local/src/emacs && \
  ./autogen.sh && \
  ./configure --prefix=/usr/local \
    --with-modules=yes \
    --with-json=yes \
    --with-native-compilation=yes \
    --with-x=yes \
    --with-x-toolkit=gtk3 \
    --with-xwidgets=yes \
    --with-pgtk=yes && \
  make -j 64 && \
  make install

RUN cd /usr/local/src/emacs && \
  ./autogen.sh && \
  ./configure --prefix=/usr/local/stow/emacs-x \
    --with-modules=yes \
    --with-json=yes \
    --with-native-compilation=yes \
    --with-x=yes \
    --with-x-toolkit=gtk3 \
    --with-xwidgets=yes \
    --with-pgtk=no && \
  make -j 64 && \
  make install

# Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh  | tee ~/code-server-install.log
RUN curl -fsSL https://coder.com/install.sh | sh
# Links
RUN ln -sf /usr/bin/firefox-esr /usr/bin/firefox
RUN ln -s /usr/bin/coder /usr/local/bin/coop
RUN ln -s /usr/bin/coder /usr/local/bin/space

ARG USER=ii
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}

USER $USER
WORKDIR /home/${USER}
RUN mkdir -p ~/.config

# Doom Emacs
RUN git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
RUN git clone --depth 1 https://github.com/ii/doom-config ~/.config/doom
RUN yes | ~/.config/emacs/bin/doom install --env --fonts
RUN cd ~/.config/doom && git pull && ~/.config/emacs/bin/doom sync || true && true || true && true

COPY home/.tmux.conf /home/ii/.tmux.conf
RUN mkdir -p ~/.config/code-server
COPY home/.config/code-server/config.yaml /home/ii/.config/code-server/config.yaml
