#!/bin/bash

# Create a new directory and enter it
function mk() {
  mkdir -p "$@" && cd "$@" || exit
}

# Extra many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
extract() {
  if [ -f "$1" ]; then
      case "$1" in
            *.tar.bz2)  tar -jxvf "$1"                        ;;
            *.tar.gz)   tar -zxvf "$1"                        ;;
            *.bz2)      bunzip2 "$1"                          ;;
            *.dmg)      hdiutil mount "$1"                    ;;
            *.gz)       gunzip "$1"                           ;;
            *.tar)      tar -xvf "$1"                         ;;
            *.tbz2)     tar -jxvf "$1"                        ;;
            *.tgz)      tar -zxvf "$1"                        ;;
            *.zip)      unzip "$1"                            ;;
            *.ZIP)      unzip "$1"                            ;;
            *.pax)      cat "$1" | pax -r                     ;;
            *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
            *.Z)        uncompress "$1"                       ;;
            *) echo "'$1' cannot be extracted/mounted via extract()" ;;
            esac
         else
           echo "'$1' is not a valid file to extract"
   fi
}

# `ls` after `cd`
function cd {
	builtin cd "$@" && ls -F
}

function vpn_check {
  curl https://am.i.mullvad.net/connected && curl https://am.i.mullvad.net/country
}

function bitbake {
  command bitbake "$@"

	if [[ $? -eq 0 ]]; then
		paplay /usr/share/sounds/freedesktop/stereo/dialog-information.oga 2>/dev/null &
	else
		paplay /usr/share/sounds/freedesktop/stereo/dialog-error.oga 2>/dev/null &
	fi
}
