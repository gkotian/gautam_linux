To build:
---------
    docker build -t krita --build-arg USERNAME=$(id -un) --build-arg USERID=$(id -u) /path/to/parent/directory/of/Dockerfile
        OR
    USERNAME=$(id -un) USERID=$(id -u) docker-compose -f /path/to/docker-compose.yml build

To run:
-------
    docker run --rm -v /tmp/.X11-unix/:/tmp/.X11-unix -v ${HOME}/tmp_home/krita:/project -e DISPLAY krita
        OR
    docker-compose up

Which Dockerfile to use:
------------------------
The last time I checked, the debian image took up less space (even though the
base ubuntu image was smaller):

debian               stable              f335d3351fbd        8 days ago          101MB
krita_debian         latest              e836f74c77f8        2 minutes ago       821MB

ubuntu               18.04               7698f282e524        4 weeks ago         69.9MB
krita_ubuntu         latest              ba47dec1732c        58 seconds ago      993MB
