source /usr/share/zsh/share/antigen.zsh
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_KUBECTL_SHOW=true
SPACESHIP_KUBECTL_VERSION_SHOW=false
SPACESHIP_KUBECONTEXT_NAMESPACE_SHOW=false
SPACESHIP_KUBECTL_SYMBOL="☸️ "
SPACESHIP_DIR_TRUNC=5


ZSH_DOTENV_PROMPT=false

# Antigen (plugin) stuff
antigen bundle archlinux
antigen bundle asdf
antigen bundle autojump
antigen bundle bundler
antigen bundle copyfile
antigen bundle docker
antigen bundle docker-compose
antigen bundle dotenv
antigen bundle extract
antigen bundle git
antigen bundle golang
antigen bundle kubectl
antigen bundle sudo
antigen bundle yarn
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen use oh-my-zsh

antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship

antigen bundle lukechilds/zsh-better-npm-completion

antigen apply

unsetopt share_history

source ~/.profile
