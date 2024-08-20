# amxmodx path
cd amxmodx-install

# Extract amxmodx
unzip -q -o *.zip

# Install amxmodx
cp -r * ../server/cstrike

# Clean
cd ..
rm -rf amxmodx-install