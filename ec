#!/bin/bash

# Taken from: mjwall.com/blog/2013/10/04/how-i-use-emacs/
# Git-Repo: https://github.com/mjwall/dotfiles

# This script starts the emacs daemon if it is not running, opens whatever file you pass in and changes the focus to emacs.
# Without any arguments, it just opens the current buffer or *scratch* if nothing else is open. The following example will open ~/.bashrc

# ec ~/.bashrc

# You can also pass it multiple files, it will open them all. Unbury-buffer will cycle through thos files in order

# The compliment to this script it et, which opens emacs in the terminal attached to a daemon,

# If you want to execute elisp, pass in -e whatever.
# You may also want to stop the output from returning to the terminal, like ec -e "(message \"Hello\")" > /dev/null

# emacsclient options for reference:
# -a "" start emacs daemon and reattaches
# -c creates a new frame
# -n returns control back to the terminal
# -e eval given script


# Number of current visible frames
# Emacs daemon always has a visible frame called F1
visible_frames() {
    emacsclient -a "" -e '(length (visible-frame-list))'
}

change_focus() {
    emacsclient -n -e "(select-frame-set-input-focus (selected-frame))" > /dev/null
}

# Try switching to the frame in case it is just minimized, will start a server if not running
test "$(visible_frames)" -eq "1" && change_focus

if [ "$(visible_frames)" -lt "2" ]; then #need to create a frame
    # -c $@ with no args just opens the scratch buffer
    emacsclient -n -c "$@" && change_focus
else # there is already a visible frame besides the daemon, so
    change_focus
    # -n $@ errors if there are no args
    test "$#" -ne "0" && emacsclient -n "$@"
fi