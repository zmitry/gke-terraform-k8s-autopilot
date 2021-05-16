terraform {
  backend "remote" {
    organization = "gama-company"

    workspaces {
      name = "deploy"
    }
  }
}
data "terraform_remote_state" "gks" {
  backend = "remote"
  config = {
    organization = "gama-company"

    workspaces = {
      name = "autopilot"
    }
  }
}
data "google_client_config" "default" {}
data "google_container_cluster" "primary" {
  name     = data.terraform_remote_state.gks.outputs.cluster_name
  location = local.location
  project  = local.project
}

locals {
  location     = "us-east1"
  project      = "assessment-tool-322"
  cluster_name = "dmitry-cluster2"
  cluster_host = "https://${data.google_container_cluster.primary.endpoint}"
}

provider "kubernetes" {
  load_config_file       = false
  host                   = local.cluster_host
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca)
  token                  = data.google_client_config.default.access_token

}

provider "helm" {
  kubernetes {
    host  = local.cluster_host
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate,
    )
  }
}

output "host" {
  value = "https://${data.google_container_cluster.primary.endpoint}"
}

resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
}


resource "helm_release" "postgres-cluster" {
  name = "postgres-cluster"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "10.4.5"
  reuse_values = true

  set {
    name  = "postgresqlPassword"
    value = "postgres"
  }
  set {
    name  = "postgresqlUsername"
    value = "postgres2"
  }

  set {
    name  = "resources.requests.cpu"
    value = "1000m"
  }

}
