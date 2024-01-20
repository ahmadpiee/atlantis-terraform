remote_state {
  backend = "gcs"
  config = {
    bucket = "ansible-devlabs"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    credentials = "/etc/atlantis/devlabs-creds.json"
  }
}

inputs = {
  project = "level-district-407913"
  region = "asia-southeast2"
  zone = "asia-southeast2-a"
  credentials = "/etc/atlantis/devlabs-creds.json"
  name = "${basename(get_terragrunt_dir())}" // function where terragrunt refer to the name of resource directory
  machine_type = "e2-medium"
}