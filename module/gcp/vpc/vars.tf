# provider
variable "project" {
  type        = string
  description = "Your Project ID"
}

variable "region" {
  type        = string
  description = "region of your resource"
}

variable "zone" {
  type        = string
  description = "zone of your resource"
}

variable "credentials" {
  type        = string
  description = "credentials file you generate on GCP Console"
  # default = "/home/sofyan/Desktop/DEVOPS/terraform/credentials.json"
}

variable "name" {
  type        = string
  description = "name of your vpc"
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "the value should be true or false, default is true"
}

variable "ip_cidr_range" {
  type        = string
  description = "your ip range of your subnetwork, should be string"
}


