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
artifactId=""
packaging=""
version=""
localPath=""

qlf="no"

echo " **** Step 1: Fill project information"


while [ $isDataOk == 0 ]
do
	echo "Write following informations"
	echo " - Project name (without space):"
	read projectName

	echo " - Project artifactId:"
	read artifactId

	echo " - Project packaging (jar, war...):"
	read packaging

	echo " - Project version:"
	read version

	echo " - Server IP:"
	read ipServer

	echo " - Server user name "
	read userName

	echo " - Local path to your jar project (Since root folder, can be edit after): "
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
	echo " - Project artifactId: $artifactId"
	echo " - Project packaging: $packaging (make sure you juste write extension, without \".\")"
	echo " - Project version: $version"
	echo " - Server ip: $ipServer"
	echo " - Server user name: $userName"
	echo " - Local path to project: $localPath"
	echo " - Test environement: $qlf (additional, production environment will be provided by default)"

	echo "Are you OK? (y/n)"
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

echo "-> Edit retrieveJarInfo.sh"

echo "   -> Edit local Path"
sed -r -i "s#(localPath=)(.*)#\1\"$localPath\"#" retrieveJarInfo.sh

echo "-> Edit sendJarToServer.sh"

echo "   -> Edit server ip"
sed -r -i "s#(ipServer=)(.*)#\1\"$ipServer\"#" sendJarToServer.sh

echo "   -> Edit server user name"
sed -r -i "s#(userName=)(.*)#\1\"$userName\"#" sendJarToServer.sh

echo "   -> Edit server user name"
sed -r -i "s#(artifactId=)(.*)#\1\"$artifactId\"#" sendJarToServer.sh

echo "   -> Edit project artifactId"
sed -r -i "s#(userName=)(.*)#\1\"$userName\"#" sendJarToServer.sh

echo "   -> Edit project packaging"
sed -r -i "s#(packaging=)(.*)#\1\"$packaging\"#" sendJarToServer.sh

echo "   -> Edit project version"
sed -r -i "s#(version=)(.*)#\1\"$version\"#" sendJarToServer.sh

echo "   -> Edit local path"
sed -r -i "s#(localPath=)(.*)#\1\"$localPath\"#" sendJarToServer.sh	

if [ $qlf == "yes" ]
	then
	echo "   -> Edit default environment (test)"
	sed -r -i "s#(environment=)(.*)#\1\"test\"#" sendJarToServer.sh

	echo "-> Edit moveTestVersionToProd.sh"

	echo "   -> Edit user name"
	sed -r -i "s#(userName=)(.*)#\1\"$userName\"#" moveTestVersionToProd.sh

	echo "   -> Edit server ip"
	sed -r -i "s#(ipServer=)(.*)#\1\"$ipServer\"#" moveTestVersionToProd.sh
fi

#Edit server files

cd "../server"

echo "-> Edit installServerEnv.sh"
echo "   -> Edit project name"
sed -r -i "s#(projectName=)(.*)#\1\"$projectName\"#" installServerEnv.sh
echo "   -> Edit test environment"
sed -r -i "s#(qlf=)(.*)#\1\"$qlf\"#" installServerEnv.sh

echo "-> Edit loadJar.sh"
echo "   -> Edit project root folder"
sed -r -i "s#(path=)(.*)#\1\"~/$projectName/\"#" installServerEnv.sh





# Send scripts on servers (Send also creation folder)
echo " **** Step 4: Send scripts on server "
scp installServerEnv.sh loadJar.sh moveTestVersionToProd.sh $userName@$ipServer:~/

echo " **** Step 5: Execute installation environnment "
ssh $userName@$ipServer -C "~/installServerEnv.sh" 