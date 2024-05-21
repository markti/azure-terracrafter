now=`date +"%Y-%m-%d"`
  
DOWNLOAD_URL=$(curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -s -L -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" https://minecraft.net/en-us/download/server/bedrock/ |  grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*')
sudo wget $DOWNLOAD_URL -O bedrock-server.zip

# stop minecraft server
sudo systemctl stop mcbedrock

# backup entire minecraft directory
tar -cvpzf minecraft-full-backup${now}.tar.gz /home/mcserver/minecraft_bedrock
sudo cp minecraft-full-backup${now}.tar.gz /mnt/homenas/minecraft/backups/

# copy config files to temporary backup folder
sudo mkdir /home/mcserver/minecraft_backup${now}
sudo mkdir /home/mcserver/minecraft_backup${now}/worlds
# copy server config file
sudo cp /home/mcserver/minecraft_bedrock/server.properties /home/mcserver/minecraft_backup${now}/
# copy worlds
sudo cp -r /home/mcserver/minecraft_bedrock/worlds /home/mcserver/minecraft_backup${now}/worlds/
# copy allow list
sudo cp /home/mcserver/minecraft_bedrock/allowlist.json /home/mcserver/minecraft_backup${now}/

sudo unzip -o ./bedrock-server.zip -d /home/mcserver/minecraft_bedrock/

# restore server config
sudo cp /home/mcserver/minecraft_backup${now}/server.properties /home/mcserver/minecraft_bedrock/
# restore worlds
sudo cp -r /home/mcserver/minecraft_backup${now}/worlds /home/mcserver/minecraft_bedrock/worlds/
# restore allow list
sudo cp /home/mcserver/minecraft_backup${now}/allowlist.json /home/mcserver/minecraft_bedrock/

sudo chown -R mcserver: /home/mcserver

sudo systemctl start mcbedrock
