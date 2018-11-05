
# Consul Security List Module

This folder contains a [Terraform](https://www.terraform.io/) module that defines the [Oracle Cloud Infrastructure (OCI) Security List](https://docs.us-phoenix-1.oraclecloud.com/Content/Network/Concepts/securitylists.htm) used by a [Consul](https://www.consul.io/) cluster to control the traffic that is allowed to go in and out of the cluster. Normally, you'd get these rules by default if you're using the [main module](../../README.md), but if you're running Consul on top of a different cluster, then you can use this module to add the necessary security group rules to that cluster. For example: To ensure that other servers have the necessary ports open for using Consul, you can use this module as follows: 


```hcl
module "consul_security_list" {
  # TODO: Update this to the final URL
  source = "git::ssh://git@orahub.oraclecorp.com/pts-cloud-dev/terraform-modules//terraform-oci-consul/modules/consul-security-list"

  compartment_id              = "${var.compartment_ocid}"
  vcn_id                      = "${var.vcn_ocid}"
  allowed_ingress_cidr_blocks = ["${var.allowed_ingress_cidr_blocks}"]

  # ... (other params omitted) ...
}
```

Note the following parameters: 

* `source`: Use this parameter to specify the URL of this module.

You can find the other parameters in [variables.tf](variables.tf). 

Check out the [main module](../../README.md) for working sample code. 

