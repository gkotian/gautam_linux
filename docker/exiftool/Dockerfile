FROM ubuntu:18.04

ARG USERNAME
ARG USERID

ARG TOP_LEVEL_DIR="exiftool"

RUN apt-get update && \
    apt-get -y install \
        libimage-exiftool-perl && \
    useradd -u ${USERID} -m ${USERNAME} && \
    mkdir -p /${TOP_LEVEL_DIR} && \
    chown ${USERNAME} /${TOP_LEVEL_DIR}

USER ${USERNAME}
WORKDIR /${TOP_LEVEL_DIR}

CMD [ "/bin/bash" ]
