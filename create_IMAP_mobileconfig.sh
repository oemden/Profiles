#!/bin/bash

## Generate mobileconfig IMAP
## hosted on Os X mail Server 

## ================= EDIT BELOW START ================
### ==================================================
# shortname / login
#username="jdoe" ## $1
#EmailName="j.doe" ## $2
#Password="P&ssw0rd" ## $3

EmailDomain="example.com"
ServerHostName="mail.example.com"
PayloadDescription="My Great Company Email Configuration"
PayloadOrganization="Company &amp; Co"
ProfileManagerServer="dsrv.int.example.com"

## ================= EDIT BELOW END ==================
### ==================================================

me=`basename $0`

if [[ ! "${1}" ]] ; then
	echo "Please enter parameters :" ; echo
	echo "you have to modify the script and edit the domain and Mail server host"
	echo " - Current Domain is : ${EmailDomain} " 
	echo " - Current ServerHostName is :${ServerHostName} "
	echo
	echo "and then call the script with 3 parameters :"
	echo "$me \"shortname\" \"emailname\" \"password\"" ; echo
	echo "for exemple:"
	echo "$me \"jdoe\" \"j.doe\" \"P&ssw0rd\" " ; echo
	exit 1
fi

# check input param
if [[ -n "${2}" ]] && [[ -n "${3}" ]] ; then
	username="${1}" ## $1
	EmailName="${2}" ## $2
	Password="${3}" ## $3
	EmailAddress="${EmailName}@${EmailDomain}"
	echo "getting parameters as variables"
	echo "username: $username"
	echo "EmailName: $EmailName"
	echo "Password: $Password"
fi

PayloadDisplayName="email ${username} "
mobileconfigFile="${username}.IMAP.mobileconfig"
EmailAccountDescription="${username}"
EmailAccountName="${username}"
EmailAddress="${EmailName}@${EmailDomain}"
IncomingMailServerUsername="${ServerHostName}"
OutgoingMailServerUsername="${ServerHostName}"
IncomingPassword="${Password}"
OutgoingPassword="${Password}"

PayloadContentUUID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
PayloadUUID="$(uuidgen | tr '[:upper:]' '[:lower:]')"

function convert_ampersand {
	#Specific to S&P
	echo "Converting Ampersand"
	if [[ "${Password}" =~ "&" ]] ; then
		#echo "${Password}" | sed 's/&/&amp;/g'
		Password=$(echo "${Password}" | sed 's/&/&amp;/g')
		echo "${Password}"
	fi
}

function generate_mobileconfig {
echo "<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PayloadIdentifier</key>
	<string>com.apple.mdm."${ProfileManagerServer}"."${PayloadUUID}".alacarte</string>
	<key>PayloadRemovalDisallowed</key>
	<false/>
	<key>PayloadScope</key>
	<string>User</string>
	<key>PayloadType</key>
	<string>Configuration</string>
	<key>PayloadUUID</key>
	<string>"${PayloadUUID}"</string>
	<key>PayloadOrganization</key>
	<string>Company &amp; Co</string>
	<key>PayloadVersion</key>
	<integer>1</integer>
	<key>PayloadDisplayName</key>
	<string>"${PayloadDisplayName}"</string>
	<key>PayloadDescription</key>
	<string>"${PayloadDescription}"</string>
	<key>PayloadContent</key>
	<array>
		<dict>
			<key>PayloadType</key>
			<string>com.apple.mail.managed</string>
			<key>PayloadVersion</key>
			<integer>1</integer>
			<key>PayloadIdentifier</key>
			<string>com.apple.mdm."${ProfileManagerServer}"."${PayloadUUID}".alacarte.email."${PayloadContentUUID}"</string>
			<key>PayloadUUID</key>
			<string>"${PayloadContentUUID}"</string>
			<key>PayloadEnabled</key>
			<true/>
			<key>PayloadDisplayName</key>
			<string>"${EmailName}"</string>
			<key>EmailAccountDescription</key>
			<string>"${EmailName}"</string>
			<key>disableMailRecentsSyncing</key>
			<false/>
			<key>PreventMove</key>
			<false/>
			<key>PreventAppSheet</key>
			<false/>
			<key>SMIMEEnabled</key>
			<false/>
			<key>SMIMEEnablePerMessageSwitch</key>
			<false/>
			<key>IncomingMailServerPortNumber</key>
			<integer>143</integer>
			<key>IncomingMailServerAuthentication</key>
			<string>EmailAuthPassword</string>
			<key>IncomingMailServerUseSSL</key>
			<false/>
			<key>OutgoingMailServerPortNumber</key>
			<integer>587</integer>
			<key>OutgoingMailServerAuthentication</key>
			<string>EmailAuthPassword</string>
			<key>OutgoingMailServerUseSSL</key>
			<false/>
			<key>EmailAccountType</key>
			<string>EmailTypeIMAP</string>
			<key>EmailAccountName</key>
			<string>"${username}"</string>
			<key>EmailAddress</key>
			<string>"${EmailAddress}"</string>
			<key>IncomingMailServerHostName</key>
			<string>"${ServerHostName}"</string>
			<key>IncomingMailServerUsername</key>
			<string>"${username}"</string>
			<key>IncomingPassword</key>
			<string>"${Password}"</string>
			<key>OutgoingMailServerHostName</key>
			<string>"${ServerHostName}"</string>
			<key>OutgoingMailServerUsername</key>
			<string>"${username}"</string>
			<key>OutgoingPasswordSameAsIncomingPassword</key>
			<true/>
		</dict>
	</array>
</dict>
</plist>
"
}

## Precheck Password
convert_ampersand

## Generate MDM
generate_mobileconfig  > "${mobileconfigFile}"
