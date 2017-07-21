#!/bin/sh

function usage(){
	echo "|******************************|"
	echo "|***** Send Jar on server *****|"
	echo "|******************************|"
	echo "|Options:                      |"
	echo "| -h for help                  |"
	echo "|------------------------------|"
	echo "| -p path to Jar               |"
	echo "| -j jar name                  |"
	echo "| -e environment (prod/qlf)    |"
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
localPath=""
serverPath=""
jarName=""
environment="prod"

#Get optiona
while getopts ":p:j:e:h" OPTION; do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        p)
            localPath=sdfg
            ;;
        j)
            jarName=$OPTARG
            ;;
        e)
            environment=$OPTARG
            ;;
    esac
done

if [ -z $localPath ] || [ -z $jarName ] || [ -z $environment ]
then
        echo "Probleme with options !"
        echo "(run -h for help)"
        exit 1
fi

cd $localPath

echo "Send Jar file on server"
scp ./$jarName $userName@$ipServer:~/$serverPath

echo "Start API script to load new Jar file"
ssh $userName@$ipServer -C "~/scripts/deployApi.sh" 

