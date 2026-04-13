#!/bin/bash
# System-wide bash prompt configuration for ybarojs-debian
# This file is sourced by /etc/profile for all users
# Sets a colored prompt with username, hostname, working directory, and exit code

export PS1='\[\e[1;32m\]\u@\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\] [\[\e[1;33m\]$?\[\e[m\]]\$ '
