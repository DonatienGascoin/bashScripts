#!/bin/sh

userName="dgascoin"
ipServer="51.15.11.126"
projectName="topquizz"

ssh $userName@$ipServer -C "~/$projectName/scripts/moveTestVersionToProd.sh"