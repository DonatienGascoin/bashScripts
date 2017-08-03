#!/bin/sh


echo "|**********************|"
echo "|***  Edit scripts  ***|"
echo "|****   with pom   ****|"
echo "|**********************|"

echo ""
#Datas
localPath=""
artifactId=""
packaging=""
version=""


echo " **** Step 1: Retrieve informations"
artifactId=$(grep -m1 artifactId $localPath/../pom.xml | grep -o -P '(?<=<artifactId>).*(?=</artifactId>)')
packaging=$(grep -m1 packaging $localPath/../pom.xml | grep -o -P '(?<=<packaging>).*(?=</packaging>)')
version=$(grep -m1 version $localPath/../pom.xml | grep -o -P '(?<=<version>).*(?=</version>)')




echo " **** Step 2: Edit Scripts"

echo "   -> Edit project artifactId"
sed -r -i "s#(artifactId=)(.*)#\1\"$artifactId\"#" sendJarToServer.sh

echo "   -> Edit project packaging"
sed -r -i "s#(packaging=)(.*)#\1\"$packaging\"#" sendJarToServer.sh

echo "   -> Edit project version"
sed -r -i "s#(version=)(.*)#\1\"$version\"#" sendJarToServer.sh