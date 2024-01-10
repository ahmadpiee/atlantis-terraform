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

# instances
variable "name" {
  type        = string
  description = "your instance name"
}

variable "machine_type" {
  type        = string
  description = "your machine type of instance e.g e2-medium"
}

# etc
variable "tags" {
  type        = list(string)
  description = "your network tags, should be array of string"
}

variable "image" {
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-jammy-v20231213a"
  description = "your image of instance e.g ubuntu-os-cloud/ubuntu-2204-jammy-v20231213a"
}

variable "disk_type" {
  type        = string
  default     = "pd-ssd"
  description = "type of your disk e.g pd-ssd stand for persistent ssd"
}

variable "disk_size" {
  type        = number
  default     = 10
  description = "size of your disk in GB, should be number, default is 10"
}

variable "network" {
  type        = string
  description = "network of your instance, should be string"
}

variable "subnetwork" {
  type        = string
  description = "subnetwork of your instance, should be string"
}

variable "metadata_startup_script" {
  type        = string
  default     = "sudo apt update -y && sudo apt upgrade -y"
  description = "startup script of your instance, should be string, you also can use <<EOF EOF>> tag for multi string"
}
