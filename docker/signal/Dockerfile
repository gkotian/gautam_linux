FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
        curl \
        gnupg \
        libx11-xcb-dev && \
    curl -s https://updates.signal.org/desktop/apt/keys.asc | apt-key add - && \
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | tee -a /etc/apt/sources.list.d/signal-xenial.list && \
    apt-get update && \
    apt-get install -y signal-desktop

CMD signal-desktop
