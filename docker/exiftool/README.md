## To view/remove metadata from images

1. USERNAME=$(id -un) USERID=$(id -u) docker-compose build
2. docker run --rm -it -v /path/to/dir/with/images:/exiftool exiftool
3. within the container:
   a. to view image metadata:
          exiftool <filename>
   b. to remove metadata of a single image:
          exiftool -all= -overwrite_original <filename>
   c. to remove metadata of all images matching extension:
          exiftool -all= -overwrite_original -ext jpg .
      (note that extension matching is case-sensitive)
