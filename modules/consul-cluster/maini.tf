# ------------------------------------------------------------------------------------------------------------------------
# CREATE ORACLE CLOUD INFRASTRUCTURE COMPUTE INSTANCES FOR CONSUL CLUSTER
# REFER: https://github.com/oracle/terraform-provider-oci/blob/master/docs/resources/core/instance.md
# ------------------------------------------------------------------------------------------------------------------------

resource "oci_core_instance" "consul" {
  count = "${var.cluster_size}"

  compartment_id      = "${var.compartment_id}"
  availability_domain = "${lookup(var.availability_domains[count.index % length(var.availability_domains)], "name")}"

  # Build display name that should contain cluster_name and server_tag
  display_name = "${var.cluster_name}-${var.tag}-${format("%02d", count.index + 1)}-${lookup(var.availability_domains[count.index % length(var.availability_domains)], "name")}"
  image        = "${var.image}"
  shape        = "${var.shape}"

  create_vnic_details {
    # Create one Subnet per Availability Domain
    subnet_id = "${element(oci_core_subnet.subnet.*.id, count.index % length(var.availability_domains))}"

    # If hostname_lable is not provided, build one
    hostname_label   = "${var.hostname_label != "" ? var.hostname_label : lower(replace(var.tag, " ", ""))}${count.index + 1}"
    assign_public_ip = "${var.assign_public_ip}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_authorized_keys}"
    user_data           = "${var.user_data}"
  }

  timeouts {
    create = "${var.instance_create_timeout}"
  }
}

# ------------------------------------------------------------------------------------------------------------------------
# CREATE ONE ORACLE CLOUD INFRASTRUCTURE SUBNET PER AVAILABILITY DOMAIN TO DEPLOY COMPUTE INSTANCES
# REFER: https://github.com/oracle/terraform-provider-oci/blob/master/docs/resources/core/subnet.md
# ------------------------------------------------------------------------------------------------------------------------

resource "oci_core_subnet" "subnet" {
  count = "${length(var.availability_domains)}"

  compartment_id      = "${var.compartment_id}"
  availability_domain = "${lookup(var.availability_domains[count.index], "name")}"
  display_name        = "${var.cluster_name}-${var.tag}-Subnet-${count.index + 1}-${lookup(var.availability_domains[count.index], "name")}"

  vcn_id          = "${var.vcn_id}"
  dhcp_options_id = "${var.dhcp_options_id}"
  route_table_id  = "${var.route_table_id}"

  cidr_block = "${var.subnet_cidr_blocks[count.index]}"

  # If dns_label is not provided, build one
  dns_label = "${var.subnet_dns_label != "" ? var.subnet_dns_label : lower(replace("${var.cluster_name}${var.tag}", " ", ""))}${count.index + 1}"

  # Prohibit public IP address based on assign_public_ip
  prohibit_public_ip_on_vnic = "${var.assign_public_ip ? "false" : "true"}"

  # Add Consul Security List OCID and Security List OCIDs passed as parameter
  security_list_ids = ["${concat(module.security_list.ids, oci_core_security_list.allow_ssh_ingress.*.id)}"]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ORACLE CLOUD INFRASTRUCTURE SECURITY LIST TO CONTROL WHAT REQUESTS CAN GO IN AND OUT OF EACH COMPUTE INSTANCE
# REFER: https://github.com/oracle/terraform-provider-oci/blob/master/docs/resources/core/security_list.md
# ---------------------------------------------------------------------------------------------------------------------

resource "oci_core_security_list" "allow_ssh_ingress" {
  count = "${length(var.allowed_ssh_cidr_blocks)}"

  compartment_id = "${var.compartment_id}"
  display_name   = "${var.cluster_name}-${var.tag}-Ingress-SSH-${count.index + 1}"
  vcn_id         = "${var.vcn_id}"

  # Ingress
  ingress_security_rules = [
    {
      # Allow incoming SSH request
      tcp_options {
        "min" = "${var.ssh_port}"
        "max" = "${var.ssh_port}"
      }

      protocol = "6"
      source   = "${var.allowed_ssh_cidr_blocks[count.index]}"
    },
  ]

  # Egress: ALL
  egress_security_rules = [
    {
      protocol    = "6"
      destination = "0.0.0.0/0"
    },
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# THE CONSUL-SPECIFIC INGRESS/EGRESS RULES COME FROM THE CONSUL-SECURITY-LIST MODULE
# ---------------------------------------------------------------------------------------------------------------------

module "security_list" {
  source = "../consul-security-list"

  compartment_id = "${var.compartment_id}"
  display_name   = "${var.cluster_name}-${var.tag}-Ingress"

  vcn_id                      = "${var.vcn_id}"
  allowed_ingress_cidr_blocks = ["${var.allowed_ingress_cidr_blocks}"]

  server_rpc_port = "${var.server_rpc_port}"
  serf_lan_port   = "${var.serf_lan_port}"
  serf_wan_port   = "${var.serf_wan_port}"
  cli_rpc_port    = "${var.cli_rpc_port}"
  http_api_port   = "${var.http_api_port}"
  dns_port        = "${var.dns_port}"
}
