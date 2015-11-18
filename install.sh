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
DIR=~/.dotfiles/home
#Directory to back up existing dotfiles
OLDDIR=~/.dotfiles/old
##
# End Config
##

#First create our backup directory, if it doesn't exist
if [ ! -d $OLDDIR ]
then
	mkdir -p $OLDDIR
fi

#Iterate through each of our dotfiles
for FILE in $(ls $DIR); do
	#Skip any non-files (e.g. . and ..)
	if [ -f $DIR/$FILE ]
	then
		#If we don't already have a (valid) link, make one
		if [ ! -L ~/.$FILE -o ! -e ~/.$FILE ]
		then
			#Back up the existing file, if present
			if [ -f ~/.$FILE ]
			then
				mv ~/.$FILE $OLDDIR/$FILE
			fi
			#Clean up anything that might be in the way
			rm -f ~/.$FILE
			#Now make the actual symlink
			ln -s $DIR/$FILE ~/.$FILE
		fi
	fi
done

