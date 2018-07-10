This container exists because the `pdftk` package is missing in ubuntu 18.04
(bionic).

Steps to use:
    1. Copy all pdf files you want to work with, to a directory called `pdftk`
       somewhere
    2. cd /path/to/pdftk
    3. dockershell

Now you should have a prompt inside the docker container from where you can run
pdftk.
