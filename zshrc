# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


#export TERM="xterm-256color"
export SHELL_TYPE="zsh"
echo "Loading ZSH"

echo "Loading Antigen"

POWERLEVEL9K_VCS_HIDE_TAGS=true
POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv aws tf_prompt_info context dir_writable dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_SHORTEN_DIR_LENGTH="2"
POWERLEVEL9K_PROMPT_ON_NEWLINE="true"
POWERLEVEL9K_TIME_FORMAT="%D{\uf017 %H:%M \uf073 %d.%m.%y}"

source /usr/share/zsh-antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle z
antigen bundle thefuck
antigen bundle colored-man-pages
antigen bundle docker-compose
antigen bundle git
antigen bundle git-extras
# antigen bundle heroku
antigen bundle pip
antigen bundle djui/alias-tips
# antigen bundle lein
antigen bundle command-not-found
antigen bundle wd
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle httpie
antigen bundle colored-man-pages
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-history-substring-search
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle docker-compose
antigen bundle aws
antigen bundle lukechilds/zsh-nvm
antigen bundle terraform

antigen theme bhilburn/powerlevel9k powerlevel9k

antigen apply

echo "Loading bashrc"

BASH_DIR="${HOME}/dotfiles"

if [ -f ${HOME}/.bash_custom ]; then
    . ${HOME}/.bash_custom
fi

if [ -f ${BASH_DIR}/bash_histctrl ]; then
    . ${BASH_DIR}/bash_histctrl
fi

if [ -f ${BASH_DIR}/bash_exports ]; then
    . ${BASH_DIR}/bash_exports
fi

# if [ -f ${BASH_DIR}/bash_completion ]; then
#     . ${BASH_DIR}/bash_completion
# fi

if [ -f ${BASH_DIR}/bash_aliases ]; then
    . ${BASH_DIR}/bash_aliases
fi

if [ -f ${BASH_DIR}/bash_functions ]; then
    . ${BASH_DIR}/bash_functions
fi


test -r $HOME/.dircolors  && eval $( dircolors -b $HOME/.dircolors )


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line

setopt inc_append_history
setopt share_history
setopt rm_star_silent

eval $(thefuck --alias)

if [[ "$TERM" == "screen"* ]]; then
    echo "In screen - setting DISABLE_AUTO_TITLE=\"true\" "
   export DISABLE_AUTO_TITLE="true"
fi

if [[ "$(readlink -f ${PWD})" == "$(readlink -f ${HOME}/src)/"* ]] && [ -f ${PWD}/../.zshrc_local ]; then
    echo "Loading .zshrc from folder one up"
    . ${PWD}/../.zshrc_local
fi

if [ -f ${PWD}/.zshrc_local ]; then
    echo "Loading .zshrc from current folder"
    . ${PWD}/.zshrc_local
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/rgill/.sdkman"
[[ -s "/home/rgill/.sdkman/bin/sdkman-init.sh" ]] && source "/home/rgill/.sdkman/bin/sdkman-init.sh"
export PATH="$HOME/.local/bin:$PATH"
