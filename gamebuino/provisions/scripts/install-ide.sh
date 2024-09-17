#!/bin/sh
# install vscode

#!/bin/bash

#installationDir="/snap/code/current" #SNAP
installationDir=""
launcherDir="/home/ubuntu/Desktop"

function installCode {
	#sudo snap install --classic code # or code-insiders
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	sudo apt -y -q install code

	#prepare config for vscode
	#cat /home/ubuntu/.config/Code/User/settings.json | jq '. |= . + {"http.proxyStrictSSL": false}' > /home/ubuntu/.config/Code/User/settings.json
}

function createCodeDesktopFile {
	
	local codePng="$installationDir/usr/share/code/resources/app/resources/linux/code.png"
	local codeExec="$installationDir/usr/share/code/bin/code"
	
	local launcherCodeDir="$launcherDir/code.desktop"

	echo -e "[Desktop Entry]" >> "$launcherCodeDir"
	echo -e "Type=Application" >> "$launcherCodeDir"
	echo -e "Terminal=false" >> "$launcherCodeDir"
	echo -e "Icon[fr_FR]=$codePng" >> "$launcherCodeDir"
	echo -e "Name[fr_FR]=Vs Code " >> "$launcherCodeDir"
	echo -e "Exec=$codeExec" >> "$launcherCodeDir"
	echo -e "Name=Vs Code " >> "$launcherCodeDir"
	echo -e "Icon=$codePng" >> "$launcherCodeDir"

	echo "$launcherCodeDir created"

	sudo mv -v $launcherCodeDir  /usr/share/applications/code.desktop
}

installCode
createCodeDesktopFile

#https://downloads.arduino.cc/arduino-1.8.19-linux64.tar.xz
