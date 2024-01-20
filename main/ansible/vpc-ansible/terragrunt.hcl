terraform {
  source = "../../../module/gcp/vpc"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  auto_create_subnetworks = false
  ip_cidr_range           = "192.168.101.0/24"
}