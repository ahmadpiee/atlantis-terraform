
terraform {
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

resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type

  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.image
      type  = var.disk_type
      size  = var.disk_size
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
      // Ephemeral public IP
    }
  }


  metadata_startup_script = var.metadata_startup_script

}
