#!/usr/bin/perl

# This prints stuff _before_ a matching line
# Run using:
#     $> perl -i.bak quick_edit.pl /path/to/file/to/edit
#     (the -i.bak bit automatically creates a backup of the file before editing)

while (<>)
{
    if (m/^line to match$/i)
    {
        # Print new stuff until 'EOM' is found
        print <<'EOM';

blah blah
yada yada
blah blah

EOM
    }

    # Print the original (or unmatched) line
    print;
}
