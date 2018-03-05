    #   _____                                     
    #  |  __ \                                    
    #  | |  | | _____   _____ _ __ ___  _ __  ___ 
    #  | |  | |/ _ \ \ / / __| '__/ _ \| '_ \/ __|
    #  | |__| |  __/\ V / (__| | | (_) | |_) \__ \
    #  |_____/ \___| \_/ \___|_|  \___/| .__/|___/
    #                                  | |        
    #                                  |_|     
***

# Manage a Chef Node (Terraform Project).

## Overview

This module does the following:

1. Launch an Instance
2. Provision the Instance running a list of initialization scripts
3. Setup the Instance as a Chef Node.
4. Provision the Node with a first Chef run (if a run-list is provided).
5. Provision the Node with a second Chef run (if a second run-list is provided).
6. Output the public and private IP addresses of the Chef Node.

The Chef runs are strictly ordered.

## Usage

The following is a simple example.

For the list of available parameters see [variables.tf](./variables.tf) file.

```
module "instance" {
  source = "git::ssh://git@github.com/devcrops/devcrops-iac-terraform-oci-chefnode-module.git"
    
  # { Environment - Cloud.
  env-cloud-availability_domain = "..."
  env-cloud-compartment-id = "ocid..."
  # }
  
  # { Environment - Chef.
  env-chef-knife_rb_path = "/home/user/knife.rb"
  env-chef-server-url = "https://chef.myorg.lan/organizations/myorg/" # Mind the trailing slash.
  env-chef-user-key = "${file("/home/user/chef-key.pem")}"
  env-chef-user-name = "chefuser"
  # }

  # { Provisioning - SSH.
  prov-ssh-bastion-private_key = "${file("/home/user/bastion_user.id_rsa")}"
  prov-ssh-bastion-user = "bastion_user"
  prov-ssh-private_key "${file("/home/user/opc.id_rsa")}"
  prov-ssh-user = "opc"
  # }

  # { Parameters - Instance configuration.
  inst-creation_timeout = "10m"
  inst-chef-environment = "env0"
  inst-chef-node-attributes-json = "{ \"a\": 1, \"b\": 2 }"
  inst-chef-node-name = "web0"
  inst-chef-skip_install = false
  inst-chef-runlist-0 = [ "role[base]" ]
  inst-chef-runlist-1 = [ "role[base]", "role[webserver]" ]
  inst-chef-version = "13.4"
  inst-display_name = "Web Server"
  inst-hostname = "web0"
  inst-image-id = "ocid..."
  inst-assign_public_ip = true
  inst-prov-scripts = [ "${path.module}/assets/provision.sh" ]
  inst-ssh-authorized_keys "..."
  inst-subnet-id "ocid..."
  inst-shape = "VM.Standard1.8"
  # }
  }
```

The `inst-chef-allowed_vaults` variable can be used to grant access to one or more
[Chef Vaults](https://github.com/chef/chef-vault).

## Issues

### Chef Server URL with organizations (issue with go-chef).

Chef Server URL is not properly validated.
Related issues:
- [terraform-provider-chef #15](https://github.com/terraform-providers/terraform-provider-chef/issues/15)
- [go-chef #41](https://github.com/go-chef/chef/issues/41)

A **trailing slash must be included** if the URL refers to an organization.

### OSX - Name resolution errors _(GoLang issues?)_.

Name resolution for Chef Server URL uses `localhost` as DNS.

If this is a problem, a local UDP proxy can be setup as a workaround with `socat`, substituting `<dns_server_ip>` with the IP address of a DNS server (e.g. `192.168.170.21`):

```
sudo socat UDP4-RECVFROM:53,fork UDP4-SENDTO:<dns_server_ip>:53
```
