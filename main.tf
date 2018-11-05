# ------------------------------------------------------------------------------------------------------------------------
# DEPLOY A CONSUL CLUSTER IN ORACLE CLOUD INFRASTRUCTURE (OCI)
# These templates show an example of how to use the consul-cluster module to deploy Consul in Oracle Cloud Infrastructure.
# ------------------------------------------------------------------------------------------------------------------------

provider "oci" {
  user_ocid            = "${var.user_id}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.private_key_path}"
  tenancy_ocid         = "${var.tenancy_id}"
  region               = "${var.region}"
  disable_auto_retries = "true"
}

terraform {
  required_version = ">= 0.10.6"
}

# ------------------------------------------------------------------------------------------------------------------------
# CREATE CONSUL SERVERS
# ------------------------------------------------------------------------------------------------------------------------

module "consul-servers" {
  source = "modules/consul-cluster"

  compartment_id       = "${var.compartment_id}"
  availability_domains = ["${data.oci_identity_availability_domains.ADs.availability_domains}"]

  cluster_size = "${var.num_servers}"
  cluster_name = "${var.cluster_name}"
  tag          = "${var.server_tag}"
  image        = "${var.image}"

  ssh_authorized_keys = "${var.ssh_public_key}"
  user_data           = "${base64encode(data.template_file.user_data_server.rendered)}"

  # Provide network details
  vcn_id             = "${oci_core_virtual_network.default.id}"
  dhcp_options_id    = "${oci_core_virtual_network.default.default_dhcp_options_id}"
  route_table_id     = "${oci_core_route_table.default.id}"
  subnet_cidr_blocks = ["${cidrsubnet(var.vcn_cidr_block, 8, 1)}", "${cidrsubnet(var.vcn_cidr_block, 8, 16)}", "${cidrsubnet(var.vcn_cidr_block, 8, 32)}"]

  # To make testing easier, we allow Consul and SSH requests from any IP address here but in a production
  # deployment, we strongly recommend you limit this to the IP address ranges of known, trusted servers inside your VCN.

  allowed_ssh_cidr_blocks     = ["0.0.0.0/0"]
  allowed_ingress_cidr_blocks = ["0.0.0.0/0"]
}

data "template_file" "user_data_server" {
  template = "${file("${path.module}/examples/root-example/user-data-server.sh")}"

  vars {
    # Pass cluster_name for enabling auto join
    cluster_name = "${var.cluster_name}"

    # Pass server_tag for enabling bootstarp_expect
    server_tag = "${var.server_tag}"

    tenancy_ocid = "${var.tenancy_id}"
    region       = "${var.region}"
    user_ocid    = "${var.user_id}"
    fingerprint  = "${var.fingerprint}"
    private_key  = "${file(var.private_key_path)}"
  }
}

# ------------------------------------------------------------------------------------------------------------------------
# CREATE CONSUL CLIENTS
# ------------------------------------------------------------------------------------------------------------------------

module "consul-clients" {
  source = "modules/consul-cluster"

  compartment_id       = "${var.compartment_id}"
  availability_domains = ["${data.oci_identity_availability_domains.ADs.availability_domains}"]

  cluster_size = "${var.num_clients}"
  cluster_name = "${var.cluster_name}"
  tag          = "${var.client_tag}"
  image        = "${var.image}"

  ssh_authorized_keys = "${var.ssh_public_key}"
  user_data           = "${base64encode(data.template_file.user_data_client.rendered)}"

  # Provide network details
  vcn_id             = "${oci_core_virtual_network.default.id}"
  dhcp_options_id    = "${oci_core_virtual_network.default.default_dhcp_options_id}"
  route_table_id     = "${oci_core_route_table.default.id}"
  subnet_cidr_blocks = ["${cidrsubnet(var.vcn_cidr_block, 8, 2)}", "${cidrsubnet(var.vcn_cidr_block, 8, 17)}", "${cidrsubnet(var.vcn_cidr_block, 8, 33)}"]

  # To make testing easier, we allow Consul and SSH requests from any IP address here but in a production
  # deployment, we strongly recommend you limit this to the IP address ranges of known, trusted servers inside your VCN.

  allowed_ssh_cidr_blocks     = ["0.0.0.0/0"]
  allowed_ingress_cidr_blocks = ["0.0.0.0/0"]
}

data "template_file" "user_data_client" {
  template = "${file("${path.module}/examples/root-example/user-data-client.sh")}"

  vars {
    # Pass cluster_name for enabling auto join
    cluster_name = "${var.cluster_name}"

    tenancy_ocid = "${var.tenancy_id}"
    region       = "${var.region}"
    user_ocid    = "${var.user_id}"
    fingerprint  = "${var.fingerprint}"
    private_key  = "${file(var.private_key_path)}"
  }
}

# ------------------------------------------------------------------------------------------------------------------------
# CREATE THE NECESSARY NETWORK RESOURCES FOR CONSUL DEPLOYMENT
# Note: You can choose to use existing vcn, internet gateway and route table. In that case you would need to provide
#       the details that are made available from modules/consul-network/output.tf to other modules.
# ------------------------------------------------------------------------------------------------------------------------

# Refer: https://github.com/oracle/terraform-provider-oci/blob/master/docs/resources/core/virtual_networks.md
resource "oci_core_virtual_network" "default" {
  compartment_id = "${var.compartment_id}"
  display_name   = "${var.cluster_name} VCN"
  cidr_block     = "${var.vcn_cidr_block}"
  dns_label      = "${lower(replace((var.vcn_dns_label != "" ? var.vcn_dns_label : var.cluster_name), " ", ""))}"
}

# Refer: https://github.com/oracle/terraform-provider-oci/blob/master/docs/resources/core/internet_gateway.md
resource "oci_core_internet_gateway" "default" {
  compartment_id = "${var.compartment_id}"
  display_name   = "${var.cluster_name} Internet Gateway"
  vcn_id         = "${oci_core_virtual_network.default.id}"
}

# Refer: https://github.com/oracle/terraform-provider-oci/blob/master/docs/resources/core/route_table.md
resource "oci_core_route_table" "default" {
  compartment_id = "${var.compartment_id}"
  display_name   = "${var.cluster_name} Route Table"
  vcn_id         = "${oci_core_virtual_network.default.id}"

  route_rules {
    cidr_block        = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.default.id}"
  }
}

# ------------------------------------------------------------------------------------------------------------------------
# GET THE LIST OF AVAILABILITY DOMAINS
# ------------------------------------------------------------------------------------------------------------------------
data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_id}"
}
