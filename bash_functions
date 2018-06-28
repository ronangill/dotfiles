#!/bin/bash

echo "Loading functions"

list () {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar tf "$1"        ;;
      *.tar.gz)    tar tf "$1"     ;;
      *.tar.xz)    tar tf "$1"     ;;
      *.bz2)       bunzip2 -t "$1"       ;;
      *.rar)       rar l "$1"     ;;
      *.gz)        gunzip "$1"     ;;
      *.tar)       tar tf "$1"        ;;
      *.tbz2)      tar tf "$1"      ;;
      *.tgz)       tar tf "$1"       ;;
      *.war)       unzip -l "$1"     ;;
      *.zip)       unzip -l "$1"     ;;
      *.Z)         uncompress -l "$1"  ;;
      *.7z)        7z l "$1"    ;;
      *.jar)       jar -tf "$1"    ;;
      *)           echo "'$1' cannot be listed via list()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


extract () {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xf "$1"        ;;
      *.tar.gz)    tar xf "$1"     ;;
      *.tar.xz)    tar xf "$1"     ;;
      *.bz2)       bunzip2 "$1"       ;;
      *.rar)       rar x "$1"     ;;
      *.gz)        gunzip "$1"     ;;
      *.tar)       tar xf "$1"        ;;
      *.tbz2)      tar xf "$1"      ;;
      *.tgz)       tar xf "$1"       ;;
      *.war)       unzip "$1"     ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"    ;;
      *.jar)       jar -xf "$1"    ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

archive () {
  if [ -e "$1" ] ; then
    tarName="$(date +%F)-$(basename $1).tar.gz"
    i=1
    while [ -e "$tarName" ]
    do
      tarName="$(date +%F)-$1-$i.tar.gz"
      i=$[$i+1]
    done
    echo "tar -czf $tarName $1"
    tar -czf "$tarName" "$1"
  else
    echo "'$1' is not a valid file"
  fi
}


used (){
  if [ -z $1 ]; then
    path="* .[a-zA-Z0-9_]*"
  else
    path="$1/* $1/.[a-zA-Z0-9_]*"
  fi
  du -xsk $path  | \
  sort -n | \
  awk '{s=$1; $1="";printf "%8.1f MB %8.1f GB %s \n", s/1024, s/1024/1024, $0}'

}

fn (){
  find . -iname $@ -print;
}

fngrep (){
  find . -iname $1 -exec grep -iH '{}' $2;
}

dgettag (){
  echo "$(basename $(dirname $(pwd)))/$(basename $(pwd))"
}

dbuild (){

  if [ ! -e Dockerfile ]; then
    echo "Dockerfile not found - nothing to run"
    exit 1
  fi

  # add paramter "--full" to get a clean build
  if [ "--fulls" == "$1s" ]; then
    OPTS="--compress --no-cache=true --force-rm=true"
  fi

  if [  ! -z "${http_proxy}" ]; then
    OPTS="${OPTS} --build-arg https_proxy=${http_proxy} --build-arg http_proxy=${http_proxy}"
    OPTS="${OPTS} --build-arg HTTP_PROXY=${http_proxy} --build-arg HTTPS_PROXY=${http_proxy}"
  fi

  DOCKER_TAG="$(basename $(dirname $(pwd)))/$(basename $(pwd))"

  echo "Building ${DOCKER_TAG}"
  docker build ${OPTS} -t "${DOCKER_TAG}" .
  if [  $? -eq 0  ] ; then
    echo "Built ${DOCKER_TAG}"
  fi

}

dpush (){

  if [ ! -e Dockerfile ]; then
    echo "Dockerfile not found - nothing to run"
    exit 1
  fi

  DOCKER_TAG="$(basename $(dirname $(pwd)))/$(basename $(pwd))"

  docker push "${DOCKER_TAG}"
  docker push "${DOCKER_TAG}:latest"

}

drun (){

  if [ ! -e Dockerfile ]; then
    echo "Dockerfile not found - nothing to run"
    exit 1
  fi

  DOCKER_TAG="$(basename $(dirname $(pwd)))/$(basename $(pwd))"

  docker run  -t -i "$@" "${DOCKER_TAG}"

}

drunbash (){

  if [ ! -e Dockerfile ]; then
    echo "Dockerfile not found - nothing to run"
    exit 1
  fi

  DOCKER_TAG="$(basename $(dirname $(pwd)))/$(basename $(pwd))"

  docker run  -t -i "$@" "${DOCKER_TAG}" /bin/bash

}

dgetip() {
  if [ -z "$1" ] ; then
    docker ps | tail -n +2 | awk '{print $1}' | xargs docker inspect --format '{{ .NetworkSettings.IPAddress }}'
  else
    docker ps | grep "$1" | awk '{print $1}' | xargs docker inspect --format '{{ .NetworkSettings.IPAddress }}'
  fi
}

denter (){

  if [ -z "$1" ]; then
    echo "No doccker name supplied"
    exit 1
  fi

  docker exec -t -i $(docker ps | grep "$1" | awk '{print $1}') /bin/bash

}

dip() {
  boot2docker ip 2> /dev/null
}

vbip(){
  for vm in $(VBoxManage list runningvms | awk -F '"' '{print $2}'); do 
    echo "VM: $vm, IP: $(\
      VBoxManage guestproperty enumerate $vm | \
      grep "V4/IP"| \
      grep 192 | \
      cut -f2 -d, | \
      cut -f2 -d: \
      )"; 
  done
}

vbls(){
  VBoxManage list vms
}

vbup(){
  if [ -z "$1" ]; then
    echo "No virtualbox name supplied"
    exit 1
  fi
  
  VBoxManage startvm "$1"  --type headless
}

parse_git_branch () {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
