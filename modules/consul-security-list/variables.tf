# ------------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------------------------------------------------

variable "compartment_id" {
  description = "The OCID of the Oracle Cloud Infrastructure Compartment in which to create Oracle Cloud Infrastructure Security List for Consul cluster."
}

variable "display_name" {
  description = "The display name for the Oracle Cloud Infrastructure Security List for Consul cluster."
  default     = "Consul"
}

variable "vcn_id" {
  description = "The OCID of the Oracle Cloud Infrastructure VCN in which to create Oracle Cloud Infrastructure Security List for Consul cluster."
}

variable "allowed_ingress_cidr_blocks" {
  description = "The CIDR-formatted IP address range from which each Oracle Cloud Infrastructure Compute Instance will allow connections to Consul agent."
  type        = "list"
  default     = []
}

# ------------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------------------------------------------------

variable "server_rpc_port" {
  description = "The port used by Consul servers to handle incoming requests from other Consul agents."
  default     = 8300
}

variable "serf_lan_port" {
  description = "The port used to by all Consul agents to handle gossip in the LAN."
  default     = 8301
}

variable "serf_wan_port" {
  description = "The port used by Consul servers to gossip over the WAN to other Consul servers."
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
