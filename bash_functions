#!/bin/bash

echo "Loading functions"

list () {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar tjf "$1"        ;;
      *.tar.gz)    tar tzf "$1"     ;;
      *.bz2)       bunzip2 -t "$1"       ;;
      *.rar)       rar l "$1"     ;;
      *.gz)        gunzip "$1"     ;;
      *.tar)       tar tf "$1"        ;;
      *.tbz2)      tar tjf "$1"      ;;
      *.tgz)       tar tzf "$1"       ;;
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
      *.tar.bz2)   tar xjf "$1"        ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"       ;;
      *.rar)       rar x "$1"     ;;
      *.gz)        gunzip "$1"     ;;
      *.tar)       tar xf "$1"        ;;
      *.tbz2)      tar xjf "$1"      ;;
      *.tgz)       tar xzf "$1"       ;;
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

dbuild (){

  if [ ! -e Dockerfile ]; then
    echo "Dockerfile not found - nothing to run"
    exit 1
  fi

  # add paramter "--full" to get a clean build
  if [ "--fulls" == "$1s" ]; then
    OPTS="--no-cache=true --force-rm=true"
  fi

  DOCKER_TAG="docker.gillsoft.org/$(basename ${PWD})"

  echo "Building ${DOCKER_TAG}"
  docker build ${OPTS} -t "${DOCKER_TAG}" .

}

dpush (){

  if [ ! -e Dockerfile ]; then
    echo "Dockerfile not found - nothing to run"
    exit 1
  fi

  DOCKER_TAG="docker.gillsoft.org/$(basename ${PWD})"

  docker push "${DOCKER_TAG}"

}

drun (){

  if [ ! -e Dockerfile ]; then
    echo "Dockerfile not found - nothing to run"
    exit 1
  fi

  DOCKER_TAG="docker.gillsoft.org/$(basename ${PWD})"

  docker run  -t -i "$@" "${DOCKER_TAG}"

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
