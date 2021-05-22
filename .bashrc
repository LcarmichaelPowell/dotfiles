# .bashrc

# Source global definitions
if [ -f /etc/zshrc ]; then
	. /etc/zshrc
fi
stty -ixon
#Gets rid of the ugly green from shell terminal
alias ls="ls -G"
export LSCOLORS="exfxcxdxbxegedabagacad"

alias ebash='vim ~/.bashrc'
alias sbash='source ~/.bashrc'
alias etmux='vim ~/.tmux.conf'
alias evim='vim ~/.vimrc'
alias search='grep -rnw'
alias searchc='grep -rni'
alias searchg='grep -rn'
alias getpackage='a4 project branchpackage'
alias ffind='find . -iname'
alias wlog='watch -n 1 cat'
alias rback='rm -rf /var/shmem/bld/Backup/backups/*'
alias lblds='Abuildd -l | grep lcarmichaelpowell'
alias pjdiff='a pj diff | less'
alias pdiff='pjdiff'
alias wsdiffv='a ws diff -v'
alias pjdiffv='a pj diff -v'
alias getlog='ap abuild -l -p .'
alias con='a4c shell'
alias sjobs='jobs -ps'
alias summary='a4 diff --summary'
alias jkill='kill -9 `jobs -ps`'
alias lscore='ls -l /var/core/'
alias killsjobs='sudo kill -9 `sjobs`'
alias hSpace='tmux select-layout even-horizontal'
alias mattRejected='a matt show tests -s rejected | less'
alias mattStarted='a matt show tests -s started'
alias mattApproved='a matt show tests -s approved | less'
alias mattIdle='a matt show tests -s idle'
alias mattOverride='a matt show tests -s overridden | less'
alias mattInvest='a matt show tests -s investigating | less'
alias html='cd ~/public_html'
alias wsdiff='adiff'

