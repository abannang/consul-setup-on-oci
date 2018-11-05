# ------------------------------------------------------------------------------------------------------------------------
# CREATE ORACLE CLOUD INFRASTRUCTURE SECURITY LIST THAT CONTROLS WHAT TRAFFIC CAN GO IN AND OUT OF A CONSUL CLUSTER
# REFER: https://github.com/oracle/terraform-provider-oci/blob/master/docs/resources/core/security_list.md
# ------------------------------------------------------------------------------------------------------------------------

resource "oci_core_security_list" "allowed_ingress" {
  count = "${length(var.allowed_ingress_cidr_blocks)}"

  compartment_id = "${var.compartment_id}"
  display_name   = "${var.display_name}-${count.index + 1}"
  vcn_id         = "${var.vcn_id}"

  # Ingress
  ingress_security_rules = [
    {
      # Allow incoming requests from other Consul agents
      tcp_options {
        "min" = "${var.server_rpc_port}"
        "max" = "${var.server_rpc_port}"
      }

      protocol = "6"
      source   = "${var.allowed_ingress_cidr_blocks[count.index]}"
    },
    {
      # Allow gossip in the LAN
      tcp_options {
        "min" = "${var.serf_lan_port}"
        "max" = "${var.serf_lan_port}"
      }

      protocol = "6"
      source   = "${var.allowed_ingress_cidr_blocks[count.index]}"
    },
    {
      # Allow gossip over the WAN
      tcp_options {
        "min" = "${var.serf_wan_port}"
        "max" = "${var.serf_wan_port}"
      }

      protocol = "6"
      source   = "${var.allowed_ingress_cidr_blocks[count.index]}"
    },
    {
      # Allow HTTP API
      tcp_options {
        "min" = "${var.http_api_port}"
        "max" = "${var.http_api_port}"
      }

      protocol = "6"
      source   = "${var.allowed_ingress_cidr_blocks[count.index]}"
    },
    {
      # Allow RPC from the CLI
      tcp_options {
        "min" = "${var.cli_rpc_port}"
        "max" = "${var.cli_rpc_port}"
      }

      protocol = "6"
      source   = "${var.allowed_ingress_cidr_blocks[count.index]}"
    },
    {
      # Allow DNS queries
      tcp_options {
        "min" = "${var.dns_port}"
        "max" = "${var.dns_port}"
      }

      protocol = "6"
      source   = "${var.allowed_ingress_cidr_blocks[count.index]}"
    },
  ]

  # Egress: ALL
  egress_security_rules = [
    {
      # TCP
      protocol    = "6"
      destination = "0.0.0.0/0"
    },
    {
      # UDP
      protocol    = "17"
      destination = "0.0.0.0/0"
    },
  ]
}
