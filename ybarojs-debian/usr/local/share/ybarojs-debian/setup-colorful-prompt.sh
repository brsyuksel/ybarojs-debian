#!/bin/sh
# Colorful Bash Prompt Setup Script for ybarojs-debian
# Source this file to add the colorful prompt to your current session
# Or add it to your ~/.bashrc for permanent use

# Check if already in .bashrc to avoid duplicates
if ! grep -q "ybarojs-debian colored prompt" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc << 'EOF'

# ybarojs-debian colored prompt
export PS1="\[\e[1;32m\]\u@\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\] [\[\e[1;33m\]\$?\[\e[m\]]\$ "
EOF
    echo "Colorful prompt added to ~/.bashrc"
    echo "Run 'source ~/.bashrc' to apply changes to current session"
else
    echo "Colorful prompt already configured in ~/.bashrc"
fi
