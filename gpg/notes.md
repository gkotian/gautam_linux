## Steps to backup a GPG key

1. List all locally available GPG keys.
   ```
   ➜ make list
   ```
1. Make note of the ID of the key to be backed up.
1. Run `make backup` and pass the ID of the key to be backed up.

## Steps to restore a backed-up GPG key

1. Run `make restore` and pass it the full path of the directory from which the
   key needs to be restored.
1. Check whether the restored key exists.
   ```
   ➜ make list
   ```
1. If it says "unknown" in the "uid" line, try the following.
   ```
   ➜ gpg --edit-key <key-id>
   gpg> trust
   Your decision? 5 (Ultimate trust)
   gpg> save
   ```

## Steps to extend the expiration date of a GPG key

1. List all locally available GPG keys.
   ```
   ➜ make list
   ```
1. Make note of the ID of the key whose expiration date needs to be extended.
1. Open the GPG key editing interface.
   ```
   ➜ gpg --edit-key <key-id>
   ```
1. Do the following within the GPG key editing interface.
   ```
   gpg> key 0
   gpg> expire
   Key is valid for? (0) YYYY-12-31 # Set YYYY to next year
   Is this correct? (y/N) y

       # Repeat the above for key 1, key 2 and so on until all sub keys are done

   gpg> save
   ```
1. Follow the steps in the `Steps to backup a GPG key` section and then save the
   directory containing the newly backed-up files in a secure location.
1. Also copy the directory containing the newly backed-up files to all other
   devices where this GPG key is used and run the steps in the `Steps to restore
   a backed-up GPG key` section.

## Credits

This is based on "Method 2" in https://gist.github.com/chrisroos/1205934.
