output "private-ip" {
  value = google_compute_instance.vm_instance.network_interface.0.network_ip
}

output "vm-name" {
  value = google_compute_instance.vm_instance.name
}

output "network-name" {
  value = google_compute_network.vpc_network.name
}

output "subnetwork-name" {
  value = google_compute_subnetwork.subnetwork.name
}

output "public-ip" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}