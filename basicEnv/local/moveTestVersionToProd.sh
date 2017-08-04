#!/bin/sh

userName=""
ipServer=""
projectName=""

ssh $userName@$ipServer -C "~/$projectName/scripts/moveTestVersionToProd.sh"