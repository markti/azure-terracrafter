
build {
  sources = [
    "source.azure-arm.vm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get update",
      "apt-get clean"
    ]
  }

  # install Azure CLI
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "curl -sL https://aka.ms/InstallAzureCLIDeb | bash"
    ]
  }

  # We use CURL to grab the server download page from Minecraft.net. With this page, we can scan it and make sure we are grabbing the latest download link.
  # This saves time by ensuring the latest version is always downloaded.
  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["apt-get -y install curl"]
  }

  # The wget package is what we will use to download the Minecraft Java server to Ubuntu.
  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["apt-get -y install wget"]
  }

  # This package is the simplest package we are installing and is what we need to extract the server from the downloaded archive.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get update",
      "apt-get -y install unzip"
    ]
  }

  # We use the grep package to extract the correct download link from the page we grabbed using curl.
  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["apt-get -y install grep"]
  }

  # Screen will make accessing the servers command line easier remotely when we run the server as a service.
  # This package allows us to create a detached screen where the Java server will run.
  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["apt-get -y install screen"]
  }

  # The Minecraft Java server requires the OpenSSL library to run.
  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["apt-get -y install openssl"]
  }

  # JRE
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "add-apt-repository ppa:openjdk-r/ppa",
      "apt-get update",
      "apt-get -y install openjdk-21-jdk"
    ]
  }

  # Setup Minecraft User Account
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "useradd -m mcserver",
      "usermod -a -G mcserver $USER",
      "mkdir -p /home/mcserver/${local.server_folder_name}"
    ]
  }

  # required by Minecraft Java 1.21.1.jar
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "DOWNLOAD_URL=https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar",
      "wget $DOWNLOAD_URL -O /home/mcserver/${local.server_folder_name}/server.jar",
      "chown -R mcserver: /home/mcserver/"
    ]
  }

  # Minecraft start_server.sh
  provisioner "file" {
    source      = "./files/start_server.sh"
    destination = "/tmp/start_server.sh"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/start_server.sh /home/mcserver/${local.server_folder_name}/",
      "chmod +x /home/mcserver/${local.server_folder_name}/start_server.sh"
    ]
  }

  # Minecraft stop_server.sh
  provisioner "file" {
    source      = "./files/stop_server.sh"
    destination = "/tmp/stop_server.sh"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/stop_server.sh /home/mcserver/${local.server_folder_name}/",
      "chmod +x /home/mcserver/${local.server_folder_name}/stop_server.sh"
    ]
  }

  # Minecraft systemctl service
  provisioner "file" {
    source      = "./files/${local.service_name}.service"
    destination = "/tmp/${local.service_name}.service"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["cp /tmp/${local.service_name}.service /etc/systemd/system/"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["chown -R mcserver: /home/mcserver/"]
  }

  # start the Minecraft server to generate initial files
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "systemctl enable mcjava",
      "systemctl start mcjava",
      "sleep 60",
      "systemctl stop mcjava",
      "systemctl disable mcjava"
    ]
  }

  # Minecraft EULA
  provisioner "file" {
    source      = "./files/eula.txt"
    destination = "/tmp/eula.txt"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/eula.txt /home/mcserver/${local.server_folder_name}/"
    ]
  }

  # Minecraft Server Properties
  provisioner "file" {
    source      = "./files/server.properties"
    destination = "/tmp/server.properties"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/server.properties /home/mcserver/${local.server_folder_name}/"
    ]
  }

  # Minecraft Ops file
  provisioner "file" {
    source      = "./files/ops.json"
    destination = "/tmp/ops.json"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/ops.json /home/mcserver/${local.server_folder_name}/"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["chown -R mcserver: /home/mcserver/"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}