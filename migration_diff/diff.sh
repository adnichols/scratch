#!/bin/sh -ex
export PS4='(${BASH_SOURCE}:${LINENO}): - [${SHLVL},${BASH_SUBSHELL},$?] $ '

PREV_SHA=`curl -s http://10.250.100.100:8080/job/program_creator_jruby/lastSuccessfulBuild/api/xml\?xpath\=/\*/action/lastBuiltRevision/SHA1 | sed -E 's/<SHA1>([a-zA-Z0-9]+)<\/SHA1>/\1/'`
MIGRATIONS=`git diff ${PREV_SHA} | grep 'db/migrate'`
echo $MIGRATIONS
if [ $(git diff ${PREV_SHA} | grep 'db/migrate')$? == "1" ] ; then
  echo "Exit: ${?}"
  echo "TEST: ${TEST}"
else 
  echo "Found migration"
fi
