#!/usr/bin/env bash
#
# This script is meant to be run in the User Data of each OCI Custom Instance
# while it's booting. The script uses the run-consul script to configure and 
# start Consul in server mode.
#

# Set bash options
set -e

# Run Consul
/opt/consul/bin/run-consul --client --cluster-name "${cluster_name}" --oci-tenancy-ocid "${tenancy_ocid}" --oci-region "${region}" --oci-user-ocid "${user_ocid}" --oci-fingerprint "${fingerprint}" --oci-private-key "${private_key}"

# You could add commands to boot your other apps here