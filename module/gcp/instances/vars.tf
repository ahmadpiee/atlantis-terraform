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

variable "tags" {
  type        = list(string)
  description = "your network tags, should be array of string"
}

variable "image" {
  type        = string
  description = "your image of instance e.g ubuntu-os-cloud/ubuntu-2204-jammy-v20231213a"
}

variable "disk_type" {
  type        = string
  description = "type of your disk e.g pd-ssd stand for persistent ssd"
}

variable "disk_size" {
  type        = number
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
  description = "startup script of your instance, should be string, you also can use <<EOF EOF>> tag for multi string"
}
