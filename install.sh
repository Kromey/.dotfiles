#!/bin/bash
###########
# install.sh
# This script will iterate through the files in
# the dotfiles directory and create symlinks to
# them in the user's home directory. If a dotfile
# already exists it will be backed up before the
# link is made.
###########

##
# Configuration
##
#Directory to find your dotfiles
DIR=~/.dotfiles
#Directory to back up existing dotfiles
OLDDIR=~/.dotfiles/old
##
# End Config
##

#Find this script's name so we don't link it
SELF=$(basename $0)

#First create our backup directory, if it doesn't exist
if [ ! -d $OLDDIR ]
then
		mkdir -p $OLDDIR
fi

#Iterate through each of our dotfiles
for FILE in $(ls $DIR); do
		#Skip this script, and any non-files in here
		if [ "$SELF" != "$FILE" -a -f $DIR/$FILE ]
		then
				#If we don't already have a link, make one
				if [ ! -L ~/.$FILE ]
				then
						#Back up the existing file, if present
						if [ -f ~/.$FILE ]
						then
								mv ~/.$FILE $OLDDIR/$FILE
						fi
						#Now make the actual symlink
						ln -s $DIR/$FILE ~/.$FILE
				fi
		fi
done

