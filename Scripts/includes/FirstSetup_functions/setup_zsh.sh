#!/bin/sh

function setup_zsh()
{

    cbecho "Changing shells to zsh"
    cecho "Changing user shell"
    chsh -s /usr/bin/zsh

    # change roots as well
    cecho "Changing root shell"
    sudo chsh -s /usr/bin/zsh

   cecho "Setting root to use user zsh config"

    echo "export ZSH_CONFIG=\"$HOME/.zsh-config\"
echo -e \"\e[36mHit \\\"y\\\" to accept the warning\e[39m\"
source $HOME/.zsh-config/zshrc.zshrc" | sudo tee /root/.zshrc >/dev/null

    echo "source $HOME/.zprofile" | sudo tee /root/.zprofile >/dev/null
}