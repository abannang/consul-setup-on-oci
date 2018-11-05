# Consul for Oracle Cloud Infrastructure (OCI)

This folder contains a [Terraform](https://www.terraform.io/) module to deploy a [Consul](https://www.consul.io/) cluster on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure). Consul is a distributed, highly-available tool that you can use for service discovery and key/value storage. A Consul cluster typically includes a small number of server nodes, which are responsible for being part of the [consensus quorum](https://www.consul.io/docs/internals/consensus.html), and a larger number of client nodes, which you typically run alongside your apps.

![Consul on Oracle Cloud Infrastructure Architecture](_doc/architecture.png)


## Quick start

The example in this folder deploys two configurations of [OCI Compute Instances](https://cloud.oracle.com/en_US/infrastructure/compute) using the [consul-cluster module](modules/consul-cluster): one with a small number of Consul server nodes and one with a larger number of client nodes.

You will need to create an [OCI Custom Image](https://docs.us-phoenix-1.oraclecloud.com/Content/Compute/Tasks/managingcustomimages.htm) that has Consul installed, which you can do using the [consul-image example](examples/consul-image). Note that to keep this example simple, both the server and client [OCI Compute Instances](https://cloud.oracle.com/en_US/infrastructure/compute) are running the exact same image. In real-world usage, you'd probably have multiple client OCI Compute Instances, and each of those OCI Compute Instances would run a different image that has the Consul agent installed alongside your apps. 

For more info on how the Consul cluster works, check out the [consul-cluster documentation](modules/consul-cluster). 

To get started, check out the [Terraform provider for Oracle Cloud Infrastructure](https://github.com/oracle/terraform-provider-oci/blob/master/README.md) first.

To deploy a Consul Cluster: 

1. `git clone` this repo to your computer.
1. Build a [Consul](https://www.consul.io/) Image. See the [consul-image example](examples/consul-image) documentation for instructions. Make sure to note the [OCID](https://docs.us-phoenix-1.oraclecloud.com/Content/General/Concepts/identifiers.htm) of the image.
1. Install [Terraform](https://www.terraform.io/).
1. Create a `terraform.tfvars` file and fill in any other variables that don't have a default, including putting your IMAGE OCID into the `image` variable.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.


## How to use this Module

* [root](./): This folder shows an example of [Terraform](https://www.terraform.io/) code that uses the [consul-cluster module](modules/consul-cluster) to deploy a [Consul](https://www.consul.io/) cluster in [Oracle Cloud Infrastructure](https://cloud.oracle.com/en_US/cloud-infrastructure/).
* [modules](./modules): This folder contains the reusable code for this Module, broken down into one or more modules.
* [examples](./examples): This folder contains examples of how to use the modules.

To deploy Consul servers using this Module:

1. Create a Consul [OCI Custom Image](https://docs.us-phoenix-1.oraclecloud.com/Content/Compute/Tasks/managingcustomimages.htm) using a [Packer](https://www.packer.io/) template that references the [install-consul module](modules/install-consul). Here is an [example Packer template](examples/consul-image/README.md#quick-start).

1. Deploy that Consul [OCI Custom Image](https://docs.us-phoenix-1.oraclecloud.com/Content/Compute/Tasks/managingcustomimages.htm) across [OCI Compute Instances](https://cloud.oracle.com/en_US/infrastructure/compute) using the Terraform [consul-cluster module](modules/consul-cluster) and execute the [run-consul script](modules/run-consul) with the `--server` flag during boot on each OCI Compute Instance to form the Consul cluster.

To deploy Consul clients using this Module:

1. Use the [install-consul module](modules/install-consul) to install Consul alongside your application code.
1. Before booting your app, execute the [run-consul script](modules/run-consul) with `--client` flag.
1. Your app can now use the local Consul agent for service discovery and key/value storage.
1. Optionally, you can use the [install-dnsmasq module](modules/install-dnsmasq) to configure Consul as the DNS for a specific domain (e.g. `.consul`) so that URLs such as `foo.service.consul` resolve automatically to the IP address(es) for a service `foo` registered in Consul (all other domain names will continue to resolve using the default resolver on the OS).


## What's a Module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such as a database or server cluster. Each Module is created using [Terraform](https://www.terraform.io/), and includes automated tests, examples, and documentation. It is maintained both by the open source community and companies that provide commercial support.

Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, you can leverage the work of the Module community to pick up infrastructure improvements through a version number bump.


## Code included in this Module:

* [install-consul](modules/install-consul): This module installs Consul using a [Packer](https://www.packer.io/) template to create a Consul [OCI Custom Image](https://docs.us-phoenix-1.oraclecloud.com/Content/Compute/Tasks/managingcustomimages.htm).

* [consul-cluster](modules/consul-cluster): The module includes Terraform code to deploy a Consul Image across [OCI Compute Instances](https://cloud.oracle.com/en_US/infrastructure/compute).

* [run-consul](modules/run-consul): This module includes the scripts to configure and run Consul. It is used by the [consul-cluster module](modules/consul-cluster) at runtime to set configurations  as part of [User Data](http://cloudinit.readthedocs.io/en/latest/topics/format.html) to form a Consul cluster.

* [consul-security-list](modules/consul-security-list): This module defines the [Security Lists](https://docs.us-phoenix-1.oraclecloud.com/Content/Network/Concepts/securitylists.htm) used by a Consul cluster to control the traffic that is allowed to go in and out of the cluster.

* [install-dnsmasq](modules/install-dnsmasq): This module installs [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) and configures it to forward requests for a specific domain to Consul. This allows you to use Consul as a DNS server for URLs such as `foo.service.consul`.


## Who maintains this Module?

This Module is maintained by [Oracle PTS Team](https://orahub.oraclecorp.com/pts-cloud-dev/). If you're looking for help, send an email to [arun.saral@oracle.com](mailto:modules@gruntwork.io?Subject=Consul%20Module).
