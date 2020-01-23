# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

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
    xterm-color|*-256color|xterm-termite) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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


source ~/.git-prompt.sh

RCol='\[\e[0m\]'
Red='\[\e[0;31m\]'
BRed='\[\e[1;31m\]'
Gre='\[\e[0;32m\]'
BYel='\[\e[1;33m\]'
BBlu='\[\e[1;34m\]'
Pur='\[\e[0;35m\]'
BPur='\[\e[1;35m\]'

set_window_title() {
	__git_branch=$(__git_ps1 " (%s)")
	case "$TERM" in
		xterm*|*rxvt*)
			echo -ne "\033]0;$(pwd)${__git_branch}\007";;
	esac
}
PROMPT_COMMAND=set_window_title
#PS1="[${BBlu}\w${BRed}${branch}${RCol}${Red}\$(__git_ps1 \" (%s)\")${RCol}]\n$ "
PS1="[${BBlu}\w${BRed}${branch}${RCol}${Red}\${__git_branch}${RCol}]\n$ "


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
alias la='ls -A'
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

# Using nvim as default editor
export EDITOR=vim
#export VISUAL=nvim
#export EDITOR=nvim
#alias vim=nvim
#alias vi=nvim

# Use less as default pager
export PAGER=less

# set vi mode in bash
#set -o vi

# set last scheme using dynamic-colors extension on urxvt
case "$TERM" in
    rxvt-*)
		if [ -x "$HOME/.dynamic-colors/bin/dynamic-colors" ]; then
			$HOME/.dynamic-colors/bin/dynamic-colors init
		fi
		export PATH=$PATH:$HOME/.dynamic-colors/bin/
		#set TERMCMD
		export TERMCMD=urxvt;;
esac

# for termite terminal support for Shift+Ctrl+t open terminal here
#if [[ $TERM == xterm-termite ]]; then
#  source /etc/profile.d/vte-2.91.sh
#  __vte_prompt_command
#fi

## Python stuff
# include the bin path for pip installed scripts to PATH
export PY_USER_BIN=$(python -c 'import site; print(site.USER_BASE + "/bin")')
export PATH=$PY_USER_BIN:$PATH

## For anaconda
source /home/christian/anaconda3/etc/profile.d/conda.sh

## Go support

if command -v go > /dev/null 2>&1; then
	export GOPATH=$(go env GOPATH)
	export PATH=$PATH:$GOPATH
fi
