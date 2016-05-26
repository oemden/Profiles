#Sign Profiles from commandline using profile Manager Code signing Certificate.

Sign any (manually created) profiles without a developper Code signing Certificate by using Profile Manager Code signing Certificate.

It works with any profile so far even those created with Apple Configurator or those found on github.

The script **SignProfile.sh** have to be runned from the OD Master hosting the ProfileManager.


###Retrieve the code signing certificate 



```
security find-identity -p codesigning
```
You should see something like this.
the **Valid identities only** is what you want.

```
Policy: Code Signing
  Matching identities
  1) 41F20C835F4FCBEB164127DCFBDA8B58259B1169 "Apple Configurator (40:6C:8F:14:E8:4D)" (CSSMERR_TP_INVALID_ANCHOR_CERT)
  2) F62FAAE2A81781A50EE2F334E59B51C0316D783E "dsrv.int.example.com Code Signing Certificate"
     2 identities found

  Valid identities only
  1) F62FAAE2A81781A50EE2F334E59B51C0316D783E "dsrv.int.example.com Code Signing Certificate"
     1 valid identities found

```

###Edit the script SignProfile.sh

Modify the script and edit the variable `ProfileManagerServerCodeSigningCertificate` in **SignProfile.sh**

```
ProfileManagerServerCodeSigningCertificate="dsrv.int.example.com Code Signing Certificate"
```


Then run the script using sudo with 2 parameters :

- $1 input file - the unsigned profile
- $2 output file - the signed profile

```
#make the script executable

chmod +x SignProfile.sh

#move to the folder containing the profiles you want to sign.

cd /path/to/my/ProfilesRepo

#Run the script 
sudo /path/to/the/script/SignProfile.sh jdoe.IMAP.mobileconfig jdoe.IMAP.signed.mobileconfig

```

###Other scripts

**create_iCal_mobileconfig.sh**Create Ical CalDav profile**create_IMAP_mobileconfig.sh**

Create IMAP profile


###Final note

Be aware that password are not encrypted in the profiles.