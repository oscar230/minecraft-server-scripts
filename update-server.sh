#!/bin/bash

VERSION_MANIFEST_URL=https://launchermeta.mojang.com/mc/game/version_manifest.json
SERVER_JAR_FILENAME=server.jar

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

if ! command -v sha1sum &> /dev/null
then
    echo "sha1sum could not be found"
    exit
fi

VERSION_MANIFEST=$(curl -s $VERSION_MANIFEST_URL)
LATEST_RELEASE=$(echo $VERSION_MANIFEST | jq ".latest.release")
LATEST_RELEASE=$(echo $VERSION_MANIFEST | jq ".versions[] | select(.id==$LATEST_RELEASE)")
LATEST_RELEASE=$(echo $LATEST_RELEASE | jq ".url" | sed 's/"//g')
LATEST_RELEASE=$(curl -s $LATEST_RELEASE)
LATEST_RELEASE_SERVER_SHA1=$(echo $LATEST_RELEASE | jq ".downloads.server.sha1" | sed 's/"//g')
LATEST_RELEASE_SERVER_URL=$(echo $LATEST_RELEASE | jq ".downloads.server.url" | sed 's/"//g')
LATEST_RELEASE_SERVER_VERSION=$(echo $LATEST_RELEASE | jq ".id" | sed 's/"//g')

if [ -f "$SERVER_JAR_FILENAME" ];
then
    CURRENT_SHA1=$(sha1sum $SERVER_JAR_FILENAME | awk '{ print $1 }')
    if [ $CURRENT_SHA1 = $LATEST_RELEASE_SERVER_SHA1 ]; then 
        echo "The $SERVER_JAR_FILENAME is already updated to version $LATEST_RELEASE_SERVER_VERSION." 
    else
        echo "The $SERVER_JAR_FILENAME is not updated, will update now..."
        rm -f $SERVER_JAR_FILENAME
        curl --output "$SERVER_JAR_FILENAME" -s "$LATEST_RELEASE_SERVER_URL"
        echo "Updated $SERVER_JAR_FILENAME to version $LATEST_RELEASE_SERVER_VERSION"
    fi;
else 
    echo "The $SERVER_JAR_FILENAME does not exist, will get the latest release now."
    curl --output "$SERVER_JAR_FILENAME" -s "$LATEST_RELEASE_SERVER_URL"
    echo "Updated $SERVER_JAR_FILENAME to version $LATEST_RELEASE_SERVER_VERSION"
fi
