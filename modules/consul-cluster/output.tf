output "ids" {
  description = "OCIDs of the OCI instances in Consul cluster."
  value       = ["${oci_core_instance.consul.*.id}"]
}

output "public_ips" {
  description = "Public IP addresses of the OCI instances in Consul cluster."
  value       = ["${oci_core_instance.consul.*.public_ip}"]
}

output "private_ips" {
  description = "Private IP addresses of the OCI instances in Consul cluster."
  value       = ["${oci_core_instance.consul.*.private_ip}"]
}
