source /usr/share/zsh/share/antigen.zsh
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_KUBECTL_SHOW=true
SPACESHIP_KUBECTL_VERSION_SHOW=false
SPACESHIP_KUBECONTEXT_NAMESPACE_SHOW=false
SPACESHIP_KUBECTL_SYMBOL="☸️ "

ZSH_DOTENV_PROMPT=false

antigen bundle git
antigen bundle kubectl
antigen bundle sudo
antigen bundle docker
antigen bundle docker-compose
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle bundler
antigen bundle dotenv
# antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle asdf

# Antigen (plugin) stuff
antigen use oh-my-zsh

antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship

antigen bundle lukechilds/zsh-better-npm-completion

antigen apply

unsetopt share_history

source ~/.profile
