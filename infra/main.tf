locals {
  location      = "us-east1"
  project       = "assessment-tool-322"
  account_creds = file("./service_account.json")
}

terraform {
  backend "remote" {
    organization = "gama-company"

    workspaces {
      name = "autopilot"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.67.0"
    }
  }
}

provider "google" {
  # Configuration options
  project     = local.project
  region      = local.location
  credentials = local.account_creds
}


resource "google_container_cluster" "primary" {
  name     = "dmitry-cluster2"
  location = local.location

  initial_node_count = 1
  enable_autopilot   = true
  vertical_pod_autoscaling {
    enabled = true
  }
}



output "cluster_id" {
  value = google_container_cluster.primary.id
}
output "cluster_name" {
  value = google_container_cluster.primary.name
}
