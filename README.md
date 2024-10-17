# Azure Terracrafter

Azure Terracrafter is a demonstration of how to implement Infrastructure-as-Code (IaC) using Packer and Terraform across multiple control planes, including both Azure and Minecraft. This project showcases the power of immutable infrastructure by using Packer to create golden images for Minecraft servers (Java and Bedrock Editions), while Terraform provisions the necessary infrastructure on Azure. Through this example, you'll learn how to automate server setup and configuration, and manage multiple control planes in Terraform by extending automation to in-game configuration using the Minecraft Terraform provider.

## Repository Structure

This repository contains Packer templates and Terraform root modules for automating the setup and provisioning of Minecraft servers (Java Edition and Bedrock Edition) on Azure. The solution leverages Packer to build golden images for both Minecraft variants and Terraform to provision the required infrastructure.

### Packer Templates

The Packer templates build the images used to deploy Minecraft servers. These templates are organized as follows:

- **packer/minecraft/java/local**  
  Builds a golden image for Minecraft Java Edition, storing game data locally on the server.
  
- **packer/minecraft/bedrock/local**  
  Builds a golden image for Minecraft Bedrock Edition, storing game data locally on the server.
  
- **packer/minecraft/bedrock/blobfuse**  
  Builds a golden image for Minecraft Bedrock Edition, using Azure Blob Storage via BlobFuse for external storage.

### Terraform Root Modules

The Terraform root modules provision the infrastructure for the Minecraft servers and additional in-game content:

- **terraform/bedrock/azure**  
  Provisions the Minecraft Bedrock Edition server infrastructure on Azure.

- **terraform/java/azure**  
  Provisions the Minecraft Java Edition server infrastructure on Azure.

- **terraform/java/minecraft**  
  Provisions a house in the Minecraft Java Edition server using the Terraform Minecraft provider.

## Solution Overview

This solution uses Packer to create golden images for Minecraft Java and Bedrock servers. Terraform is then used to provision the necessary infrastructure on Azure. 

### Minecraft Java Edition (with RCON support)

The Minecraft Java Edition supports **RCON**, a technology that allows for remote command execution on the Minecraft server. This is leveraged by the Terraform Minecraft provider, enabling automation of in-game actions like provisioning structures.

- **RCON Port**: 25575
- **Public IP Address**: Required for connecting Terraform to the Minecraft server

Due to the RCON support in Minecraft Java Edition, the demo showcasing **Terraform Stacks** (which involve using multiple root modules manually) is done using the Java Edition server.

### Minecraft Bedrock Edition

Unfortunately, Minecraft Bedrock Edition does not support RCON, and thus, the Terraform Minecraft provider cannot interact with the server directly in the same way as it does with Java Edition. However, the Bedrock servers can still be provisioned and managed through Terraform for infrastructure needs.

## Getting Started

To get started with provisioning the Minecraft servers:

1. Clone this repository.
2. Build the golden image for the desired Minecraft version using the Packer templates.
3. Use the Terraform root modules to provision the server infrastructure on Azure.


## Connecting to the Minecraft Server on Nintendo Switch and Xbox

To connect your Nintendo Switch or Xbox to the Minecraft server provisioned with Azure Terracrafter, you can override the DNS configuration on your device. Follow these steps to manually configure the DNS settings:

1. **Navigate to Network Settings** on your Nintendo Switch or Xbox.
2. Select **Manual Configuration** for DNS.
3. Enter either the following DNS addresses:
   - **Primary DNS**: `104.238.130.180`
   - **Secondary DNS**: `8.8.8.8`
4. Save the changes and restart your device.

This DNS setup will allow you to connect to your custom Minecraft Bedrock server hosted on Azure. Ensure your server is running and accessible for the connection to succeed.

## Other Resources

blobfuse2
https://github.com/Azure/azure-storage-fuse
https://learn.microsoft.com/en-us/azure/storage/blobs/blobfuse2-how-to-deploy

minecraft ubuntu install
https://pimylifeup.com/ubuntu-minecraft-bedrock-server/