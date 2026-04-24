#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export PATH=$PATH:/home/unnamed/.spicetify
export PATH=$PATH:~/.spicetify

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/unnamed/.lmstudio/bin"
# End of LM Studio CLI section

