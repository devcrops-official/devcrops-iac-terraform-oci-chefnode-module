# Provision the instance with Chef.

resource "chef_node" "new_chef_node" {

  count = "${(length(var.inst-chef-runlist-0) > 0) ? 1 : 0}"

  name = "${var.inst-chef-node-name}"
  environment_name = "${var.inst-chef-environment}"

  lifecycle {
    ignore_changes = ["run_list", "automatic_attributes_json", "default_attributes_json", "normal_attributes_json", "override_attributes_json"]
  }
}

resource "null_resource" "chef-provisioning-0" {
  depends_on = [
    "oci_core_instance.instance",
    "chef_node.new_chef_node"
  ]

  triggers {
      resources = "chef_node.new_chef_node,oci_core_instance.instance"
  }

  count = "${(length(var.inst-chef-runlist-0) > 0) ? 1 : 0}"

  connection {
      bastion_host        = "${var.prov-ssh-bastion-host}"
      bastion_port        = "${var.prov-ssh-bastion-port}"
      bastion_private_key = "${var.prov-ssh-bastion-private_key}"
      bastion_user        = "${var.prov-ssh-bastion-user}"
      host                = "${oci_core_instance.instance.private_ip}"
      private_key         = "${var.prov-ssh-private_key}"
      script_path         = "/home/${var.prov-ssh-user}/provision.sh"
      type                = "ssh"
      agent               = "${var.prov-ssh-agent}"
      user                = "${var.prov-ssh-user}"
    }
  
  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
    inline = [
      "printf '# Created by cloud-init on instance boot automatically, do not edit.\n# Added HOSTNAME by Terraform (https://git.gbm.lan/bmed-iac-terraform/bmed-iac-terraform-oci-chefnode-module) \n#\nNETWORKING=yes\nHOSTNAME=${var.inst-hostname}.${var.inst-domain}\n' | sudo tee /etc/sysconfig/network",
      "printf 'PRESERVE_HOSTINFO=2\n' | sudo tee /etc/oci-hostname.conf",
      "echo '${var.inst-private_ip} ${var.inst-hostname}.${var.inst-domain} ${var.inst-hostname}' | sudo tee --append /etc/hosts"
    ]
  }

  provisioner "chef" {
    

    attributes_json = "${var.inst-chef-node-attributes-json}"
    client_options  = "${local.inst-chef-client_options-merged}"
    environment     = "${var.inst-chef-environment}"
    log_to_file     = "${var.inst-chef-log_to_file}"
    node_name       = "${var.inst-chef-node-name}"
    recreate_client = true
    run_list        = "${var.inst-chef-runlist-0}"
    server_url      = "${var.env-chef-server-url}"
    skip_install    = "${var.inst-chef-skip_install}"
    skip_register   = false
    ssl_verify_mode = ":verify_none"
    user_key        = "${var.env-chef-user-key}"
    user_name       = "${var.env-chef-user-name}"
    vault_json      = "${var.inst-chef-allowed_vaults}"
    version         = "${var.inst-chef-version}"
  }
}

resource "null_resource" "chef-provisioning-1" {
  depends_on = [
    "null_resource.chef-provisioning-0"
  ]

  triggers {
    resources = "null_resource.chef-provisioning-0"
  }

  count = "${(length(var.inst-chef-runlist-1) > 0) ? 1 : 0}"

  connection {
      bastion_host        = "${var.prov-ssh-bastion-host}"
      bastion_port        = "${var.prov-ssh-bastion-port}"
      bastion_private_key = "${var.prov-ssh-bastion-private_key}"
      bastion_user        = "${var.prov-ssh-bastion-user}"
      host                = "${oci_core_instance.instance.private_ip}"
      private_key         = "${var.prov-ssh-private_key}"
      script_path         = "/home/${var.prov-ssh-user}/provision.sh"
      type                = "ssh"
      agent               = "${var.prov-ssh-agent}"
      user                = "${var.prov-ssh-user}"
    }
    
  provisioner "chef" {
    connection {
      bastion_host        = "${var.prov-ssh-bastion-host}"
      bastion_port        = "${var.prov-ssh-bastion-port}"
      bastion_private_key = "${var.prov-ssh-bastion-private_key}"
      bastion_user        = "${var.prov-ssh-bastion-user}"
      host                = "${oci_core_instance.instance.private_ip}"
      private_key         = "${var.prov-ssh-private_key}"
      script_path         = "/home/${var.prov-ssh-user}/provision.sh"
      type                = "ssh"
      user                = "${var.prov-ssh-user}"
      agent               = "${var.prov-ssh-agent}"
    }

    attributes_json = "${var.inst-chef-node-attributes-json}"
    client_options  = "${local.inst-chef-client_options-merged}"
    environment     = "${var.inst-chef-environment}"
    log_to_file     = "${var.inst-chef-log_to_file}"
    node_name       = "${var.inst-chef-node-name}"
    recreate_client = false
    run_list        = "${var.inst-chef-runlist-1}"
    server_url      = "${var.env-chef-server-url}"
    skip_install    = true
    skip_register   = true
    ssl_verify_mode = ":verify_none"
    user_key        = "${var.env-chef-user-key}"
    user_name       = "${var.env-chef-user-name}"
    vault_json      = "${var.inst-chef-allowed_vaults}"
    version         = "${var.inst-chef-version}"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
    inline = [
      "echo '127.0.0.1 127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4' | sudo tee /etc/hosts",
      "echo '::1 localhost localhost.localdomain localhost6 localhost6.localdomain6' | sudo tee --append /etc/hosts",
      "echo '${var.inst-private_ip} ${var.inst-hostname}.${var.inst-domain} ${var.inst-hostname}' | sudo tee --append /etc/hosts"
    ]
  }
}

