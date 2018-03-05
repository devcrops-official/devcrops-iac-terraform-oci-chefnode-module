locals {
  default-prov-scripts = [
    "${path.module}/assets/bash-scripts/provisioning-chef_node.sh"
  ]
  
  inst-chef-client_options-merged = "${compact(concat(var.env-chef-default_client_options, var.inst-chef-client_options))}"

  common_tags = {
    operations.display_name = "${var.inst-display_name}"
    operations.hostname = "${var.inst-hostname}"
    operations.ip = "${var.inst-private_ip}"
    operations.chef_environment = "${var.inst-chef-environment}"
    operations.chef_node_name = "${var.inst-chef-node-name}"
    operations.chef_runlist = "${join(",",compact(concat(var.inst-chef-runlist-0, var.inst-chef-runlist-1)))}"
  }



}
