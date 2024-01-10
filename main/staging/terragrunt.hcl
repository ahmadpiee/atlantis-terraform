remote_state {
  backend = "gcs"
  config = {
    bucket = "staging-asofdevlabs"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    credentials = "/etc/atlantis/staging-credentials.json"
  }
}

inputs = {
  project = "stagging-410708"
  region = "asia-southeast2"
  zone = "asia-southeast2-a"
  credentials = "/etc/atlantis/staging-credentials.json"
  name = "${basename(get_terragrunt_dir())}" // function where terragrunt refer to the name of resource directory
  machine_type = "e2-micro"
}