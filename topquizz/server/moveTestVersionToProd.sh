#!/bin/sh

echo "|***********************|"
echo "|****   Move test   ****|"
echo "|****    version    ****|"
echo "|**** to production ****|"
echo "|***********************|"

echo " **** Step 1: Checking running Jar in production"

process=$(ps axf | grep "-Dspring.profiles.active=prod" | grep -v grep | awk '{print $1}')
oldJarName=$(ps axf | grep "-Dspring.profiles.active=prod" | grep -v grep | awk '{print $7}')

if [ $process != "" ]
    then
    echo "    Stop running production Jar"
    kill -9 $process

    echo "    Move old Jar to archives"
    mv "$path/prod/$oldJarName" "$path/prod/archives/$oldJarName$DATE" 
fi

echo "    Move new Jar to production"
mv "$path/test/$jarName" "$path/prod/"

echo "    Start new Jar" 

java -jar -Dspring.profiles.active=production $jarName