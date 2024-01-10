remote_state {
  backend = "gcs"
  config = {
    bucket = "production-asofdevlabs"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    credentials = "/etc/atlantis/production-credentials.json"
  }
}

inputs = {
  project = "production-410709"
  region = "asia-southeast2"
  zone = "asia-southeast2-a"
  credentials = "/etc/atlantis/production-credentials.json"
  name = "${basename(get_terragrunt_dir())}" // function where terragrunt refer to the name of resource directory
  machine_type = "e2-medium"
}