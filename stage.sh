#!/usr/bin/env bash

# Stage our commits for the day.

error() {
  echo -e "\e[31m E: $@\e[0m"
  exit 1
}

log() {
  if [[ ${STAGE_DEBUG} == "false" ]]; then
    return
  fi

  echo -e " + \e[35m$@\e[0m"
}

question() {
  echo -ne "\e[34m$@\e[0m"
}

examine_repo() {
  echo ""
  if [[ ! -e $1 ]]; then
    error "Module not found."
  fi

  pushd $1 >/dev/null || error "Failed to pushd into module directory...?"

  echo -e "\e[34mWorking in module '\e[31m$1\e[34m'\e[0m"

  log "git status"
  git status

  echo ""
  STATUS="$(git status | grep 'working directory clean')"

  if [[ ! "${STATUS}" == '' ]]; then
    echo -e "\e[31m E: Nothing to commit.\e[0m"
    popd >/dev/null
    return 1
  fi

  question "Is the GIT Status OK? [y/n]: "
  read -r OPT

  if [[ ! $OPT == 'y' ]]; then
    error "Git Status not OK."
  fi

  log "git add -A ."
  git add -A .

  echo ""
  question "Do we need to Commit Changes? [y/n]: "
  read -r YN

  if [[ $YN == 'y' ]]; then
    log "git --no-pager diff HEAD"
    git --no-pager diff HEAD

    echo ""
    question "Enter commit message: "
    read -r opt

    log "git commit -am '${opt}'"
    git commit -am "${opt}"
  fi


  STATUS="$(git status | grep 'HEAD detached from')"
  if [[ ! "${STATUS}" == '' ]]; then
    # TODO: Just merge to master before hand.
    log "git checkout master"
    git checkout master

    log "git merge HEAD@{1}"
    git merge HEAD@{1}
  fi


  echo ""
  question "Push Commit? [y/n]: "
  read -r FINAL_CHECK

  if [[ ! $FINAL_CHECK == 'y' ]]; then
    error "Not pushing."
  fi

  log "git push origin master"
  git push origin master

  echo -e "\e[34mFinished working in module '\e[31m$1'\e[0m"
  popd >/dev/null
}

examine_repo 'backend'
examine_repo 'ui'
