
build {
  sources = [
    "source.azure-arm.vm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get update"]
  }

  # We use CURL to grab the server download page from Minecraft.net. With this page, we can scan it and make sure we are grabbing the latest download link.
  # This saves time by ensuring the latest version is always downloaded.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install curl"]
  }

  # The wget package is what we will use to download the Minecraft Bedrock server to Ubuntu.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install wget"]
  }

  # This package is the simplest package we are installing and is what we need to extract the server from the downloaded archive.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install unzip"]
  }

  # We use the grep package to extract the correct download link from the page we grabbed using curl.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install grep"]
  }

  # Screen will make accessing the servers command line easier remotely when we run the server as a service.
  # This package allows us to create a detached screen where the Bedrock server will run.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install screen"]
  }

  # The Minecraft Bedrock server requires the OpenSSL library to run.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install openssl"]
  }

  # Used by Azure Files
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install cifs-utils"]
  }

  # Used by BlobFuse
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install build-essential"]
  }

  # Install Blobfuse2
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb",
      "dpkg -i packages-microsoft-prod.deb",
      "apt-get update",
      "apt-get -y install libfuse3-dev fuse3",
      "apt-get -y install blobfuse2"
      ]
  }

  # required by Minecraft Bedrock
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb -O libssl1.1.deb",
      "dpkg -i libssl1.1.deb",
      "rm libssl1.1.deb"
      ]
  }

  # Setup Minecraft User Account
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "useradd -m mcserver",
      "usermod -a -G mcserver $USER",
      "mkdir -p /home/mcserver/minecraft_bedrock"
      ]
  }

  # Download/Install latest version of Minecraft
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "DOWNLOAD_URL=$(curl -H \"Accept-Encoding: identity\" -H \"Accept-Language: en\" -s -L -A \"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)\" https://minecraft.net/en-us/download/server/bedrock/ |  grep -o 'https://minecraft.azureedge.net/bin-linux/[^\"]*')",
      "wget $DOWNLOAD_URL -O /home/mcserver/minecraft_bedrock/bedrock-server.zip",
      "unzip /home/mcserver/minecraft_bedrock/bedrock-server.zip -d /home/mcserver/minecraft_bedrock/",
      "rm /home/mcserver/minecraft_bedrock/bedrock-server.zip",
      "chown -R mcserver: /home/mcserver/"
      ]
  }

  # Minecraft start_server.sh
  provisioner "file" {
    source = "./files/start_server.sh"
    destination = "/tmp/start_server.sh"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/start_server.sh /home/mcserver/minecraft_bedrock/",
      "chmod +x /home/mcserver/minecraft_bedrock/start_server.sh"
    ]
  }

  # Minecraft stop_server.sh
  provisioner "file" {
    source = "./files/stop_server.sh"
    destination = "/tmp/stop_server.sh"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/stop_server.sh /home/mcserver/minecraft_bedrock/",
      "chmod +x /home/mcserver/minecraft_bedrock/stop_server.sh"
    ]
  }

  # Minecraft systemctl service
  provisioner "file" {
    source = "./files/mcbedrock.service"
    destination = "/tmp/mcbedrock.service"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["cp /tmp/mcbedrock.service /etc/systemd/system/"]
  }

  # Minecraft systemctl service environment config
  provisioner "file" {
    source = "./files/mcbedrock.conf"
    destination = "/tmp/mcbedrock.conf"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "mkdir -p /etc/systemd/system/mcbedrock.service.d",
      "cp /tmp/mcbedrock.conf /etc/systemd/system/mcbedrock.service.d/"
      ]
  }  

  # Azure File Share Creds
  provisioner "file" {
    source = "./files/minecraft-fileshare.cred"
    destination = "/tmp/minecraft-fileshare.cred"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "mkdir -p /etc/smbcredentials",
      "cp /tmp/minecraft-fileshare.cred /etc/smbcredentials/"
    ]
  }
  
  # Azure File Share /etc/fstab entry
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "mkdir -p /mount/minecraft-fileshare",
      "echo \"//STORAGE_ACCOUNT_NAME.file.core.windows.net/minecraft /mount/minecraft-fileshare cifs nofail,credentials=/etc/smbcredentials/minecraft-fileshare.cred,serverino,nosharesock,actimeo=30\" | tee -a /etc/fstab > /dev/null"
    ]
  }
  
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["chown -R mcserver: /home/mcserver/"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only = ["azure-arm"]
  }

}