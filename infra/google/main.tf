resource "google_compute_instance" "cud_demo" {
  name         = "cud-demo"
  zone         = "us-central1-a"
  machine_type = "n1-standard-32"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  labels = {
    environment = "production"
    service     = "cud-demo"
  }
}