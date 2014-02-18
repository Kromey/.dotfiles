dotfiles
========

My personal dotfiles, and a handy script to install them for easy maintenance.

Usage
-----

Simply clone this repo into your home directory, and then execute
```bash
~/dotfiles/install.sh
```

The script will create symlinks from your home directory to the respective files inside
the dotfiles repository. Fork this repository, then either update my dotfiles and/or add
update yours into it, and always have your personalized configurations handy!

The script will detect files that have already been linked, and ignore them. (Note: This
also means it will ignore any dotfiles you may have linked to somewhere else!) Otherwise,
your existing dotfiles will be stashed in `~/dotfiles_old/`, so nothing is lost!
