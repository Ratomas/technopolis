#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if ! [[ -f Techopolis-B9.0-Server.zip ]]; then
	rm -fr config defaultconfigs global_data_packs global_resource_packs mods packmenu Techopolis-*-Server.zip
	curl -o Techopolis-B9.0-Server.zip https://media.forgecdn.net/files/3621/790/Techopolis-B9.0.zip && unzip -u -o Techopolis-B9.0-Server.zip -d /data

	# check for serverstarter jar
	if ! [[ -f serverstarter-2.0.1.jar ]]; then
		# download missing serverstarter jar
		URL="https://github.com/AllTheMods/alltheservers/releases/download/2.0.1/serverstarter-2.0.1.jar"

		if command -v wget &> /dev/null; then
			echo "DEBUG: (wget) Downloading ${URL}"
			wget -O serverstarter-2.0.1.jar "${URL}"
		elif command -v curl &> /dev/null; then
			echo "DEBUG: (curl) Downloading ${URL}"
			curl -o serverstarter-2.0.1.jar "${URL}"
		else
			echo "Neither wget or curl were found on your system. Please install one and try again"
			exit 1
		fi
	fi

fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
if [[ -n "$LEVELTYPE" ]]; then
    sed -i "/level-type\s*=/ c level-type=$LEVELTYPE" /data/server.properties
fi

if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

curl -o log4j2_112-116.xml https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml
java $JVM_OPTS -XX:MaxPermSize=256M -Dlog4j.configurationFile=log4j2_112-116.xml -jar serverstarter-2.0.1.jar nogui
