terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name                    = var.name-lastname
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = var.name-lastname
  ip_cidr_range = var.cidr-range
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_instance" "vm_instance" {
  name         = var.name-lastname
  machine_type = "f1-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnetwork.name
    access_config {
    }
  }

  metadata_startup_script = "sudo apt-get update; sudo apt install nginx -y; sudo systemctl start nginx; sudo ufw enable; sudo ufw allow 80/tcp"

}

resource "google_compute_firewall" "web-server" {
  project     = var.project
  name        = "allow-http-rule"
  network     = google_compute_network.vpc_network.name
  description = "Regla de firewall apuntando a los servidores con etiquetas"

  allow {
    protocol = "tcp"
    ports    = ["80","22","443","3389"]
         }
   source_ranges = ["0.0.0.0/0"]
   target_tags = ["web"]
    timeouts {}
}


