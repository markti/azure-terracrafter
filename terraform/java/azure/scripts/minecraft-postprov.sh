systemctl enable mcjava
systemctl start mcjava
# Define the new RCON password
NEW_PASSWORD="$minecraft_password"
# File to be modified
FILE_PATH="/home/mcserver/minecraft_java/server.properties"
# Use sed to replace the line
sed -i "s/^rcon\.password=REPLACE_ME$/rcon.password=$NEW_PASSWORD/" "$FILE_PATH"