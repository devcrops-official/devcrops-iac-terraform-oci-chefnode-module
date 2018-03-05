resource "oci_core_instance" "instance" {
  # { Environment - Cloud.
  availability_domain = "${var.env-cloud-availability_domain}"
  compartment_id      = "${var.env-cloud-compartment-id}"
  # }
  display_name = "${var.inst-display_name}"
  shape        = "${var.inst-shape}"

  # { Parameters.
  create_vnic_details {
    assign_public_ip = "${var.inst-assign_public_ip}"
    display_name     = "${var.inst-display_name} - VNIC"
    hostname_label   = "${var.inst-hostname}"
    private_ip       = "${var.inst-private_ip}"
    subnet_id        = "${var.inst-subnet-id}"
  }
  

  source_details {
    source_type = "image"
    source_id = "${var.inst-image-id}"

    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }
  
  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true

  metadata {
    ssh_authorized_keys = "${var.inst-ssh-authorized_keys}"
    user_data           = "${base64encode(file("${path.module}/assets/cloud-init.cfg"))}"
  }

  defined_tags = "${merge(local.common_tags,var.inst-defined_tags)}"

  freeform_tags = "${var.inst-freeform_tags}"

  timeouts {
    create = "${var.inst-creation_timeout}"
  }

  provisioner "remote-exec" {
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
    scripts = "${compact(concat(local.default-prov-scripts, var.inst-prov-scripts))}"
  }
  # }

  lifecycle {
    ignore_changes = [ "metadata" ]
  }
}
