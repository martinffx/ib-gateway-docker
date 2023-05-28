# Builder
FROM ubuntu:22.04 AS builder

RUN apt-get update \
    && apt-get install -y \
    unzip \
    dos2unix \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN wget -q --progress=bar:force:noscroll --show-progress \
    https://download2.interactivebrokers.com/installers/tws/stable-standalone/tws-stable-standalone-linux-x64.sh \
    -O install-ibgateway.sh \
    && chmod a+x install-ibgateway.sh

RUN wget -q --progress=bar:force:noscroll --show-progress \
    https://github.com/IbcAlpha/IBC/releases/download/3.16.0/IBCLinux-3.16.0.zip \
    -O ibc.zip \
    && unzip ibc.zip -d /opt/ibc \
    && chmod a+x /opt/ibc/*.sh /opt/ibc/*/*.sh

COPY run.sh run.sh
RUN dos2unix run.sh

# Application
FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y \
    x11vnc \
    xvfb \
    socat \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash docker
WORKDIR /home/docker

USER docker
COPY --from=builder /root/install-ibgateway.sh install-ibgateway.sh
RUN printf "/home/docker/Jts/981\nn" | ./install-ibgateway.sh

RUN mkdir .vnc \
    && x11vnc -storepasswd password .vnc/passwd

COPY --from=builder /opt/ibc /opt/ibc
COPY --from=builder /root/run.sh run.sh
COPY ibc_config.ini ibc/config.ini

ENV DISPLAY :0
ENV TRADING_MODE paper
ENV TWS_PORT 4002
ENV VNC_PORT 5900

EXPOSE $TWS_PORT
EXPOSE $VNC_PORT

CMD ./run.sh
