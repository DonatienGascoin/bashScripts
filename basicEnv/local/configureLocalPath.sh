#!/bin/sh


echo "|**********************|"
echo "|****   Configure  ****|"
echo "|****  local path  ****|"
echo "|**********************|"

echo ""
#Datas
localPath=""

echo " **** Step 1: Local path"

echo "Write path since root folder to the Jar (target folder)"
read localPath


echo " **** Step 2: Edit Scripts"

echo "-> Edit sendJarToServer.sh"
sed -r -i "s#(localPath=)(.*)#\1$localPath#" "./local/sendJarToServer.sh"