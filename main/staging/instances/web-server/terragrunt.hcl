terraform {
  source = "../../../../module/gcp/vpc"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  tags = ["http-server", "https-server"]
  network = "default"
  subnetwork = "default"
}