function srun() {
   if [ $# -eq 0 ]
   then
      echo "Enter a Script Name"
      return 0;
   fi
   scriptNameFullPath="~/randomScripts/$1" 
   scriptArgs=${@:2}
   CMD="python $scriptNameFullPath $scriptArgs"
   $CMD
}

function esrc() {
   CMD="vim /src/$1"
   $CMD
}

function gdbcore() {
   if [ $# -eq 0 ]
   then
      core=$(ls -Art /var/core| tail -n 1)
   else
      core=$1
   fi

   CMD="sudo gdb python --core=/var/core/$core"
   $CMD
}

function findInSrc(){
   find . -type f -exec grep $1 /dev/null {} +
}

function creamSummary(){ 
   cat /var/memtrack/$1.cream | grep "cpp" | sed 's/.*\/\([^ ]*\.cpp\).*| [0-9\.]* [0-9\.]* \([0-9]*\).*$/\2 \1/' | sort -n -k1
}

function adiff() {
      P4DIFF="git --no-pager diff --color=always --no-index " a4 diff~ "$@" | less -R
}


function sleepShell() {
   sleep 2
   echo $1
}

function dashTest ()
{
    if [[ "$#" -lt "3" ]]; then
        echo "Usage: dashTest TEST_FILE DUT NUM_TESTS";
        return 1;
    fi;
    set -x;
    AutoTest --notify=$P4USER --skipTestbedCheck -a --logDir=/tmp/ --testListFile="$1" --algorithm=fixed -d "$2" -n "$3";
    set +x
}

function newWindow(){
   if [ -z "$1"  ]
   then
      echo "No argument supplied"
      return
   fi

   if [ -z "$2"  ]
   then
      NAME=$1
   else
      NAME=$2
   fi
   

   CMD="a4c shell $1"
   tmux rename-window $NAME
   tmux split-window -h
   tmux resize-pane -t 2 -x 90
   tmux send-keys -t 2 "$CMD" C-m

   $CMD
}

function fixSize(){
   tmux resize-pane -t 1 -x 94
   tmux resize-pane -t 2 -x 94
   tmux resize-pane -t 4 -x 94
   tmux resize-pane -t 3 -y 30
}

function pullTrace(){
   
   if [ $# -ne 2 ]
   then
      echo 'Incorrect number of args'
      return;
   fi
   CMD="rm trace.txt"
   $CMD
   CMD="TRACEFILE=trace.txt TRACE=$1 ./$2"
   $CMD
   
}

function cpkg() {
   cpkg="$(echo $(pwd) | cut -d "/" -f3) "
   echo $cpkg
}

function creamBld(){
   if [ $# -eq 0 ]
   then
      pkg=$(cpkg)
   else
      pkg=$1
   fi
   $(cbld $pkg) 
   CMD='env CREAM=1 CCACHE_DISABLE=1 a4 make -p ' 
   CMD+=$pkg 
   CMD+=' -jAUTO product'
   echo $CMD
   sleep 1
   $CMD
}
function tt(){
   TITLE=$*;
   export PROMPT_COMMAND='echo -ne "\033]0;$TITLE\007"'
}

function ccreate(){
   aName=$2
   if [ -z "$aName" ]
   then
      aName=$1
   fi
   CMD='a4c create -c lcarmichaelpowell.'$1'.0 '$aName
   echo $CMD
   sleep 3
   $CMD 
}

function cbld() {
   CMD='sudo rm -rf'
   i=0

   for arg do
      if [ $arg == 'c' ] 
      then
         dir=$(cpkg)
         size=${#dir}
         if [ "$size" -ne 1 ]
         then
            i=1
            CMD+=" /bld/$(echo $dir)"
         fi
      else
         i=1
         CMD+=" /bld/$(echo $arg)" 
      fi
   done
   
   if [ $i -eq 0 ]
   then
      # I believe that this is causing some issues. So I'm removing it until
      # I get a chance to figure out why
      #CMD+=' /bld/*'
      return;
   fi
   
   $CMD
}

function createFlame() {
   CMD='flamegraph -i '
   CMD+=$1
   CMD+='.data'
   
   $CMD

   CMD='mv '
   CMD+=$1
   CMD+='.svg /home/lcarmichaelpowell/public_html/'

   $CMD
}

ballard() {
   clear;
   start=false; curl http://menu2.danahospitality.ca/BALLARD/menu.asp 2> /dev/null | sed '/^[[:space:]]*$/d' | sed -e 's/<span class="ItemName">/\n\n/g' | sed -e 's/<span class="MenuSection">/\n\n>~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<\n/g' | sed -e 's/<[^>]*>/ /g' | while read line; do if [[ $line == *"CDATA"* ]]; then break; fi; if [[ $line == *"Daily"* ]]; then start=true; continue; fi; if [ "$start" = true ]; then if [[ $line == ">~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<" ]]; then echo -e "$(tput setaf 4)$line$(tput setaf 2)$(tput smul)"; echo ; else echo "$line$(tput sgr0)"; fi; fi; done | cat -s
}

function branched(){
   packageString=''
   packages=$(echo $(a pj setting) | awk -F"memberPackages" '{print $2}' | awk -F"[" '{print $2}' | awk -F"]" '{print $1}') 

   for i in ${packages//,/ }
   do
      # call your procedure/other scripts here below
      package=$(echo $i | awk -F"/" '{print $1}' | awk -F"'" '{print $2}') 
      packageString+=" -p $package"
   done
   echo $packageString
}

function pmake(){
   i=0

   makeCMD="a ws make"
   CMD="$makeCMD "
   TESTS="$makeCMD check TESTS="
   runTest=0
   appendTests=0
   check=0
   make=0
   packages=""

   for arg do
      
      if [ $runTest -eq 1 ]
      then
         TESTS+="$(echo $arg) "
         runTest=0
      
      elif [ "$arg" == "product" ] || [ "$arg" == "check" ] || 
           [ "$arg" == "-f" ] || [ "$arg" == "rpmbuild" ]
      then
         CMD+="$(echo $arg) "

      elif [ "$arg" == "clean" ] || [ "$arg" == "f" ] 
      then
         CMD+="-f "

      elif [ "$arg" == "rpm" ] 
      then
         CMD+="rpmbuild "

      elif [ "$arg" == "c" ] 
      then
         check=1
      elif [ "$arg" == "p" ] 
      then
         CMD+="product "

      elif [ "$arg" == "branched" ] 
      then
         CMD="$makeCMD -f $(branched)"
         echo $CMD 
         $CMD
         return

      elif [ "$arg" == "branchedc" ] 
      then
         CMD="$makeCMD -f check $(branched)"
         echo $CMD 
         $CMD
         return

      elif [ "$arg" == "branchedp" ] 
      then
         CMD="$makeCMD -f product $(branched)"
         echo $CMD 
         $CMD
         return

      elif [ "$arg" == "-t" ] || [ "$arg" == "t" ]
      then
         runTest=1
         appendTests=1
         check=1
      elif [ "$arg" == "b" ]
      then
         make=1
      else
         i=1
         packages+="-p $(echo $arg) "
      fi
   done
  
   if [ $i -eq 0 ]
   then
      packages+="-p $(echo $(pwd) | cut -d "/" -f3) "    
   fi
  
   CMD+="$(echo $packages) "

   if [ $check -eq 1 ] 
   then
      if [ $make -eq 1 ]
      then
         CMD+="&& "
      else
         CMD=''
      fi

      if [ $appendTests -eq 1 ]
      then
         CMD+="$TESTS $packages" 
      else
         CMD+="$makeCMD check $packages" 
      fi
   fi

   echo $CMD 
   $CMD
}


# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# nix configuration
if [[ $- == *i* ]]; then  # check if interactive shell
   if [ -x "$HOME/bin/nix-enter" ]; then
      if [ ! -e /nix/var/nix/profiles ] || [ -z ${NIX_ENTER+x} ]; then
         export NIX_ENTER=""
         exec "$HOME/bin/nix-enter"
      fi
   fi
fi



[ -f ~/.fzf.bash ] && source ~/.fzf.bash
