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

## Credits

This is based on "Method 2" in https://gist.github.com/chrisroos/1205934.
