# /etc/bash/bashrc

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

# By default, we want this to get set.
# Even for non-interactive, non-login shells.
if [ $UID -gt 99 ] && [ "`id -gn`" = "`id -un`" ]; then
    umask 002
else
    umask 022
fi

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Change the window title of X terminals 
case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
    ;;
  screen)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
    ;;
esac

use_color=true
if ${use_color} ; then
  # Enable colors for ls, etc.  Prefer ~/.dir_colors
  if type -P dircolors >/dev/null ; then
    if [ -f "~/.dir_colors" ] ; then
      eval $(dircolors -b ~/.dir_colors)
    elif [ -f "/etc/DIR_COLORS" ] ; then
      eval $(dircolors -b /etc/DIR_COLORS)
    fi
  fi

  #export LS_COLORS='di=1;34:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'

  # Set prompt
  black=$(tput setaf 0)
  red=$(tput setaf 1)
  green=$(tput setaf 2)
  yellow=$(tput setaf 3)
  blue=$(tput setaf 4)
  magenta=$(tput setaf 5)
  cyan=$(tput setaf 6)
  white=$(tput setaf 7)
  bold=$(tput bold)
  reset=$(tput sgr0)
  PS1='\[$green$bold\][\t] \[$reset$green\][\u@\h: \[$cyan$bold\]\w\[$reset$green\]]\[$reset\]\$ '

else
  if [[ ${EUID} == 0 ]] ; then
    # show root@ when we don't have colors
    PS1='\u@\h \W \$ '
  else
    # Set prompt
    green=$(tput setaf 2)
    blue=$(tput setaf 6)
    bold=$(tput bold)
    reset=$(tput sgr0)
    PS1='\[$green$bold\][\t] \[$reset$green\][\u@\h: \[$blue$bold\]\w\[$reset$green\]]\[$reset\]\$ '
  fi
fi

if ! shopt -q login_shell ; then # We're not a login shell
  # Need to redefine pathmunge, it get's undefined at the end of /etc/profile
  pathmunge () {
    if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
      if [ "$2" = "after" ] ; then
        PATH=$PATH:$1
      else
        PATH=$1:$PATH
      fi
    fi
  }

  for i in /etc/profile.d/*.sh; do
    if [ -r "$i" ]; then
      . $i
    fi
  done

  unset i
  unset pathmunge
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

# Make the time output compact
export TIMEFORMAT=$'\n[real: %lR, user: %lU, sys: %lS]\n'

# Include moogsoft specific environment variables and aliases
if [ -f ~/.moogsoft ]; then source ~/.moogsoft; fi

# Include user specific aliases
if [ -f ~/.aliases ]; then source ~/.aliases; fi

# Include utility functions
if [ -f ~/.utility_functions ]; then source ~/.utility_functions; fi

