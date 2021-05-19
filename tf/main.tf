terraform {
  required_version = "~> 0.13"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }

  backend "remote" {
    organization = "gama-company"
    workspaces {
      name = "infra"
    }
  }
}

provider "cloudflare" {
  api_token = local.cloudflare_api_token
}


module "domains" {
  source  = "../modules/domains"
  zone_id = local.zone_id
}


locals {
  cloudflare_api_token = "THRM-64dyBeT6Bhm_x7LpRGBhqSRXeQ9bqeJxh6p"
  cloudflare_email     = "kraken@live.ru"
  zone_id              = "ec89cf0d489a7def115489181b4ceff6"
}
