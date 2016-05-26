#!/bin/bash

## Generate mobileconfig iCal
## hosted on Os X mail Server 
##
## ================= EDIT BELOW START ================
### ==================================================
# shortname / login
#username="jdoe" ## $1
#EmailName="j.doe" ## $2
#Password="P&ssw0rd" ## $3

EmailDomain="example.com"
CalDAVHostName="mail.example.com"
CalDAVAccountDescription="My Great Company iCal Configuration"
PayloadOrganization="Company &amp; Co"
PayloadDisplayName="iCal ${username} "
ProfileManagerServer="dsrv.int.example.com"

## ================= EDIT BELOW END ==================
### ==================================================


if [[ ! "${1}" ]] ; then
	echo "Please enter parameters :" ; echo
	echo "you have to modify the script and edit the domain and Caldav server host"
	echo " - Current Domain is : ${EmailDomain} " 
	echo " - Current ServerHostName is :${CalDAVHostName} "
	echo
	echo "and then call the script with 3 parameters :"
	echo "$me \"shortname\" \"emailname\" \"password\"" ; echo
	echo "for exemple:"
	echo "$me \"jdoe\" \"j.doe\" \"P&ssw0rd\" " ; echo
	exit 1
fi

# check input param
if [[ -n "${2}" ]] &&  [[ -n "${3}" ]] ; then
	username="${1}" ## $1
	EmailName="${2}" ## $2
	Password="${3}" ## $3
	echo "getting parameters as variables"
	echo "username: $username"
	echo "EmailName: $EmailName"
	echo "Password: $Password"
fi

mobileconfigFile="${username}.ICAL.mobileconfig"
PayloadContentUUID_ICAL="$(uuidgen | tr '[:upper:]' '[:lower:]')"
PayloadUUID_ICAL="$(uuidgen | tr '[:upper:]' '[:lower:]')"

function convert_ampersand {
	#Specific to S&P
	echo "Converting Ampersand"
	if [[ "${Password}" =~ "&" ]] ; then
		#echo "${Password}" | sed 's/&/&amp;/g'
		Password=$(echo "${Password}" | sed 's/&/&amp;/g')
		echo "${Password}"
	fi
}

function generate_ical_mobileconfig {
echo "<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
<dict>
		<key>PayloadIdentifier</key>
		<string>com.apple.mdm."${ProfileManagerServer}"."${PayloadUUID_ICAL}".alacarte</string>
		<key>PayloadRemovalDisallowed</key><true/>
		<key>PayloadScope</key>
		<string>User</string>
		<key>PayloadType</key>
		<string>Configuration</string>
		<key>PayloadUUID</key>
		<string>"${PayloadUUID_ICAL}"</string>
		<key>PayloadOrganization</key>
		<string>"${PayloadOrganization}"</string>
		<key>PayloadVersion</key>
		<integer>1</integer>
		<key>PayloadDisplayName</key>
		<string>"${PayloadDisplayName}"</string>
		<key>PayloadContent</key>
		<array>
			<dict>
				<key>PreventMove</key>
				<false/>
				<key>PayloadType</key>
				<string>com.apple.caldav.account</string>
				<key>PayloadVersion</key>
				<integer>1</integer>
				<key>PayloadIdentifier</key>
				<string>com.apple.mdm."${ProfileManagerServer}"."${PayloadUUID_ICAL}".alacarte.caldav."${PayloadContentUUID_ICAL}"</string>
				<key>PayloadUUID</key>
				<string>"${PayloadContentUUID_ICAL}"</string>
				<key>PayloadEnabled</key><true/>
				<key>PayloadDisplayName</key>
				<string>"${PayloadDisplayName}"</string>
				<key>CalDAVAccountDescription</key>
				<string>"${CalDAVAccountDescription}"</string>
				<key>CalDAVPort</key>
				<integer>8008</integer>
				<key>CalDAVUseSSL</key>
				<false/>
				<key>CalDAVHostName</key>
				<string>"${CalDAVHostName}"</string>
				<key>CalDAVUsername</key>
				<string>"${username}"</string>
				<key>CalDAVPassword</key>
				<string>"${Password}"</string>
			</dict>
		</array>
</dict>
</plist>
"
}

## Precheck Password
convert_ampersand

## Generate MDM
generate_ical_mobileconfig  > "${mobileconfigFile}"
