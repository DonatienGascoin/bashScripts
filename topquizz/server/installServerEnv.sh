#!/bin/bash

#Datas
projectName="topquizz"
qlf="yes"


echo ""
echo "Environment will be provided in following way:"
echo "   $projectName"
echo "   ---- scripts"
echo "   ---- production"
echo "   -------- archives"
echo "   ---- test"
echo "   -------- archives"
echo "   ---- tmp"
echo ""
echo "   -> Please do not delete folders, scripts (local and server scripts may be broken)"
echo "   -> Production and test can work in same time if you configure active profiles"	
echo -e "\n\n"


echo " **** Step 1: Create architecture"

cd ~
mkdir $projectName

cd $projectName
mkdir "scripts"
mkdir "tmp"
mkdir "prod"
cd "./prod"
mkdir "archives"
cd "../"

if [ $qlf == "yes" ]
	then
	mkdir "test"
	cd "./test"
	mkdir "archives"
	cd "../"
fi

echo " **** Step 2: Move scripts"
cd "../"

#change CR LF by LF
 sed -i -e 's/\r$//' ./*.sh

mv "installServerEnv.sh" "$projectName/scripts/"
mv "loadJar.sh" "$projectName/scripts/"
mv "moveTestVersionToProd.sh" "$projectName/scripts/"

echo -e "\n\n"
echo "|*****************************************|"
echo "|Installation:                        100%|"
echo "|Project ready to use                     |"
echo "|*****************************************|"

exit 0