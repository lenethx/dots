# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
# append to the history file, don't overwrite it
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -f "/etc/arch-release" ]; then
    source /usr/share/git/completion/git-prompt.sh
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWDIRTYSTATE=true
fi	

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$(cat /etc/hostname)" = "leneth-deb" ]; then
    hostdata="@$(tput setaf 235)$(tput setab 15)onyx"
elif [ "$(cat /etc/hostname)" = "cybarch" ]; then
    hostdata=""
elif [ "$(cat /etc/hostname)" = "pearl" ]; then
    hostdata="@$(tput setaf 252)$(cat /etc/hostname)"
fi

# $(tput setaf 141 bold) only works on newer versions of tput annoyingly 
if [ "$color_prompt" = yes ]; then
    if true; then
        PS1='${debian_chroot:+($debian_chroot)}$(tput setaf 141)$(tput bold)\n\@ $(tput setaf 99)\u$(tput sgr0)$(tput bold)'"${hostdata:-}"'$(tput sgr0): $(tput setaf 213)$(tput bold)\w$(tput sgr0) `[[ $(git status 2> /dev/null) =~ Changes\ to\ be\ committed: ]] && echo "\[\e[38;05;216m\]" || echo "\[\e[38;05;197m\]"``[[ ! $(git status 2> /dev/null) =~ nothing\ to\ commit,\ working\ .+\ clean ]] || echo "\[\e[38;05;47m\]"`$(__git_ps1 "%s\[\e[00m\]")\[$(tput sgr0)\]\$\[$(tput bold)\]\n--> \[\e[00m\]'
    else 
        PS1='\[\033[7m\]\[\033[01;38;05;99m\] \u \[\033[0m\]\[\033[01;38;05;99;48;05;141m\]\[\033[0m\]\[\033[01;38;05;141m\]\[\033[7m\] \w \[\033[0m\]\[\033[01;38;05;141m\] \[\033[0m\]'
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt hostdata

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias la='ls -A --color=auto --hyperlink=auto'
    alias ls='ls --color=auto --hyperlink=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
fi

# colored GCC warnings and errors

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#nah the aliases go here
#alias vim='nvim'
alias nv='nvim'
alias py='python3'
alias python='python3'
alias scheme='rlwrap mit-scheme'
alias guile='rlwrap guile'
alias ranger='. ranger'
alias :wq='exit'
alias reset='tput reset'
alias git-rmignored='git ls-files -c --ignored --exclude-standard -z | xargs -0 git rm --cached'

alias lshdu='find -maxdepth 1 -mindepth 1 -print0 | xargs -0 du -sh'
alias lsdu='find -maxdepth 1 -mindepth 1 -print0 | xargs -0 du -s | sort -k1 -nr'

alias qtile-spawn='qtile cmd-obj -o root -f spawn -a'
alias qtile-reload='qtile cmd-obj -o root -f reload_config'


#alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

alias tenes='trans -s en -t es'
alias tesen='trans -s es -t en'
alias tende='trans -s en -t de'
alias tdeen='trans -s de -t en'
alias tesde='trans -s es -t de'
alias tdees='trans -s de -t es'

function ankill() { ps aux | grep anki | head -n1 | awk '{ print $2}' | xargs kill -9; }

function stproxy() {
    export http_proxy=$phoneproxy
    export https_proxy=$http_proxy
    export ftp_proxy=$http_proxy
    export rsync_proxy=$http_proxy
    export HTTP_PROXY=$proxy 
    export HTTPS_PROXY=$proxy 
    export FTP_PROXY=$proxy 
    export RSYNC_PROXY=$proxy
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
}


if [ -f "/etc/debian_version" ]; then
  alias bat='batcat'



    PATH="/home/leneth/perl5/bin${PATH:+:${PATH}}"; export PATH;
    PERL5LIB="/home/leneth/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
    PERL_LOCAL_LIB_ROOT="/home/leneth/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
    PERL_MB_OPT="--install_base \"/home/leneth/perl5\""; export PERL_MB_OPT;
    PERL_MM_OPT="INSTALL_BASE=/home/leneth/perl5"; export PERL_MM_OPT;


    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -f "/etc/arch-release" ]; then
    alias csi='rlwrap chicken-csi'
else
    alias csi='rlwrap csi'
fi	


if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

if [ -f "$HOME/.rye/env" ]; then
    . "$HOME/.rye/env"
fi

# set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes user's private ~/.cargo/bin if it exists
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

export EDITOR='nvim'
export SUDO_EDITOR='nvim'
export VISUAL='nvim'
export phoneproxy="http://192.168.49.1:8282"

ggl() {
    w3m "https://google.com/search?q=$*"
}

nvsdn() {
    cd ~/Documents/journal-vault/ && nv .
}

stty -ixon

bind "set completion-ignore-case on"
if type -P "zoxide" &>/dev/null; then
    eval "$(zoxide init bash)"
    alias su='sudo bash'
fi
