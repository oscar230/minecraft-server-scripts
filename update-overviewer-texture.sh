#!/bin/bash

VERSION_MANIFEST_URL=https://launchermeta.mojang.com/mc/game/version_manifest.json

if ! command -v curl &> /dev/null
then
    echo "curl could not be found"
    exit
fi

if ! command -v jq &> /dev/null
then
    echo "jq could not be found"
    exit
fi

if ! command -v wget &> /dev/null
then
    echo "wget could not be found"
    exit
fi

VERSION_MANIFEST=$(curl -s $VERSION_MANIFEST_URL)
VERSION=$(echo $VERSION_MANIFEST | jq ".latest.release" | sed 's/"//g')
TEXTURE_FILE=texture-${VERSION}.jar
TEXTURE_FILE_LINK=texture-latest.jar

if [ -f "$TEXTURE_FILE" ];
then
    echo "The $TEXTURE_FILE_LINK is up to date at version $VERSION."
else 
    echo "The $TEXTURE_FILE does not exist, will get the latest release now."
    wget https://overviewer.org/textures/${VERSION} -O "$TEXTURE_FILE"
    echo "Updated $TEXTURE_FILE to version $VERSION"
fi

ln -f -s $TEXTURE_FILE $TEXTURE_FILE_LINK
