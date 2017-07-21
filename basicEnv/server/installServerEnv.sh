#!/bin/bash

echo "|***********************|"
echo "|****  Instalation  ****|"
echo "|****    server     ****|"
echo "|**** environement  ****|"
echo "|***********************|"
echo -e "\n\n"
echo "Environment will be provided in following way:"
echo "   Project name"
echo "   ---- Scripts"
echo "   ---- Production"
echo "   -------- archives"
echo "   ---- Test"
echo "   -------- archives"
echo "   ---- tmp"
echo ""
echo "   -> Please do not delete folders, scripts (local and server may be broken)"
echo "   -> in production and test environment will be put actual jar"
echo "   -> Production and test can work in same time:"	
echo "      Test port: 8091"
echo "      Prod port: 8090"
echo -e "\n\n"

#Datas
projectName=""
qlf="no"

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
mv "installServerEnv.sh" "$projectName/scripts/"
mv "loadJar.sh" "$projectName/scripts/"
mv "moveTestVersionToProd.sh" "$projectName/scripts/"

echo -e "\n\n"
echo "|*****************************************|"
echo "|Installation:                        100%|"
echo "|Project ready to use                     |"
echo "|*****************************************|"

exit 0