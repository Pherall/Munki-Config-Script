#!/bin/sh

if [ "$3" == "/" ]; then
    TARGETVOL=""
else
    TARGETVOL="$3"
fi

if [ "$3" == "/" ]; then
	# download and install s3 middleware needed to communicate with s3 bucket
    sudo curl https://raw.githubusercontent.com/waderobson/s3-auth/master/middleware_s3.py -o /usr/local/munki/middleware_s3.py
    sleep 10s
    # set s3 bucket keys, region, and url
    sudo defaults write /Library/Preferences/ManagedInstalls.plist AccessKey 'enter aws access key'
    sudo defaults write /Library/Preferences/ManagedInstalls.plist SecretKey 'enter aws secret key'
    sudo defaults write /Library/Preferences/ManagedInstalls.plist Region 'enter aws s3 bucket region'
    sleep 2s
    sudo defaults write /Library/Preferences/ManagedInstalls.plist SoftwareRepoURL "enter aws s3 bucket url"
	sleep 2s
	# leaving ClientIdentifier blank will make Munki check for serial number of the device
	sudo defaults write /Library/Preferences/ManagedInstalls.plist ClientIdentifier ""
	sleep 2s
	# set Munki not to check for Apple Software Updates
	sudo defaults write /Library/Preferences/ManagedInstalls.plist InstallAppleSoftwareUpdates -bool False
	sleep 2s
	# initial unload of Managed Software Center launchdaemon. This will reload after machine is restarted
	sudo /bin/launchctl unload /Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-check.plist
	sleep 2s
	# create checkandinstallatstartup file that Munki uses to start checking for softares
	touch /Users/Shared/.com.googlecode.munki.checkandinstallatstartup
fi