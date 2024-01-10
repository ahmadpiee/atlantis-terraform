output "ip-private-default" {
  value = google_compute_instance.default.network_interface[*].network_ip
}

output "ip-public-backend" {
  value = google_compute_instance.default.network_interface[*].access_config[*].nat_ip
}
