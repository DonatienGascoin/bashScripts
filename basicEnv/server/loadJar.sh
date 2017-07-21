#!/bin/sh

# If test env created, use it by default
if [ $qlf == "yes" ]
	then
	sed -r -i "s#(serverPath=)(.*)#\1serverPath=\"~/$projectName/test\"#" sendJarToServer.sh	
else
	sed -r -i "s#(serverPath=)(.*)#\1serverPath=\"~/$projectName/\"#" sendJarToServer.sh
fi
