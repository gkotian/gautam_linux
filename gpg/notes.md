## Steps to backup a GPG key

1. Get the ID of the key to backup.
   ```
   ➜ gpg --list-secret-keys --keyid-format=long
   ```
1. Run `make backup`.

## Steps after restoring a backed-up GPG key

1. Check whether the restored key exists.
   ```
   ➜ gpg --list-secret-keys --keyid-format LONG
   ```
1. If it says "unknown" in the "uid" line, try the following.
   ```
   ➜ gpg --edit-key <key-id>
   gpg> trust
   Your decision? 5 (Ultimate trust)
   gpg> save
   ```

## Steps to extend the expiration date of a GPG key

1. Get the ID of the key.
   ```
   ➜ gpg --list-secret-keys --keyid-format=long
   ```
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

## Credits

This is based on "Method 2" in https://gist.github.com/chrisroos/1205934.
