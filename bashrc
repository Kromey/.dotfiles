# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

#Add git prompt
if [ -f ~/.dotfiles/lib/git-prompt.sh ]; then
	source ~/.dotfiles/lib/git-prompt.sh
	GIT_PS1_SHOWDIRTYSTATE=true
	GIT_PS1_SHOWSTASHSTATE=true
	GIT_PS1_SHOWCOLORHINTS=true
	GIT_PS1_SHOWUNTRACKEDFILES=true
	GIT="\[\033[0;35m\]\$(__git_ps1)"
else
	GIT=
fi

#if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w$GIT\[\033[00m\]\$ "
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#Pretty colors in ls, even on Mac
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.dotfiles/lib/aliases ]; then
    . ~/.dotfiles/lib/aliases
fi

search()
{
	local DIR="$2"
	[ "$DIR" == "" ] && DIR=./;
	grep -HnR "$1" "$DIR" | grep -v '\.svn' | grep -v 'Binary file';
}

fixssh() {
	for key in SSH_AUTH_SOCK SSH_CONNECTION SSH_CLIENT; do
		if (tmux show-environment | grep "^${key}" > /dev/null); then
			value=`tmux show-environment | grep "^${key}" | sed -e "s/^[A-Z_]*=//"`
			export ${key}="${value}"
		fi
	done
}

sortfile() {
	for file in "$@"; do
		#Make a temp file for us to work with
		if [ -n `which mktemp` ]; then
			tmpfile=$(mktemp)
		else
			tmpfile="/tmp/$(basename "$1")"
		fi
		#Do this all on tempfiles to avoid clobbering the real file on a failure
		sort "$file" -o "$tmpfile" && uniq "$tmpfile" "$tmpfile.1" && mv "$tmpfile.1" "$file"
		#Clean up
		rm "$tmpfile"*
	done
}

ssh-copy-terminfo() {
    if [ "$#" -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: $0 [user@]machine" >&2
        exit 1
    fi

    FILE=ssh-copy-terminfo.tmp.ti
    infocmp | ssh $1 "cat > $FILE ; tic $FILE ; rm $FILE"
}

git-ignorelinks() {
	for f in $(git status --porcelain | grep '^??' | sed 's/^?? //'); do
		test -L "$f" && echo $f >> .gitignore;
		test -d "$f" && echo $f\* >> .gitignore;
	done
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Local .bashrc for adding extras specific to the local machine
if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi

# Source virtualenvwrapper if it exists
if [ -n `which virtualenvwrapper.sh` ]; then
	if [ -z "$WORKON_HOME" ]; then
		export WORKON_HOME=~/.venvs
	fi
	mkdir -p $WORKON_HOME 2>/dev/null || echo "WARNING: Unable to create $WORKON_HOME"
	if [ -d "$WORKON_HOME" ]; then
		source `which virtualenvwrapper.sh`
	fi
fi

# A little somethin' somethin' ;-)
GREETING='tERRGVATF, zNFGRE!'
if [ -n `which tr` ]; then
	echo $GREETING | tr a-zA-Z N-ZA-Mn-za-m
fi

