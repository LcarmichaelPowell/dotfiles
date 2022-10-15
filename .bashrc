# .bashrc

# Source global definitions
if [ -f /etc/zshrc ]; then
	. /etc/zshrc
fi
stty -ixon

source "$HOME/.exports"
source "$HOME/.functions"
source "$HOME/.aliases"

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
