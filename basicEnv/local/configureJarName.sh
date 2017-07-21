#!/bin/sh


echo "|**********************|"
echo "|****   Configure  ****|"
echo "|****   jar name   ****|"
echo "|**********************|"

echo ""
#Datas
jarName=""

echo " **** Step 1: Jar name"

echo "Write jar name (on target folder)"
read jarName


echo " **** Step 2: Edit Scripts"

echo "-> Edit sendJarToServer.sh"
sed -r -i "s#(jarName=)(.*)#\1\"$jarName\"#" "sendJarToServer.sh"