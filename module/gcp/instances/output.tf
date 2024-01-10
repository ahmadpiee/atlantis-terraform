# display private and public IP of instance created

output "ip-private-default" {
  value = google_compute_instance.default.network_interface[*].network_ip
}

output "ip-public-default" {
  value = google_compute_instance.default.network_interface[*].access_config[*].nat_ip
}
