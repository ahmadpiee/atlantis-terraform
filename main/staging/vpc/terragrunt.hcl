terraform {
  source = "../../../module/gcp/vpc"
}

remote_state {
  backend = "gcs"
  config = {
    bucket = "production-asofdevlabs"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    credentials = "/etc/atlantis/staging-credentials.json"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  auto_create_subnetworks = false
  ip_cidr_range           = "192.168.92.0/24"
}