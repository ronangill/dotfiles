echo "Loading aliases"

COLORS=""
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    COLORS=" --color=auto "
fi

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ll="ls -l -h ${COLORS}"

if [ "$(uname 2> /dev/null)" = "Darwin" ]; then
    alias ll='ls -G -l -h'
fi

alias grep="grep -i ${COLORS}"
alias ln="ln -s"
alias hs="history"
alias hgr="history | grep "
alias svim="sudo vim"
alias sbash="sudo -s"
alias sudo="sudo "
alias df='df -h -x"squashfs"'
alias du="du -shc "
alias ds="df -sh"


if [ -x /usr/bin/emerge ]; then
    alias ins="sudo eix -I "
    alias agu="sudo eix-sync "
    alias agd="sudo emerge -vuDN "
    alias agi="sudo emerge "
    alias ari="sudo emerge"
    alias agr="sudo emerge -C "
    alias agp="sudo emerge --deep-clean "
    alias acs="sudo eix "
    alias acsh="sudo eix "
else
    #apt-get aliases
    APTG="apt-get"
	APTC="apt-cache"
# 2016-04-28 : apt not working as expected so gone back to apt-get
#    if [ -x /usr/bin/apt ]; then
#        APTG="apt"
#        APTC="apt"
#    elif [ -x /usr/sbin/apt-fast ]; then
#        APTG="apt-fast"
#    fi
    alias ins="dpkg --list | grep "
    #alias agu="sudo ${APTG} update -o Acquire::http::No-Cache=True"
    alias agu="sudo ${APTG} update"
    alias agd="sudo ${APTG} dist-upgrade"
    alias agi="sudo ${APTG} install"
    alias ari="sudo ${APTG} install --reinstall"
    alias agr="sudo ${APTG} remove"
    alias agp="sudo ${APTG} purge"
    alias acs="${APTC} search"
    alias acsh="${APTC} show"
fi

alias psi='ps h -eo pmem,comm | sort -nr | head'
alias pg='ps -efww | grep -v grep | grep -i '
alias pj='ps -efww | grep -v grep | grep java'

# Maven releases'
alias mp='rm .project .classpath .settings -rf; mvn -U eclipse:eclipse -DdownloadSources=true -DdownloadJavadocs=true'
alias mbuild='mvn clean; mvn compile'
alias mprepare='mvn release:clean release:prepare -DscmCommentPrefix='\''[nojira] - RELEASE 1.0.x -'\'''
alias mrelease='mvn release:perform  -DscmCommentPrefix='\''[nojira] - RELEASE 1.0.x -'\'''
alias mtest='mvn release:clean release:prepare -DdryRun=true -DscmCommentPrefix='\''[nojira] - RELEASE 1.0.x -'\'''

# Docker
alias dps='docker ps --format "table{{.Names}}\t{{.ID}}\t{{.Image}}\t{{.Command}}"'

# git
# status of all fodlers
alias gitas='find . -type d -name .git | while read dir ; do sh -c "cd $dir/../ && echo -e \"\nGIT STATUS IN ${dir//\.git/}\" && git status -s" ; done'

#terraform
alias tf='terraform'
alias tfv='terraform validate'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfm='terraform fmt -recursive'

