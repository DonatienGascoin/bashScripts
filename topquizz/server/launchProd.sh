#!/bin/bash
set -e

#Data

jarName=""
packaging="jar"
process=""

cd "../prod"

echo " **** Step 1: Checking existing prod Jar "
jarName=$(ls -l | grep *.$packaging | awk '{print $9}')

if [ jarName == "" ]
then
    echo "There is not Jar to use in production folder"
    exit 1
fi 

echo " **** Step 2: Checking running Jar "

process=$(ps axf | grep $packaging | grep "Dspring.profiles.active=prod" | awk '{print $1}')
oldJarName=$(ps axf | grep $packaging | grep "Dspring.profiles.active=prod" | awk '{print $8}')


if [ ! -z $process ]
    then
    echo "    Prod Process [$process]"
    echo "    Stop running production Jar"
    kill -9 $process > /dev/null 2>&1
fi

echo "    Start production Jar" 

java -jar -Dspring.profiles.active=prod $jarName &

exit 0