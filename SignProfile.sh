#!/bin/bash

#sign profile with Profile Manager certificate
# oem at oemden dot com

## ====== TODO
## 	Add HostName check
## 	Add Cert check
## ===================

signedExtension="Signed"
profileFile="${1}"
profileFileSigned="${2}"
ProfileManagerServer="dsrv.int.example.com" #no needed
ProfileManagerServerCodeSigningCertificate="dsrv.int.example.com Code Signing Certificate"
me=`basename $0`

## must run sudo
if [ `id -u` -ne 0 ] ; then
	printf " == Must be run as sudo, exiting == "
	echo 
	exit 1
fi

if [[ ! "${2}" ]] ; then
	echo " I need the profile file NAMES as input"
	echo "Please enter parameters :" ; echo
	echo "you have to modify the script and edit Code signing Certificate"
	echo " - Current Profile Manager is : ${ProfileManagerServer} " 
	echo " - Current Code signing certificate is :${ProfileManagerServerCodeSigningCertificate} "
	echo
	echo "and then call the script with 2 parameters :"
	echo "$me \"inputfile\" \"outputfile\" " ; echo
	echo "for exemple:"
	echo "$me \"jdoe.IMAP.mobileconfig\" \"jdoe.IMAP.signed.mobileconfig\" " ; echo
	exit 1
fi

function sign_profile {
	/usr/bin/security cms -S -N "${ProfileManagerServerCodeSigningCertificate}" -i "${profileFile}" -o "${profileFileSigned}"
}

sign_profile
