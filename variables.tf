# { Environment - Cloud.
# ITA: Queste variabili dipendono dall'ambiente Cloud in uso.
variable env-cloud-availability_domain {}
variable env-cloud-compartment-id      {}
# }

# { Environment - Chef.
# ITA: Queste variabili dipendono dall'ambiente Chef in uso.
variable env-chef-server-url             {}
variable env-chef-user-key               {}
variable env-chef-user-name              { default = "provisioner" }
variable env-chef-default_client_options {
  type = "list"
  default = [
    "log_level :info",
    "rubygems_url 'http://artifactory.gbm.lan:8080/artifactory/rubygems_virtual/'"
  ]
}
# }

# { Provisioning - SSH.
# ITA: Queste variabili controllano le connessioni SSH per effettuare il provisioning dell'istanza.
variable prov-ssh-bastion-host        { default = "lxsag812.gbm.lan" }
variable prov-ssh-bastion-port        { default = 22 }
variable prov-ssh-bastion-private_key {}
variable prov-ssh-bastion-user        {}
variable prov-ssh-private_key         {}
variable prov-ssh-user                { default = "opc" }
variable prov-ssh-agent               { default = false }
# }

# { Instance configuration.
# ITA: Parametri di configurazione dell'istanza.
variable inst-chef-client_options { type = "list", default = [] }
variable inst-creation_timeout    { default = "10m" }
variable inst-display_name        { default = "Chef Node" }
variable inst-hostname            { default = "chef-node" }
variable inst-domain            { default = "oci.devops.gbm.lan" }
variable inst-image-id            {}
variable inst-assign_public_ip    { default = false }
variable inst-private_ip          { default = "" }
variable inst-prov-scripts        { type = "list", default = [] }
variable inst-ssh-authorized_keys { default = "" }
variable inst-subnet-id           {}
variable inst-shape               { default = "VM.Standard1.1" }
# }

# { Instance configuration - Chef.
# ITA: Parametri di configurazione dell'istanza specifici per Chef.
variable inst-chef-environment          { default = "_default" }
variable inst-chef-log_to_file          { default = true }
variable inst-chef-node-attributes-json { default = "{}" }
variable inst-chef-node-name            { default = "chef_node" }
variable inst-chef-runlist-0            { type = "list", default = [] }
variable inst-chef-runlist-1            { type = "list", default = [] }
variable inst-chef-skip_install         { default = true }
variable inst-chef-version              { default = "13" }
variable inst-chef-allowed_vaults       { default = "{}" }

variable inst-defined_tags {
  type = "map"

  default = {  }
}

variable inst-freeform_tags {
  type = "map"

  default = {  }
}

# }
