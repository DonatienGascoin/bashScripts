#!/bin/sh

packaging=""

echo "|***********************|"
echo "|****   Move test   ****|"
echo "|****    version    ****|"
echo "|**** to production ****|"
echo "|***********************|"

echo " **** Step 1: Checking running Jar in production"

process=$(ps axf | grep $packaging | grep "Dspring.profiles.active=prod" | awk '{print $1}')
oldJarName=$(ps axf | grep $packaging | grep "Dspring.profiles.active=prod" | awk '{print $8}')

cd "topquizz"

if [ ! -z $process ]
        then
        echo "    Stop running production Jar"
        kill -9 $process > /dev/null 2>&1

        echo "    Move old Jar to archives"
        mv ./prod/$oldJarName ./prod/archives/$oldJarName$DATE 
    fi

echo "    Move new Jar to production"
mv "$path/test/*.$packaging" "$path/prod/"

echo "    Start new Jar" 

java -jar -Dspring.profiles.active=prod $jarName