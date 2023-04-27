# ~/.bashrc: executed by bash(1) for non-login shells.
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

set_window_title() {
	__git_branch=$(__git_ps1 " (%s)")
	case "$TERM" in
		xterm*|*rxvt*|st*)
			echo -ne "\033]0;$(pwd)${__git_branch}\007";;
	esac
}

set_window_title_command() {
	[ -n "$COMP_LINE" ] && return  # do nothing if completing
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return #and for $PROMPT_COMMAND

	case "$TERM" in
		xterm*|*rxvt*|st*)
			local this_command=$(history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//")
			echo -ne "\033]0;${this_command}\007";;
	esac
}

PROMPT_COMMAND=__prompt_command

__prompt_command() {
	local EXIT="$?"
	RCol='\[\e[0m\]'
	Red='\[\e[0;31m\]'
	BRed='\[\e[1;31m\]'
	Gre='\[\e[0;32m\]'
	BYel='\[\e[1;33m\]'
	BBlu='\[\e[1;34m\]'
	Pur='\[\e[0;35m\]'
	BPur='\[\e[1;35m\]'

	__git_branch=$(__git_ps1 " (%s)")
	PS1="[${BBlu}\w${BRed}${branch}${RCol}${BRed}\${__git_branch}${RCol}]\n"

	if [ $EXIT != 0 ]; then
		PS1+="[${Red}$EXIT${RCol}]"
	fi
	PS1+="$ "
}

# osc7_cwd: communicate directory changes to foot
osc7_cwd() {
    local strlen=${#PWD}
    local encoded=""
    local pos c o
    for (( pos=0; pos<strlen; pos++ )); do
        c=${PWD:$pos:1}
        case "$c" in
            [-/:_.!\'\(\)~[:alnum:]] ) o="${c}" ;;
            * ) printf -v o '%%%02X' "'${c}" ;;
        esac
        encoded+="${o}"
    done
    printf '\e]7;file://%s%s\e\\' "${HOSTNAME}" "${encoded}"
}
PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }osc7_cwd

# This changes the terminal title with the command being executed, 
#trap 'echo -e "\e]0;$BASH_COMMAND\007"' DEBUG
#PS0='$(set_window_title_command)'

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

PATH=$PATH:/usr/sbin

# set vi mode in bash
#set -o vi

# set last color scheme using dynamic-colors
#  - urxvt
#  - st (must be patched to work)
case "$TERM" in
    rxvt-*|st*)
		if [ -x "$HOME/.dynamic-colors/bin/dynamic-colors" ]; then
			$HOME/.dynamic-colors/bin/dynamic-colors init
		fi
		PATH=$PATH:$HOME/.dynamic-colors/bin/
esac

#enable DEL for st
case "$TERM" in
	st*)
		tput smkx
esac

# for termite terminal support for Shift+Ctrl+t open terminal here
#if [[ $TERM == xterm-termite ]]; then
#  source /etc/profile.d/vte-2.91.sh
#  __vte_prompt_command
#fi

update_path_openocd(){
	for ver in $(find /opt/openocd -maxdepth 1 -mindepth 1)
	do
		PATH="$PATH:$ver/bin"
	done
}

# Openocd versions
if [ -d /opt/openocd ]; then
	update_path_openocd
fi

## Go support
if command -v go > /dev/null 2>&1; then
	export GOPATH=$(go env GOPATH)
	PATH=$PATH:$GOPATH/bin
fi

# for contiki-ng
export CNG_PATH=/home/christian/docencia/RPI/contiki-ng
alias contiker="docker run --privileged --sysctl net.ipv6.conf.all.disable_ipv6=0 --mount type=bind,source=$CNG_PATH,destination=/home/user/contiki-ng -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/bus/usb:/dev/bus/usb -ti contiker/contiki-ng"

# for dotfiles management, following the strategy described in:
#    - https://wiki.tinfoil-hat.net/books/workstation-backup-via-git/page/workstation-backup-via-git
#    - https://www.atlassian.com/git/tutorials/dotfiles
alias cfg='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

function dotfiles_autoupdate {
    cfg add -u && \
	cfg commit -m "Update $(date +"%Y-%m-%d %H:%M") $(uname -s)/$(uname -m)"\
	&& cfg push
}

## node tools
if [ -d $HOME/node_modules/.bin ]; then
	PATH=$PATH:$HOME/node_modules/.bin
fi

