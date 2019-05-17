Build using:
------------
    docker build -t curl-with-sftp /path/to/directory/of/Dockerfile

Run using:
----------
    docker run --rm -it -v ~/.ssh/:/project/ssh --env LD_LIBRARY_PATH=/usr/local/lib/ curl-with-sftp

Within the container:
---------------------
    To confirm curl has SFTP support:
        curl -V
    To download a file:
        curl --key /project/ssh/private-key \
             --pass <passphrase> \
             --compressed-ssh \
             --insecure \
             "sftp://<user>@<server>/path/to/file" \
             --output <file-name>
