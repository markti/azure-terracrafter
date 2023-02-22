echo "Storage Account Name: "${storage_account_name}
echo "Storage Account Key: "${storage_account_key}

storageAccountName=${storage_account_name}
storageAccountKey=${storage_account_key}

echo "Storage Account Name: "$storageAccountName
echo "Storage Account Key: "$storageAccountKey

sed -i "/sAZURE_FILES_USERNAME/$storageAccountName" /etc/smbcredentials/minecraft-fileshare.cred
sed -i "/sAZURE_FILES_PASSWORD/$storageAccountKey" /etc/smbcredentials/minecraft-fileshare.cred

sed -i "/sSTORAGE_ACCOUNT_NAME/$storageAccountName" /etc/fstab

sed -i "/slevel-name=Bedrock level/level-name=DEFAULT" /home/mcserver/minecraft_bedrock/server.properties

#systemctl enable mcbedrock