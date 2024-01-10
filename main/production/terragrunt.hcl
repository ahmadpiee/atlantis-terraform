inputs = {
  project = "production-410709"
  region = "asia-southeast2"
  zone = "asia-southeast2-a"
  credentials = "/home/sofyan/Desktop/DEVOPS/terraform/production-credentials.json"
  name = "${basename(get_terragrunt_dir())}" // function where terragrunt refer to the name of resource directory
  machine_type = "e2-medium"
}