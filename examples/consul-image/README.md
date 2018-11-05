
# Consul Image

This folder contains a Packer configuration that uses the [install-consul](../../modules/install-consul) and [install-dnsmasq](../../modules/install-dnsmasq) scripts with [Packer](https://www.packer.io/) to create an [Oracle Cloud Infrastructure (OCI) Custom Images (Images)](https://docs.us-phoenix-1.oraclecloud.com/Content/Compute/Tasks/managingcustomimages.htm?Highlight=Image) that has Consul and Dnsmasq installed on top of:

1. Oracle Linux 7.4

This image will have [Consul](https://www.consul.io/) installed and configured to automatically join a cluster during boot-up.  [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) is also installed and configured to use Consul for DNS lookups of the `.consul` domain (e.g. `foo.service.consul`) (see [registering services](https://www.consul.io/intro/getting-started/services.html) for instructions on how to register your services in Consul). To see how to deploy this Image, check out the [consul-cluster example](../../README.md).

For more info on Consul installation and configuration, check out the [install-consul](../../modules/install-consul) and [install-dnsmasq](../../modules/install-dnsmasq) documentation.


## Quick start

To build the Consul OCI Custom Image with Packer

1. `git clone` this repo to your computer.
1. Install [Packer](https://www.packer.io/).
1. Configure your OCI credentials using one of the [options supported by the OCI SDK](https://docs.us-phoenix-1.oraclecloud.com/Content/API/Concepts/sdkconfig.htm). By default the `oracle-oci` Packer builder will use the OCI tenancy, region, user, and credentials configured in your local `$HOME/.oci/config` file.

1. The Packer builder needs to know the target compartment, availability_domain and subnet that will be used for launching the builder image. These options can be set in separate variables file, or passed on the command line. See [Setting Variables](https://www.packer.io/docs/templates/user-variables.html#setting-variables) for information on passing variable into Packer. e.g. create a local `variables.json`

  ```
  {
    "compartment_ocid": "ocid1.compartment.oc1..aaaaaaaaqvxgfapik6ye7eswx7fadmamexvlddc4phkpitrgplvdfzumif4q",
    "availability_domain": "CxvG:PHX-AD-2",
    "subnet_ocid": "ocid1.subnet.oc1.phx.aaaaaaaaafpzojim2qvrjcg7d4bvccyxruvdktzdjrjbnemsrragjdajnzsq"
  }
  ```

1. Run `packer build --var-file="variables.json" consul.json`

When the build finishes it will output the ID of the new image. Save this ID for later use when configuring the Terraform modules to deploy the consul cluster.  The new custom image can also be found in the Custom Images section of the Oracle Cloud Infrastructure console. To see how to deploy one of these Images, check out the [consul-cluster module](../../modules/consul-cluster).


## Creating your own Packer template for production usage

When creating your own Packer template for production usage, you can copy the example in this folder more or less exactly, except for one change: we recommend replacing the `file` provisioner with a call to `git clone` in the `shell` provisioner. Instead of:

```json
{
"provisioners": [{
  "type": "file",
  "source": "{{template_dir}}/../../../terraform-oci-consul",
  "destination": "/tmp"
},{
  "type": "shell",
  "inline": [
    "/tmp/terraform-oci-consul/modules/install-consul/install-consul --consul-version {{user `consul_version`}}",
    "/tmp/terraform-oci-consul/modules/install-dnsmasq/install-dnsmasq"
  ],
  "pause_before": "30s"
}]
}
```

Your code should look more like this:

```json
{
"provisioners": [{
  "type": "shell",
  "inline": [
    "git clone --branch <MODULE_VERSION> https://github.com/hashicorp/terraform-oci-consul.git /tmp/terraform-oci-consul",
    "/tmp/terraform-oci-consul/modules/install-consul/install-consul --consul-version {{user `consul_version`}}",
    "/tmp/terraform-oci-consul/modules/install-dnsmasq/install-dnsmasq"
  ],
  "pause_before": "30s"
}]
}
```
