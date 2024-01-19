#!/bin/bash

unalias -a

# Directory shortcuts
alias dev='cd ~/Documents/github'
alias dl="cd ~/Downloads"

# Get week number
alias week='date +%V'

# Color extended ls
alias ls='ls --color=auto'

# NeoVim as Vim
alias vim=nvim

# Git
alias gis='git status'
alias gia='git add '
alias gica='git commit --amend'
alias gid='git diff '
alias gico='git checkout '

# Quick start for idf env
alias get_idf='. $HOME/esp/esp-idf/export.sh'

