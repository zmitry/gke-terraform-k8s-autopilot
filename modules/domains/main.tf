terraform {
  required_version = "~> 0.13"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

resource "cloudflare_record" "default" {
  zone_id = var.zone_id
  type    = "A"
  name    = "www.zmitry.com"
  value   = "93.184.216.3"
  proxied = true
}

resource "cloudflare_record" "root" {
  zone_id = var.zone_id
  type    = "A"
  name    = "zmitry.com"
  value   = "93.184.216.3"
  proxied = true
}

variable "zone_id" {
  type = string
}
