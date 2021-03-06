ZSH_THEME="robbyrussell"

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
export PATH="$GOPATH/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/local/opt/llvm/bin:$PATH"
export PYTHONUSERBASE="$HOME/.local"
export ZSH=~/.oh-my-zsh
# export http_proxy=http://127.0.0.1:1081
# export https_proxy=http://127.0.0.1:1081

plugins+=(colored-man-pages)
plugins+=(docker-compose)
plugins+=(fasd)
plugins+=(history-substring-search)
plugins+=(kubectl)
plugins+=(git)
plugins+=(git-flow-avh)
plugins+=(nvm)
plugins+=(tmux)
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
