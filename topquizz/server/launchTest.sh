#!/bin/bash
set -e

#Data

jarName=""
packaging="jar"
process=""

cd "../test"

echo " **** Step 1: Checking existing test Jar "
jarName=$(ls -l | grep *.$packaging | awk '{print $9}')

if [ jarName == "" ]
then
    echo "There is not Jar to use in test folder"
    exit 1
fi 

echo " **** Step 2: Checking running Jar "

process=$(ps axf | grep $packaging | grep "Dspring.profiles.active=test" | awk '{print $1}')
oldJarName=$(ps axf | grep $packaging | grep "Dspring.profiles.active=test" | awk '{print $8}')

if [ ! -z $process ]
    then
	echo "    Test Process [$process]"
    echo "    Stop running test Jar"
    kill -9 $process > /dev/null 2>&1
fi

echo "    Start test Jar" 

java -jar -Dspring.profiles.active=test $jarName &

exit 0