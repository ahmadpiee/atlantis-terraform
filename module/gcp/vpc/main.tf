terraform {
  backend "gcs" {
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.10.0"
    }
  }
}

provider "google" {
  project     = var.project // your project id
  region      = var.region
  zone        = var.zone
  credentials = var.credentials // your credentials file path
}

resource "google_compute_network" "default" {
  name                    = var.name
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "subnet-default" {
  name          = var.name
  ip_cidr_range = var.ip_cidr_range
  network       = google_compute_network.default.id
}
