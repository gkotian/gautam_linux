1. `cp slick-greeter.conf /etc/lightdm/`
1. Choose a background file to use
1. Copy that file to `/usr/share/slick-greeter`
1. Change `CHOSEN_BACKGROUND_FILE` in `/etc/lightdm/slick-greeter.conf` to the
   name of the chosen file
1. Logout (the background should now appear)

Notes:
- sym links (either to `slick-greeter.conf` or to the background image file)
  don't work
- the image file must be in the `/usr/share/slick-greeter` directory or it
  doesn't work
