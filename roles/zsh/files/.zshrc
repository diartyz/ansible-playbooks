# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

export EDITOR="vim"
export GO111MODULE=on
if type go > /dev/null
then
  export GOPATH=$(go env GOPATH)
else
  export GOPATH=""
fi
export GOPROXY=https://goproxy.io
export KEYTIMEOUT=1
export LANG=en_US.UTF-8
export PATH="$PYENV_ROOT/shims:$GOPATH/bin:$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/local/opt/llvm/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PYTHONUSERBASE="$HOME/.local"
export ZSH=~/.oh-my-zsh
# export http_proxy=http://127.0.0.1:1080
# export https_proxy=http://127.0.0.1:1080
# export all_proxy=socks5://127.0.0.1:1080

if which pyenv > /dev/null;
  then eval "$(pyenv init --path)";
fi

plugins+=(colored-man-pages)
plugins+=(docker-compose)
plugins+=(git)
plugins+=(git-flow-avh)
plugins+=(history-substring-search)
plugins+=(kubectl)
plugins+=(nvm)
plugins+=(tmux)
plugins+=(vi-mode)
plugins+=(zoxide)
plugins+=(zsh-autosuggestions)
plugins+=(zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias cnpm="ELECTRON_MIRROR='https://npm.taobao.org/mirrors/electron/' npm --registry=https://registry.npm.taobao.org"
alias cnvm="NVM_NODEJS_ORG_MIRROR='https://npm.taobao.org/mirrors/node/' nvm"
alias lg="lazygit"
alias p4="proxychains4"
alias sclip='scrot -s ~/temp.png && xclip -sel clip -t image/png ~/temp.png && rm ~/temp.png'
alias vi="nvim"

fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
