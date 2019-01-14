#!/usr/bin/env bash
set -e

GIT_REPO="https://github.com/MadAnd/dotvim.git"
INSTALL_DIR=~/.vim
VIMRC=~/.vimrc

# USAGE
#   find_executable executable-name
# DESCRIPTION
#   Find an executable, given as a first argument, in PATH
#   and assign the found path to a global variable.
# EXAMPLES
#  `find_executable git` - will set the variable GIT_CMD to e.g. '/usr/bin/git'
#  `find_executable bash` - will set the variable BASH_CMD, etc.
find_executable()
{
    if (( $# != 1 )); then
        echo 'USAGE: find_executable executable-name' >&2
        return 1
    fi

    local cmd_executable=$(which $1 2>/dev/null)

    if [ -z "$cmd_executable" ]; then
        echo "$1 not found in PATH" >&2
        return 2
    fi

    local cmd_var_name=${1^^}_CMD
    declare -g $cmd_var_name="$cmd_executable"
}


# Generate VIM_CMD
find_executable vim
# Generate GIT_CMD
find_executable git

# Backup previous vim config, or delete if they are symlinks
if [[ -h "$VIMRC" ]]; then
    rm "$VIMRC"
elif [[ -f "$VIMRC" ]]; then
    mv -f "$VIMRC" "$VIMRC".bak
fi

if [[ -h "$INSTALL_DIR" ]]; then
    rm "$INSTALL_DIR"
elif [[ -d "$INSTALL_DIR" ]]; then
    mv -f "$INSTALL_DIR" "$INSTALL_DIR".bak
fi

# Install the config
$GIT_CMD clone --recurse-submodules "$GIT_REPO" "$INSTALL_DIR"
ln -sf "$INSTALL_DIR/vimrc" "$VIMRC"

# Let Vundle install all the plugins
$VIM_CMD +PluginInstall +qall

echo 'Installation done!'
