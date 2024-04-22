#!/bin/bash

target_window="minicom"
target_window_index=$(tmux list-windows | awk -v tw="$target_window" '$2 == tw {gsub(/[^0-9]/,"",$1); print $1}') 

tmux new-window -a -t "$((target_window_index-1))"

