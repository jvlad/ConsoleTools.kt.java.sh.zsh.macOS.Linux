#!/usr/bin/env zsh
thisFolder="$ConsoleTools/src/main/applications/git/Main.sh"

#!/usr/bin/env zsh

alias gitPullSubmodules="git submodule update --init --recursive"
alias gs="git status"
alias gc='gitCommitVerbose'
alias gcm="git commit -m"
alias gca='git commit --amend'
alias gl="git log"
alias glc="gitLogToConsole:NumberOfCommits"
alias glcc="gitCopyLastCommitInfoToClipboard"
alias gll="git log --graph --decorate"
alias gre="git reset HEAD . && git status"
alias grs="git reset HEAD"
alias gu="git pull"
alias gpo="git push origin"
alias gruop="git remote update origin --prune"
alias gitShowOrigin="git config --get remote.origin.url"
alias gmtest="gitMergeButNoCommit:SourceBranch "
alias gitGetLastCommitThatTouches:File="gitGet:LimitedNumberOfCommitsTouches:File 1"
alias gitConfigZvladNameGlobally="git config --global user.name \"${userPublicName}"\"
alias gitConfigEditor="git config --global core.editor '$VISUAL -n'"

gitConfigToZvladPersonal(){
    gitConfigZvladNameGlobally
    git config user.email \"v.zamskoi@gmail.com\"
    gitConfigPrintCurrent
}

gitConfigPrintCurrent(){
    git config user.name
    git config user.email
}

gitGet:LimitedNumberOfCommitsTouches:File(){
    git rev-list -n "$1" HEAD -- "$2"
}

gitLogToConsole:NumberOfCommits(){
  if [[ "$1" != "" ]]; then
    gitLogExtract=$(git log -"$1" | cat)
  else
    gitLogExtract=$(git log | cat)
  fi
  print "$gitLogExtract"
}

gitCopyLastCommitInfoToClipboard(){
  gitLogToConsole:NumberOfCommits 1 | pbcopy
  printSuccess:AddingMessage "Last commit info copied to clipboard"
}

gitCopyCurrentBranchNameToClipboard(){
  print $(git_current_branch) | pbcopy
}

#**
# Arguments: 
# $1 --- branch to sync with
#
gitSyncWithBranch(){
  if [[ "$1" != "" ]]; then
    git checkout "$1" &&\
    git pull origin $(git_current_branch) &&\
    git checkout - &&\
    git merge "$1" &&\

    printSuccess:AddingMessage "You have just synced with branch '$1' and have been returned to branch '$(git_current_branch)'"
  else
    print "Fail: you didn't provided a name of branch you want to sync with."
  fi
}

gitCommitVerbose(){
  print "Last 5 commits: "
  gitLogToConsole:NumberOfCommits 5
  
  print "\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\n"
  print "Git status: "
  git status

  print "\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\n"
  git commit -v
  
  print "\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\n"
  print "New last commit: "
  gitLogToConsole:NumberOfCommits 1
}

gitignoreCreateFor_iOSProject() {
    gitignoreCreateFromTemplateFor:OS_IDE_Languages "iOS" "xcode" "appcode" "cocoapods" "carthage" "objective-c" "swift"
}

gitignoreCreateFromTemplateFor:OS_IDE_Languages(){
    gitAddToGitignoreFromTemplateFor:OS_IDE_Languages $1
}

gitAddToGitignoreFromTemplateFor:OS_IDE_Languages(){
  # todo:
  # handle arguments as an array
  # If there is an error while getting .gitignore-data from Internet, provide static stored '.gitignore' templates
  #   else update static stored gitignore templates: one template per each argument.
  curl https://www.gitignore.io/api/"visualstudiocode"%2C"macos"%2C"$1"%2C"$2"%2C"$3"%2C"$4"%2C"$5"%2C"$6"%2C"$7"%2C"$8"%2C"$9"%2C"$10" >> .gitignore &&\
  printSuccess &&\
  cat .gitignore
}

gitCreateBitbucketPrivateRepo:Username:RepsitoryName(){
    local bitbucketUsername="$1"
    local repsitoryName="$2"
    curl --user "$bitbucketUsername" https://api.bitbucket.org/1.0/repositories/ \
    -d name="$repsitoryName" \
    -d is_private=true
}

gitInitRepoWithBitbucketRemoteNamedLikePWD:bitbucketUsername(){
    local bitbucketUsername="$1"
    git init
    local currentDirectoryName=${PWD##*/}
    gitCreateBitbucketPrivateRepo:Username:RepsitoryName "$bitbucketUsername" "$currentDirectoryName" &&\
    git remote add origin git@bitbucket.org:"$bitbucketUsername"/"$currentDirectoryName".git
    printSuccess
    print "Remote URL:\ngit@bitbucket.org:$bitbucketUsername/$currentDirectoryName"
    print "Repository web-page URL:\nhttps://bitbucket.org/$bitbucketUsername/$currentDirectoryName"
}

gitCreateNewRepoWithRemoteInNewDirectory:bitbucketUsername:directoryName(){
    local userName="$1"
    local directoryName="$2"
    mkdir "$directoryName" &&\
    cd "$directoryName" &&\
    gitInitRepoWithBitbucketRemoteNamedLikePWD:bitbucketUsername "$userName"
}

gitPushSubtree() {
    local relativePathToSubTree="$1"
    local pathToTargetRepo="$2"
    local targetBranchName="$3"
    git subtree push --prefix="$relativePathToSubTree" --squash "$pathToTargetRepo" "$targetBranchName"
}

gitPullSubtree(){
    relativePathToSubTree="$1"
    pathToTargetRepo="$2"
    branchToPullFrom="$3"
    git subtree pull --prefix="$relativePathToSubTree" --squash "$pathToTargetRepo" "$branchToPullFrom"
}

gitDeleteTagFromLocalAndRemote:tag(){
    tagName="$1"
    git push --delete origin "$tagName"
    git tag -d "$tagName"
}

gitDeleteAllLocalBranchesExcept:branchToKeep(){
    branchToKeep="$1"
    git branch | grep -v "$branchToKeep" | xargs git branch -D
}

gitMergeButNoCommit:SourceBranch(){
    local sourceBranch="$1"
    git merge "$sourceBranch" --no-commit --no-ff
}

alias gitDisableFastForwardForCurrentRepo="git config merge.ff false"