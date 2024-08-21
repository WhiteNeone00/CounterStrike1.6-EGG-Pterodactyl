#!/bin/bash
# ###################################
# Download and install default server
# Variables
REPO_OWNER="oldstyle-community"
REPO_NAME="cstrike_default"

# Get the latest release data
RELEASE_DATA=$(curl -s https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest)

# Extract the tag name and the download URLs for the archives
TAG_NAME=$(echo $RELEASE_DATA | jq -r '.tag_name')

DOWNLOAD_URL=$(echo $RELEASE_DATA | jq -r '.zipball_url')
OUTPUT_FILE="$REPO_NAME-$TAG_NAME.zip"

# Delete file if exists
rm -rf ${REPO_OWNER}-*

# Download the archive
echo "Downloading $OUTPUT_FILE from $DOWNLOAD_URL..."
curl -L -o $OUTPUT_FILE $DOWNLOAD_URL

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Download completed successfully: $OUTPUT_FILE"
else
    echo "Failed to download the archive."
    exit 1
fi

# Unzip the archive
unzip -q -o $REPO_NAME-$TAG_NAME.zip

# Clean
rm -rf $REPO_NAME-*.zip

# Path to server and modules
cd $REPO_OWNER-*
# Install rehlds
echo "Installing rehlds"
mkdir -p rehlds-install && cp -r modules/rehlds/3.13.0.788/rehlds-bin-3.13.0.788_latest.zip rehlds-install

echo "#########################################"
# Rehlds path
cd rehlds-install

# Extract rehlds
unzip -q -o *.zip

# Install rehlds
cp -r bin/linux32/* ../server

# Clean
cd ..
rm -rf rehlds-install
# Install amxmodx
echo "Installing amxmodx"
mkdir -p amxmodx-install && cp -r modules/amxmodx/1.10.0_latest/amxmodx-1.10.0_latest.zip amxmodx-install

echo "#########################################"
# amxmodx path
cd amxmodx-install

# Extract amxmodx
unzip -q -o *.zip

# Install amxmodx
cp -r addons ../server/cstrike

# Clean
cd ..
rm -rf amxmodx-install
# Install ReGameDLL_CS
echo "Installing ReGameDLL_CS"
mkdir -p ReGameDLL_CS-install && cp -r modules/ReGameDLL_CS/5.26.0.668/regamedll-bin-5.26.0.668_latest.zip ReGameDLL_CS-install

echo "#########################################"
# ReGameDLL_CS path
cd ReGameDLL_CS-install

# Extract ReGameDLL_CS
unzip -q -o *.zip

# Install ReGameDLL_CS
cp -r bin/linux32/* ../server

# Clean
cd ..
rm -rf ReGameDLL_CS-install
# Install reapi
echo "Installing reapi"
mkdir -p reapi-install && cp -r modules/reapi/5.24.0.300/reapi-bin-5.24.0.300_latest.zip reapi-install

echo "#########################################"
# reapi path
cd reapi-install

# Extract reapi
unzip -q -o *.zip

# Install reapi
cp -r addons ../server/cstrike

# Add the module
grep -qxF "reapi" ../server/cstrike/addons/amxmodx/configs/modules.ini || echo "reapi" >> ../server/cstrike/addons/amxmodx/configs/modules.ini

# Clean
cd ..
rm -rf reapi-install
# Install metamod-r
echo "Installing metamod-r"
mkdir -p metamod-r-install && cp -r modules/metamod-r/1.3.0.149/metamod-bin-1.3.0.149_latest.zip metamod-r-install

echo "#########################################"
# metamod-r path
cd metamod-r-install

# Extract metamod-r
unzip -q -o *.zip

# Install metamod-r
cp -r addons ../server/cstrike

# Ensure the plugins.ini file exists
touch ../server/cstrike/addons/metamod/plugins.ini

# Add the required line if it doesn't already exist
grep -qxF "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" ../server/cstrike/addons/metamod/plugins.ini || echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" >> ../server/cstrike/addons/metamod/plugins.ini

# Modify liblist.gam to set the new gamedll_linux line
sed -i 's|^gamedll_linux.*|gamedll_linux "addons/metamod/metamod_i386.so"|' ../server/cstrike/liblist.gam || echo 'gamedll_linux "addons/metamod/metamod_i386.so"' >> ../server/cstrike/liblist.gam

# Clean
cd ..
rm -rf metamod-r-install
# Install reunion
echo "Installing reunion"
mkdir -p reunion-install && cp -r modules/reunion/0.2.0.13/reunion-0.2.0.13_latest.zip reunion-install

echo "#########################################"
# reunion path
cd reunion-install

# Extract reunion
unzip -q -o *.zip

# Copy metamod plugin
mkdir -p ../server/cstrike/addons/metamod/reunion/ 
cp -r bin/Linux/* ../server/cstrike/addons/metamod/reunion/

# Add new line in plugins.ini metamod
grep -qxF "linux addons/metamod/reunion/reunion_mm_i386.so" ../server/cstrike/addons/metamod/plugins.ini || echo "linux addons/metamod/reunion/reunion_mm_i386.so" >> ../server/cstrike/addons/metamod/plugins.ini

# Copy config
cp -r reunion.cfg ../server/cstrike

# Generate a random alphanumeric string of length 50
RANDOM_STRING=$(cat /dev/urandom | tr -dc '0-9a-zA-Z' | head -c 50)

# Define the reunion.cfg file path
CONFIG_FILE="../server/cstrike/reunion.cfg"

# Check if the file exists
if [[ -f "$CONFIG_FILE" ]]; then
    # Replace the SteamIdHashSalt line with the new random string
    sed -i "s/^SteamIdHashSalt\s*=.*/SteamIdHashSalt = $RANDOM_STRING/" "$CONFIG_FILE"
    echo "Updated SteamIdHashSalt in $CONFIG_FILE with $RANDOM_STRING"
else
    echo "$CONFIG_FILE does not exist."
fi

# Clean
cd ..
rm -rf reunion-install