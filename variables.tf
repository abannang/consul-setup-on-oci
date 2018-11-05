# ------------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these as environment variables
# ------------------------------------------------------------------------------------------------------------------------

variable "tenancy_id" {
  description = "The OCID of the Oracle Cloud Infrastructure Tenancy."
}

variable "user_id" {
  description = "The OCID of the Oracle Cloud Infrastructure User."
}

variable "fingerprint" {
  description = "The fingerprint of the RSA public key in PEM format (minimum 2048 bits) to access the Oracle Cloud Infrastructure API's."
}

variable "private_key_path" {
  description = "The path to the RSA private key that matches the above fingerprint."
}

variable "region" {
  description = "The Oracle Cloud Infrastructure Region where all resources will be created."
}

variable "compartment_id" {
  description = "The OCID of the Oracle Cloud Infrastructure Compartment where all resources will be created."
}

variable "ssh_public_key" {
  description = "The SSH public key that will be added to SSH authorized_keys on each Oracle Cloud Infrastructure Compute Instance."
}

variable "ssh_private_key" {
  description = "The SSH private key that will be used to make SSH connection to each Oracle Cloud Infrastructure Compute Instance."
}

variable "image" {
  description = "The OCID of the Oracle Cloud Infrastructure Custom Image to run in Consul cluster. Should be a Consul Image that has Consul installed and configured by the install-consul module."
}

# ------------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------------------------------------------------

variable "num_servers" {
  description = "The number of Consul server nodes to deploy. We strongly recommend using 3 or 5."
  default     = 3
}

variable "num_clients" {
  description = "The number of Consul client nodes to deploy. You typically run the Consul client alongside your apps, so set this value to however many Instances make sense for your app code."
  default     = 1
}

variable "cluster_name" {
  description = "The unique name for the Consul cluster. This will be attached to each Oracle Cloud Infrastructure Compute Instance's display name to discover all nodes of the Consul cluster."
  default     = "Consul"
}

variable "server_tag" {
  description = "The tag name for the Consul server nodes. (Example: 'Server'). This will be attached to each Oracle Cloud Infrastructure Compute Instance's display name to discover all server nodes of the Consul cluster."
  default     = "Server"
}

variable "client_tag" {
  description = "The tag name for the Consul client nodes. (Example: 'Client'). This will be attached to each Oracle Cloud Infrastructure Compute Instance's display name to discover all client nodes of the Consul cluster."
  default     = "Client"
}

variable "vcn_cidr_block" {
  description = "The CIDR block of Oracle Cloud Infrastructure VCN."
  default     = "172.16.0.0/16"
}

variable "vcn_dns_label" {
  description = "The DNS label of Oracle Cloud Infrastructure VCN. If not provided, default is 'cluster_name'."
  default     = ""
}
