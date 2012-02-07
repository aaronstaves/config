alias ls='ls -G'

        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"
 
 
function parse_git_branch {
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^# On branch ([^${IFS}]*)"
  detached_branch_pattern="# Not currently on any branch"
  remote_pattern="# Your branch is (.*) of"
  diverge_pattern="# Your branch and (.*) have diverged"
  untracked_pattern="# Untracked files:"
  new_pattern="new file:"
  if [[ ${git_status}} =~ "Changes not staged for commit" ]]; then
    state="${RED}⚡"
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${YELLOW}↑"
    else
      remote="${YELLOW}↓"
    fi
  fi
  if [[ ${git_status} =~ ${new_pattern} ]]; then
    remote="${GREEN}+"
  fi
  if [[ ${git_status} =~ ${untracked_pattern} ]]; then
    remote="${YELLOW}?"
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}↕"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  elif [[ ${git_status} =~ ${detached_branch_pattern} ]]; then
    branch="${YELLOW}NO BRANCH"
  fi
 
  if [[ ${#state} -gt "0" || ${#remote} -gt "0" ]]; then
    s=""
  fi
 
  echo " (${branch}${s}${remote}${state}${YELLOW})"
}
 
function prompt_func() {
  git rev-parse --git-dir > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    prompt="${GREEN}\h${YELLOW}:/${PWD##*/}$(parse_git_branch)${COLOR_NONE} "
    PS1="${prompt}"
  else
    PS1="${GREEN}\h${YELLOW}:${PWD##*/}${COLOR_NONE} "
  fi
}
 
export PSAVE=$PS1
 
PROMPT_COMMAND=prompt_func
