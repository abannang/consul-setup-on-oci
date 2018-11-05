output "region" {
  value = "${var.region}"
}

output "num_servers" {
  value = "${length(module.consul-servers.ids)}"
}

output "servers_ids" {
  description = "OCIDs of the Consul servers."
  value       = ["${module.consul-servers.ids}"]
}

output "servers_public_ips" {
  description = "Public IP address of the Consul servers."
  value       = ["${module.consul-servers.public_ips}"]
}

output "servers_private_ips" {
  description = "Private IP address of the Consul servers."
  value       = ["${module.consul-servers.private_ips}"]
}

output "num_clients" {
  value = "${length(module.consul-clients.ids)}"
}

output "clients_ids" {
  description = "OCIDs of the Consul clients."
  value       = ["${module.consul-clients.ids}"]
}

output "clients_public_ips" {
  description = "Public IP address of the Consul clients."
  value       = ["${module.consul-clients.public_ips}"]
}

output "clients_private_ips" {
  description = "Private IP address of the Consul clients."
  value       = ["${module.consul-clients.private_ips}"]
}
