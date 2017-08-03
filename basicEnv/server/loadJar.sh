#!/bin/sh


if [ $# -eq 0 ]
then
        echo "Missing options!"
        echo "(run -h for help)"
        exit 1
fi

#Data

environment="prod"
jarName=""
oldJarName=""
#path to project root folder
path=""
process=""

#Get option
while getopts ":j:e:" OPTION; do
    case $OPTION in
        e)
            environment=$OPTARG
            ;;
        j)
            jarName=$OPTARG
            ;;
    esac
done

DATE=`date +%Y%m%d%H%M%S`
if [ $environment == "prod" ]
then
	echo " **** Step 1: Checking running Jar "

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
    mv "$path/tmp/$jarName" "$path/prod/"

    echo "    Start new Jar" 

	java -jar -Dspring.profiles.active=production $jarName
else
    echo " **** Step 1: Checking running Jar "

    process=$(ps axf | grep "-Dspring.profiles.active=test" | grep -v grep | awk '{print $1}')
    oldJarName=$(ps axf | grep "-Dspring.profiles.active=test" | grep -v grep | awk '{print $7}')

    if [ $process != "" ]
        then
        echo "    Stop running test Jar"
        kill -9 $process

        echo "    Move old Jar to archives"
        mv "$path/test/$oldJarName" "$path/test/archives/$oldJarName$DATE" 
    fi

    echo "    Move new Jar to production"
    mv "$path/tmp/$jarName" "$path/test/"

    echo "    Start new Jar" 

    java -jar -Dspring.profiles.active=test $jarName
fi

