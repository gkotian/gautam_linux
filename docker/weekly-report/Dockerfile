FROM ubuntu:16.04

RUN apt-get update && apt-get -y install \
    python3 \
    python3-pip

COPY requirements.txt /setup/
RUN pip3 install -r /setup/requirements.txt

ENV IN_DOCKER_CONTAINER True
