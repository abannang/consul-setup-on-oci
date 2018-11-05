### Required Keys and OCIDs
### For more information, see https://docs.us-phoenix-1.oraclecloud.com/Content/API/Concepts/apisigningkey.htm

### Tenancy OCID
$env:TF_VAR_tenancy_id="<tenancy OCID>"

### User OCID
$env:TF_VAR_user_id="<user OCID>"

### User RSA public key fingerprint
$env:TF_VAR_fingerprint="<PEM key fingerprint>"

### User RSA private key file path
$env:TF_VAR_private_key_path="<path to the RSA private key that matches the above fingerprint>"

### Region
### For more information, see https://docs.us-phoenix-1.oraclecloud.com/Content/General/Concepts/regions.htm
$env:TF_VAR_region="<region in which to operate, example: us-ashburn-1, us-phoenix-1>"

### Compartment OCID
$env:TF_VAR_compartment_id="<compartment OCID>"

### SSH Public/Private keys used on the instance
### For more information, see https://docs.us-phoenix-1.oraclecloud.com/Content/Compute/Tasks/managingkeypairs.htm
$env:TF_VAR_ssh_public_key = Get-Content <path to public key> -Raw
$env:TF_VAR_ssh_private_key = Get-Content <path to private key> -Raw

### Image OCID of Consul Custom image created using the install-consul module
$env:TF_VAR_image="<image OCID>"
### Check variables are set in PowerShell wth "dir env:"