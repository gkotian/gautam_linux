FROM ubuntu:18.04

ARG USERNAME
ARG USERID

RUN apt-get update && \
    apt-get -y install \
        krita && \
    useradd -u ${USERID} -m ${USERNAME} && \
    mkdir -p /project && \
    chown ${USERNAME} /project

USER ${USERNAME}
WORKDIR /project

CMD [ "krita" ]
