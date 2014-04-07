#!/bin/bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

shopt -s histappend             # manage history better
shopt -s checkwinsize           # check winsize between commands
shopt -s cdspell                # autocorrect name directory
shopt -s nocaseglob             # pathname extension insensitive

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export FIGNORE=".o:~"                                           # completion ignore
export PAGER="less -isM"                                        # man pages editor
export GREP_COLORS='mt=01;34:fn=01;34:ln=04;31:bn=30:se=33'

alias grep='grep --color=auto'
alias emacs='emacs -nw -Q'
alias ls='ls -F --color=auto --hide="*~"'
alias la='ls -a'
alias ll='ls -sh1'
alias lh='ls -sh1'
alias df='df -h'
alias du='du -h'
alias j='jobs'
alias cp='cp -v'

clean()
{
    SEARCH='.'
    if [ ${1} ]
    then
	SEARCH=${1}
    fi
    find ${SEARCH} \( -name "*~" -or -name ".*~" -or -name "*\#" -or -name "*.core" \) -exec rm -fv {} \;
}

extract () {
  if [ -f $1 ] ; then
      case $1 in
	  *.tar.bz2)   tar xvjf "$*"	;;
	  *.tar.gz)    tar xvzf "$*"	;;
	  *.bz2)       bunzip2 "$*"	;;
	  *.rar)       unrar x "$*"	;;
	  *.gz)	       gunzip "$*"	;;
	  *.tar)       tar xvf "$*"	;;
	  *.tbz2)      tar xvjf "$*"	;;
	  *.tgz)       tar xvzf "$*"	;;
	  *.zip)       unzip "$*"	;;
	  *.Z)	       uncompress "$*"	;;
	  *.7z)	       7z x "$*"	;;
	  *)	       echo "don't know how to extract '"$*"'..." ;;
      esac
  else
      echo "'$*' is not a valid file!"
  fi
}

search ()
{
    SEARCH="."
    if [ $# = 0 ]
    then
	echo -e "Usage: search PATTERN [DIRECTORY]"
    else
	if [ $# = 2 ]
	then
	    SEARCH=${2}
	fi
	grep --color=always -nI ${1} `find ${SEARCH} -type f ` |\
	grep '\'${SEARCH} |\
	grep -v '/\.' |\
	awk -F: ' {print "\033[1m\033[7;33m"$2 "\033[0;34m" "\033[3m\033[1m " $1 "\033[0;31m \033[3m\n\t" $3"\033[0;39m"}'
    fi
}

#//// show newest files
#//// http://www.commandlinefu.com/commands/view/9015/find-the-most-recently-changed-files-recursively
newest () {find . -type f -printf '%TY-%Tm-%Td %TT %p\n' | grep -v cache | grep -v ".hg" | grep -v ".git" | sort -r | less }

#//// http://www.commandlinefu.com/commands/view/7294/backup-a-file-with-a-date-time-stamp
#//// Create a simple copy of the argument file (title with date)
buf () {
    oldname=$1;
    if [ "$oldname" != "" ]; then
        datepart=$(date +%Y-%m-%d);
        firstpart=`echo $oldname | cut -d "." -f 1`;
        newname=`echo $oldname | sed s/$firstpart/$firstpart.$datepart/`;
        cp -R ${oldname} ${newname};
    fi
}


if [ "$SHELL" != "dumb" ] ; then
    LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*akefile=01;34:*.c=00;31:*.org=00;33:*.lua=00;34:*.cpp=00;31:*.cc=00;31:*.o=00;34:*.oga=00;36:*.spx=00;36:*.h=00;32:*.hh=00;32:*.hpp=00;32:';
    export LS_COLORS
fi
