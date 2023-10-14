# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

export EDITOR=vim
export GO111MODULE=on
if type go > /dev/null
then
  export GOPATH=$(go env GOPATH)
else
  export GOPATH=""
fi
export GOPROXY=https://goproxy.io
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export KEYTIMEOUT=1
export LANG=en_US.UTF-8
export PYENV_ROOT="$HOME/.pyenv"
export PYTHONUSERBASE="$HOME/.local"
export ZSH=~/.oh-my-zsh
# export all_proxy=http://127.0.0.1:1080
# export http_proxy=http://127.0.0.1:1080
# export https_proxy=http://127.0.0.1:1080

export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH
export PATH=$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/opt/llvm/bin:$PATH
export PATH=/usr/local/sbin:$PATH

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
alias cnpx="ELECTRON_MIRROR='https://npm.taobao.org/mirrors/electron/' npx --registry=https://registry.npm.taobao.org"
alias cnvm="NVM_NODEJS_ORG_MIRROR='https://npm.taobao.org/mirrors/node/' nvm"
alias lg="lazygit"
alias gpme='git push --set-upstream me $(git_current_branch)'
alias p4="proxychains4"
alias p="pnpm"
alias pw="pnpm --filter"
alias px="pnpx"
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

v() {
  local file
  if which rg >/dev/null; then
    file="$(rg --hidden --files $@ | fzf)"
  elif which fd >/dev/null; then
    file="$(fd --hidden "" $@ | fzf)"
  elif which fdfind >/dev/null; then
    file="$(fdfind --hidden "" $@ | fzf)"
  else
    echo Plesase install fd or rg
  fi
  if [[ -n $file ]]; then
    vim $file
  fi
}

vg() {
  local file
  local line
  if which rg >/dev/null; then
    read -r file line <<<"$(rg --hidden --line-number --no-heading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"
  elif which ag >/dev/null; then
    read -r file line <<<"$(ag --hidden --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"
  else
    echo Plesase install ag or rg
  fi
  if [[ -n $file ]]; then
    vim $file +$line
  fi
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -r ~/.zshrc.local.zsh ]]; then
  source ~/.zshrc.local.zsh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
