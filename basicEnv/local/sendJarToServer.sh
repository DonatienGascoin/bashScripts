#!/bin/sh

function usage(){
	echo "|******************************|"
	echo "|***** Send Jar on server *****|"
	echo "|******************************|"
	echo "|Options:                      |"
	echo "| -h for help                  |"
	echo "|------------------------------|"
	echo "| -j jar name                  |"
    echo "| -e environment (prod/qlf)    |"
    echo "|                              |"
    echo "| If you want to send directly |"
    echo "| on production environment    |"
    echo "| -f force send to prod (yes)  |"
	echo "|                              |"
	echo "|******************************|"

}


if [ $# -eq 0 ]
then
        echo "Missing options!"
        echo "(run -h for help)"
        exit 1
fi

#Data

ipServer=""
userName=""
serverPath=""

localPath=""
environment="prod"
forceProd="no"

artifactId=""
packaging=""
version=""

jarName=""

#Get option
while getopts "h:f" OPTION; do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        f)
            forceProd=$OPTARG
            ;;
    esac
done

jarName="$artifactId-$version.packaging"

cd $localPath

    echo "Send Jar file on server"

if [ $environment == "test" ] && [ $forceProd == "no" ]
    then
    envi="test"
else
    envi="prod"
fi


scp ./$jarName $userName@$ipServer:~/$serverPath

echo "Start API script to load new Jar file"
ssh $userName@$ipServer -C "~/scripts/loadJar.sh -e $envi -j $jarName"