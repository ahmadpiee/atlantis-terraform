terraform {
  source = "../../../module/gcp/instances"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  tags = ["http-server", "https-server"]
  network = "vpc-ansible"
}