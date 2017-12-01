#!/bin/bash
REPOMAIN=$HOME/defensor

if [ -n $1 -a -d $REPOMAIN/$1 ]; then
    cd $REPOMAIN/$1 && git pull
    echo "done"
    exit
fi

cd $REPOMAIN/vstar
echo ============vstar==============
git pull  &&  echo

cd $REPOMAIN/vlibrary
echo ============vlibrary==============
git pull  &&  echo

cd $REPOMAIN/library
echo ============library==============
git pull  && echo

echo '>>>>>>>>>>now update your phpstorm :/<<<<<<<<<<<<'
