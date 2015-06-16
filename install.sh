#!/usr/bin/env bash
set -e

GIT_REPO="https://github.com/MadAnd/dotvim.git"
INSTALL_PATH=~/.vim
VIMRC=~/.vimrc

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

# backup previous vim config, or remove symlinks
if [[ -h "$VIMRC" ]]; then
    rm "$VIMRC"
elif [[ -f "$VIMRC" ]]; then
    mv -f "$VIMRC" "$VIMRC".bak
fi

if [[ -h "$INSTALL_PATH" ]]; then
    rm "$INSTALL_PATH"
elif [[ -d "$INSTALL_PATH" ]]; then
    mv -f "$INSTALL_PATH" "$INSTALL_PATH".bak
fi


# install new config
$GIT_CMD clone --recursive "$GIT_REPO" "$INSTALL_PATH"
ln -sf "$INSTALL_PATH/vimrc" "$VIMRC"

# housekeeping
rm "$INSTALL_PATH/install.sh"

# let Vundle install all other plugins
$VIM_CMD +PluginInstall +qall

echo 'Installation done!'
