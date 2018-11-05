output "ids" {
  description = "The OCID of the security list for Consul cluster."
  value       = ["${oci_core_security_list.allowed_ingress.*.id}"]
}
