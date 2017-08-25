#!/bin/sh

function usage(){
	echo "|******************************|"
	echo "|***** Send Jar on server *****|"
	echo "|******************************|"
	echo "|Options:                      |"
	echo "| -h for help                  |"
	echo "|------------------------------|"
    echo "|                              |"
    echo "| If you want to send directly |"
    echo "| on production environment    |"
    echo "| -f force send to prod (yes)  |"
	echo "|                              |"
	echo "|******************************|"

}


#Data

ipServer="51.15.11.126"
userName="dgascoin"
serverPath="~/topquizz"

localPath="/c/projects/TopQuizzApi/target"
environment="test"
forceProd="no"

artifactId="Quizz.database"
packaging="jar"
version="1.0.1"

jarName=""

#Get option
while getopts ":f:h" OPTION; do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        f)
            forceProd=$OPTARG
            echo "Force sending Jar to production"
            ;;
    esac
done

jarName="$artifactId-$version.$packaging"
echo $jarName
cd $localPath

    echo "Send Jar file on server"

if [ $environment == "test" ] && [ $forceProd == "no" ]
    then
    envi="test"
else
    envi="prod"
fi

scp ./$jarName $userName@$ipServer:"$serverPath/tmp/$jarName"

echo "Start API script to load new Jar file"
ssh $userName@$ipServer -C "$serverPath/scripts/loadJar.sh -e $envi -j $jarName"