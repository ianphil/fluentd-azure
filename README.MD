# Fluentd and Elasticsearch in Azure

This repository is a walk through for building a container environment in Azure. The following resources are created and configured:

 - A UbuntuLTS VM
 - Latest version of Docker engine via Docker VM Extension
 - Secure Docker endpoint using TLS
 - Fluentd Container with custom config
 - Elasticsearch Container

 *NOTE: For an in-depth explanation, refer to this blogpost: [DOES NOT EXIST YET](http://tripdubroot.com/)

 To get started set the following env vars:

 ```bash
export HOST=<dnsname>.eastus.cloudapp.azure.com
 ```

Entrypoint script:

```bash
sh docker-server.sh
```

## TLS Keys
Keys will be created in folder `keys/`.

## Dependencies

### Microsoft Azure CLI 2.0

A great cloud needs great tools; we're excited to introduce *Azure CLI 2.0*, our next generation multi-platform command line experience for Azure.

#### Installation

```bash
$ curl -L https://aka.ms/InstallAzureCli | bash
```

Please refer to the [install guide](https://docs.microsoft.com/en-us/cli/azure/install-az-cli2) for detailed install instructions.

A list of common install issues and their resolutions are available at [install troubleshooting](https://github.com/Azure/azure-cli/blob/master/doc/install_troubleshooting.md).

## Resources

 - [Microsoft Azure CLI 2.0](https://github.com/Azure/azure-cli)
 - [Azure Virtual Machine Extension for Docker](https://github.com/Azure/azure-docker-extension)
