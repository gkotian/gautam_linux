## Motivation

This container exists because the `pdftk` package is missing in ubuntu 18.04
(bionic).

## Steps to use

1. `USERNAME=$(id -un) USERID=$(id -u) docker-compose -f ~/play/gautam_linux/docker/pdftk/docker-compose.yml up -d`
1. `cd /path/to/directory/with/pdf/files`
1. `docker exec -it pdftk bash`
1. Use pdftk inside the container
1. When finished, `docker-compose -f ~/play/gautam_linux/docker/pdftk/docker-compose.yml down`
