#!/bin/bash
#
# Copyright (C) 2020 by UsergeTeam@Github, < https://github.com/UsergeTeam >.
#
# This file is part of < https://github.com/UsergeTeam/Userge > project,
# and is released under the "GNU v3.0 License Agreement".
# Please see < https://github.com/uaudith/Userge/blob/master/LICENSE >
#
# All rights reserved.

declare -r pVer=$(sed -E 's/\w+ ([2-3])\.([0-9]+)\.([0-9]+)/\1.\2.\3/g' < <(python3.8 -V))

log() {
    local text="$*"
    test ${#text} -gt 0 && test ${text::1} != '~' \
        && echo -e "[$(date +'%d-%b-%y %H:%M:%S') - INFO] - init - ${text#\~}"
}

quit() {
    local err="\t:: ERROR :: $1\nExiting With SIGTERM ..."
    if (( getMessageCount )); then
        replyLastMessage "$err"
    else
        log "$err"
    fi
    exit 1
}

stopBGProcesses() {
    log "Exiting With SIGINT ..."
    echo quit >> logs/logbot.stdin
    log "Cleaning Installation Processes ..."
    sleep 3
}

runPythonCode() {
    python${pVer%.*} -c "$1"
}

runPythonModule() {
    python${pVer%.*} -m "$@"
}

gitInit() {
    git init &> /dev/null
}

gitClone() {
    git clone "$@" &> /dev/null
}

addUpstream() {
    git remote add $UPSTREAM_REMOTE ${UPSTREAM_REPO%.git}.git
}

updateUpstream() {
    git remote rm $UPSTREAM_REMOTE && addUpstream
}

fetchUpstream() {
    git fetch $UPSTREAM_REMOTE &> /dev/null
}

upgradePip() {
    pip3 install -U pip &> /dev/null
}

installReq() {
    pip3 install -r $1/requirements.txt &> /dev/null
}

printLine() {
    echo ========================================================
}

printLogo() {
    printLine
    echo '


                                                                                
                                                                                
DDDDDDDDDDDDD                GGGGGGGGGGGGG                 XXXXXXX       XXXXXXX
D::::::::::::DDD          GGG::::::::::::G                 X:::::X       X:::::X
D:::::::::::::::DD      GG:::::::::::::::G                 X:::::X       X:::::X
DDD:::::DDDDD:::::D    G:::::GGGGGGGG::::G                 X::::::X     X::::::X
  D:::::D    D:::::D  G:::::G       GGGGGG                 XXX:::::X   X:::::XXX
  D:::::D     D:::::DG:::::G                                  X:::::X X:::::X   
  D:::::D     D:::::DG:::::G                                   X:::::X:::::X    
  D:::::D     D:::::DG:::::G    GGGGGGGGGG ---------------      X:::::::::X     
  D:::::D     D:::::DG:::::G    G::::::::G -:::::::::::::-      X:::::::::X     
  D:::::D     D:::::DG:::::G    GGGGG::::G ---------------     X:::::X:::::X    
  D:::::D     D:::::DG:::::G        G::::G                    X:::::X X:::::X   
  D:::::D    D:::::D  G:::::G       G::::G                 XXX:::::X   X:::::XXX
DDD:::::DDDDD:::::D    G:::::GGGGGGGG::::G                 X::::::X     X::::::X
D:::::::::::::::DD      GG:::::::::::::::G                 X:::::X       X:::::X
D::::::::::::DDD          GGG::::::GGG:::G                 X:::::X       X:::::X
DDDDDDDDDDDDD                GGGGGG   GGGG                 XXXXXXX       XXXXXXX
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
'
    printLine
}