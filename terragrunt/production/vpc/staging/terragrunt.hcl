terraform {
  source = "../../../../module/gcp/vpc"
}

remote_state {
  backend = "gcs"
  config = {
    bucket = "production-asofdevlabs"
    prefix = "terraform/state/vpc/staging"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  auto_create_subnetworks = false
  ip_cidr_range           = "192.168.100.0/24"
}