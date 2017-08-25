#!/bin/bash


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
packaging="jar"
#path to project root folder
pathToProject="~/topquizz"
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

cd "topquizz"

if [ $environment == "prod" ]
then
    echo " **** Step 1: Checking running Jar "

    process=$(ps axf | grep $packaging | grep "Dspring.profiles.active=prod" | awk '{print $1}')
    oldJarName=$(ps axf | grep $packaging | grep "Dspring.profiles.active=prod" | awk '{print $8}')
echo "Prod Process [$process]"
    if [ ! -z $process ]
        then
        echo "    Stop running production Jar"
        kill -9 $process > /dev/null 2>&1

        echo "    Move old Jar to archives"
        mv ./prod/$oldJarName ./prod/archives/$oldJarName$DATE 
    fi

    echo "    Move new Jar to production"
    mv ./tmp/$jarName ./prod/

    echo "    Start new Jar" 

    cd ./prod/
    java -jar -Dspring.profiles.active=prod $jarName &
else
    echo " **** Step 1: Checking running Jar "

    process=$(ps axf | grep $packaging | grep "Dspring.profiles.active=test" | awk '{print $1}')
    oldJarName=$(ps axf | grep $packaging | grep "Dspring.profiles.active=test" | awk '{print $8}')
echo "Test Process [$process]"
    if [ ! -z $process ]
        then
        echo "    Stop running test Jar"
        kill -9 $process > /dev/null 2>&1

        echo "    Move old Jar to archives"
        mv ./test/$oldJarName ./test/archives/$oldJarName$DATE 
    fi
    echo "    Move new Jar to test"
    mv ./tmp/$jarName ./test/

    echo "    Start new Jar" 
    echo "La: "$(pwd)
    cd "./test/"
    java -jar -Dspring.profiles.active=test $jarName &
fi


