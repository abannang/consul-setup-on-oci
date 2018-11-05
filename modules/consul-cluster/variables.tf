# ------------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------------------------------------------------

variable "compartment_id" {
  description = "The OCID of the Oracle Cloud Infrastructure Compartment into which Consul resources will be created."
}

variable "availability_domains" {
  description = "The Oracle Cloud Infrastructure Availability Domains across which Consul resources will be created."
  type        = "list"
  default     = []
}

variable "cluster_name" {
  description = "The unique name for the Consul cluster. This will be attached to each Oracle Cloud Infrastructure Compute Instance's display name to discover all nodes of the Consul cluster."
}

variable "tag" {
  description = "The tag name for the Consul cluster nodes. (Example: 'Server'). This will be attached to each Oracle Cloud Infrastructure Compute Instance's display name to discover all server nodes of the Consul cluster."
}

variable "image" {
  description = "The OCID of the Oracle Cloud Infrastructure Custom Image to run in Consul cluster. Should be a Consul Image that has Consul installed and configured by the install-consul module."
}

variable "ssh_authorized_keys" {
  description = "The SSH public keys that will be added to SSH authorized_keys on each Oracle Cloud Infrastructure Compute Instance."
}

variable "user_data" {
  description = "The User Data script to execute while each Oracle Cloud Infrastructure Compute Instance is booting. We recommend passing in a bash script that executes the run-consul script, which should have been installed in the Consul Image by the install-consul module."
}

variable "vcn_id" {
  description = "The OCID of the Oracle Cloud Infrastructure VCN for creating Consul network resources."
}

variable "dhcp_options_id" {
  description = "The OCID of the Oracle Cloud Infrastructure DHCP options to use for each Oracle Cloud Infrastructure Subnet for Consul cluster."
}

variable "route_table_id" {
  description = "The OCID of the Oracle Cloud Infrastructure Route Table to use for each Oracle Cloud Infrastructure Subnet for Consul cluster."
}

variable "subnet_cidr_blocks" {
  description = "The list of CIDR-formatted IP address range within the Oracle Cloud Infrastructure VCN for each Oracle Cloud Infrastructure Subnet in each Availability Domain."
  type        = "list"
  default     = []
}

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which each Oracle Cloud Infrastructure Compute Instance will allow SSH connection."
  type        = "list"
  default     = []
}

variable "allowed_ingress_cidr_blocks" {
  description = "The CIDR-formatted IP address range from which each Oracle Cloud Infrastructure Compute Instance will allow connections to Consul agent."
  type        = "list"
  default     = []
}

# ------------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable default.
# ------------------------------------------------------------------------------------------------------------------------

variable "cluster_size" {
  description = "The number of nodes to have in the Consul cluster. We strongly recommended that you use either 3 or 5."
  default     = 3
}

variable "shape" {
  description = "The shape for the Oracle Cloud Infrastructure Compute Instances. The shape determines the number of CPUs and the amount of memory allocated to the instance."
  default     = "VM.Standard1.2"
}

variable "hostname_label" {
  description = "The hostname label for the Oracle Cloud Infrastructure Compute Instances. If not provided, default is the combination of 'cluster_name' with 'tag'."
  default     = ""
}

variable "assign_public_ip" {
  description = "Specify whether to assign Public IP address to the Oracle Cloud Infrastructure Compute Instances."
  default     = true
}

variable "instance_create_timeout" {
  description = "The amount of time to wait for the Oracle Cloud Infrastructure Compute Instance creation before being considered as an error."
  default     = "60m"
}

variable "subnet_dns_label" {
  description = "The DNS label for Oracle Cloud Infrastructure Subnets to use for Consul cluster. If not provided, default is 'cluster_name'."
  default     = ""
}

variable "server_rpc_port" {
  description = "The port used by Consul servers to handle incoming requests from other Consul agent."
  default     = 8300
}

variable "serf_lan_port" {
  description = "The port used to by all Consul agents to handle gossip in the LAN."
  default     = 8301
}

variable "serf_wan_port" {
  description = "The port used by Consul servers to gossip over the WAN to other Consul server."
  default     = 8302
}

variable "cli_rpc_port" {
  description = "The port used by all Consul agents to handle RPC from the CLI."
  default     = 8400
}

variable "http_api_port" {
  description = "The port used by Consul clients to talk to the HTTP API"
  default     = 8500
}

variable "dns_port" {
  description = "The port used to resolve DNS queries."
  default     = 8600
}

variable "ssh_port" {
  description = "The port used for SSH connections"
  default     = 22
}
