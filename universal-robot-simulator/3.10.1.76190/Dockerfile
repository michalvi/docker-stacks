FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04
USER root

ARG URL_PREFIX="https://s3-eu-west-1.amazonaws.com/ur-support-site/54394/URSim_Linux-"
ARG VERSION="3.10.1.76190"
ARG EXTENSION=".tar.gz"

ENV DEBIAN_FRONTEND="noninteractive" \
    JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    LANG="en_GB.UTF-8" \
    URSIM_DOWNLOAD_URL="${URL_PREFIX}${VERSION}${EXTENSION}" \
    URSIM_INSTALL_DIR="/opt/ursim" \
    URSIM_ROOT="/opt/ursim/ursimpkg" \
    URSIM_USER="ursim"

SHELL ["/bin/bash", "-c"]

# essentials
RUN set -x \
    && apt-get update \
    && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        locales \
        aptitude \
    && set +x && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_GB.UTF-8

# required packages
RUN set -x \
    && aptitude update \
    && aptitude install --assume-yes --quiet --without-recommends \
        debconf-utils \
        less \
        lib32gcc1 \
        lib32stdc++6 \
        libcurl3:i386 \
        libjava3d-java \
        locate \
        policykit-1 \
        python-software-properties \
        runit \
        software-properties-common \
        sudo \
        vim \
        wget \
        xauth \
        xterm \
        xvfb \
    && set +x && rm -rf /var/lib/apt/lists/*

# URSim prerequisites
RUN set -x \
    && dpkg --add-architecture i386 \
    && aptitude update \
    && aptitude install --assume-yes --quiet --without-recommends \
        libxmlrpc-c++8:i386 \
        openjdk-8-jdk \
        openjdk-8-jre \
    && echo "JAVA_HOME=\"${JAVA_HOME}\"" >> /etc/environment \
    && set +x && rm -rf /var/lib/apt/lists/*

# install graphics drivers and utils
RUN set -x \
    && aptitude update \
    && aptitude install --assume-yes --quiet --without-recommends \
        libgl1-mesa-dri \
        libgl1-mesa-glx \
        mesa-utils \
        mesa-vdpau-drivers \
        module-init-tools \
        xserver-xorg-video-ati \
    && set +x && rm -rf /var/lib/apt/lists/*

# create ursim user (id=1000)
RUN adduser --gecos "URSim User" --home /home/ursim --disabled-password ursim \
    && usermod -a -G dialout ursim \
    && echo "ursim ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

# fetch the package
RUN set -x \
    && mkdir -p "${URSIM_INSTALL_DIR}" \
    && cd "${URSIM_INSTALL_DIR}" \
    && wget --quiet \
        --output-document "ursim.tar.gz" \
        "${URSIM_DOWNLOAD_URL}"

# patch the installation script
RUN set -x \
    && tar -xvzf "${URSIM_INSTALL_DIR}/ursim.tar.gz" \
    && mv "ursim-${VERSION}" "${URSIM_ROOT}" \
    && cd "${URSIM_ROOT}" \
# delete 56 lines to prevent installation of java7
    && sed -i '56c \\t echo \"just ignore install java7\" ' ./install.sh \
# delete 49-50 lines to fix sigterms in xterm
    && sed -i '49,50c \\t echo \"just ignore xterm warning\" ' ./install.sh \
    && sed -i 's/pkexec bash -c/bash -c/g' ./install.sh \
    && sed -i 's/apt-get -y install/apt-get -y install -q --no-install-recommends/g' ./install.sh \
    && sed -i '85,$d' ./install.sh  \
    && sed -i 's/libcurl3/libcurl3:i386/g' ./install.sh  \
    && sed -i 's/fonts-ipafont//g' ./install.sh  \
    && sed -i 's/fonts-baekmuk//g' ./install.sh  \
    && sed -i 's/fonts-nanum//g' ./install.sh  \
    && sed -i 's/fonts-arphic-uming//g' ./install.sh  \
    && sed -i 's/fonts-arphic-ukai//g' ./install.sh  \
    && echo "echo \" installation done! \""  >> ./install.sh

# install URsim and set ownership to ursim
RUN set -x \
    && cd "${URSIM_ROOT}" \
    && ./install.sh \
    && chown -R "${URSIM_USER}:${URSIM_USER}" "${URSIM_ROOT}" \
    && sync \
    && set +x && rm -rf /var/lib/apt/lists/*

# update PATH after the installation
ENV PATH="${URSIM_ROOT}:${PATH}"

# clean the environment
RUN rm -rf /tmp/* /var/tmp/*

USER ursim
WORKDIR "${URSIM_ROOT}"
ENTRYPOINT ["./start-ursim.sh"]
CMD ["UR10"]
