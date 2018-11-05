# Consul Cluster Example 

This folder shows an example of [Terraform](https://www.terraform.io/) code that uses the [consul-cluster](../../modules/consul-cluster) module to deploy a [Consul](https://www.consul.io/) cluster in [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure). The cluster consists of two configurations of [OCI Compute Instances](https://cloud.oracle.com/en_US/infrastructure/compute): one with a small number of Consul server nodes, which are responsible for being part of the [consensus quorum](https://www.consul.io/docs/internals/consensus.html), and one with a larger number of client nodes, which would typically run alongside your apps:

![Consul on Oracle Cloud Infrastructure Architecture](../../_doc/architecture.png)

You will need to create an [OCI Custom Image](https://docs.us-phoenix-1.oraclecloud.com/Content/Compute/Tasks/managingcustomimages.htm) that has Consul installed, which you can do using the [consul-image example](../consul-image). Note that to keep this example simple, both the server and client [OCI Compute Instances](https://cloud.oracle.com/en_US/infrastructure/compute) are running the exact same image. In real-world usage, you'd probably have multiple client OCI Compute Instances, and each of those OCI Compute Instances would run a different image that has the Consul agent installed alongside your apps. 

For more info on how the Consul cluster works, check out the [consul-cluster](../../modules/consul-cluster) documentation. 


## Quick start

To get started, check out the [Terraform provider for Oracle Cloud Infrastructure](https://github.com/oracle/terraform-provider-oci/blob/master/README.md) first.

To deploy a Consul Cluster: 

1. `git clone` this repo to your computer.
1. Build a [Consul](https://www.consul.io/) Image. See the [consul-image example](../consul-image) documentation for instructions. Make sure to note the [OCID](https://docs.us-phoenix-1.oraclecloud.com/Content/General/Concepts/identifiers.htm) of the image.
1. Install [Terraform](https://www.terraform.io/).
1. Create a `terraform.tfvars` file and fill in any other variables that don't have a default, including putting your IMAGE OCID into the `image` variable.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
