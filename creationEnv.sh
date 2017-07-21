#!/bin/sh

echo "|**********************|"
echo "|****   Creation   ****|"
echo "|**** environement ****|"
echo "|**********************|"
echo -e "\n\n"

#scp Quizz.database-1.0.1.jar Quizz.database-1.0.1.jar.original dgascoin@51.15.11.126:~

isDataOk=0

#Data to fill
ipServer=""
userName=""
projectName="project"
localPath=""

qlf="no"

echo " **** Step 1: Fill project information"


while [ $isDataOk == 0 ]
do
	echo "Write following informations"
	echo " - Project name:"
	read projectName

	echo " - Server IP:"
	read ipServer

	echo " - Server user name "
	read userName

	echo " - Local path to your project (Since root folder, can be edit after) "
	read localPath

	echo " - Do you want test environement? (y/n)"
	read qlf

	case "$qlf" in
    	[yY]) 
        qlf="yes"
        ;;
    	*)
        qlf="no"
        ;;
	esac

	clear
	echo " Data recap:"
	echo " - Project name: $projectName"
	echo " - Server ip: $ipServer"
	echo " - Server user name: $userName"
	echo " - Local path to project: $localPath"
	echo -e " - Test environement: $qlf (additional, production environment will be provided by default)"

	echo -e "\nAre you OK? (y/n)"
	read isDataOk

	case "$isDataOk" in
    	[yY]) 
        isDataOk=1
        ;;
    	*)
        isDataOk=0
        clear
        ;;
	esac
done

# Create project folder and put usefull scripts
echo " **** Step 2: create directory named $projectName"

mkdir $projectName
cd $projectName

mkdir "local"
mkdir "server"

cd "../"

cp ./basicEnv/local/* "./$projectName/local"
cp ./basicEnv/server/* "./$projectName/server"

# Remove unusual script
if [ $qlf == "no" ]
	then
	rm "./$projectName/local/moveTestVersionToProd.sh"
	rm "./$projectName/server/moveTestVersionToProd.sh"
fi

# Generate scripts server with options datas
echo " **** Step 3: Edit scripts "

# Edit local files
cd "./$projectName/local"

echo "-> Edit sendJarToServer.sh"

echo "   -> Edit server ip"
sed -r -i "s#(ipServer=)(.*)#\1\"$ipServer\"#" sendJarToServer.sh

echo "   -> Edit server user name"
sed -r -i "s#(userName=)(.*)#\1\"$userName\"#" sendJarToServer.sh

echo "   -> Edit server path"
sed -r -i "s#(serverPath=)(.*)#\1\"~/$projectName/tmp\"#" sendJarToServer.sh

echo "   -> Edit local path"
sed -r -i "s#(localPath=)(.*)#\1\"$localPath\"#" sendJarToServer.sh	





#Edit server files

cd "../server"

echo "-> Edit installServerEnv.sh"
echo "   -> Edit project name"
sed -r -i "s#(projectName=)(.*)#\1\"$projectName\"#" installServerEnv.sh
echo "   -> Edit test environment"
sed -r -i "s#(qlf=)(.*)#\1\"$qlf\"#" installServerEnv.sh





# Send scripts on servers (Send also creation folder)
echo " **** Step 4: Send scripts on server "
scp installServerEnv.sh loadJar.sh moveTestVersionToProd.sh $userName@$ipServer:~/

echo " **** Step 5: Execute installation environnment "
ssh $userName@$ipServer -C "~/installServerEnv.sh" 
# Call creation folder on server


