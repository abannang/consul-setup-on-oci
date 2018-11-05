#!/usr/bin/env bash
#
# This script is meant to be run in the User Data of each OCI Custom Instance
# while it's booting. The script uses the run-consul script to configure and 
# start Consul in server mode.
#

# Set bash options
set -e

# Run Consul
/opt/consul/bin/run-consul --server --cluster-name "${cluster_name}" --server-tag "${server_tag}" --oci-tenancy-ocid "${tenancy_ocid}" --oci-region "${region}" --oci-user-ocid "${user_ocid}" --oci-fingerprint "${fingerprint}" --oci-private-key "${private_key}"
