provider "consul" {
  address    = var.ip_address
  datacenter = var.datacenters[0]
  insecure_https = true
  scheme = "https"
}

module "acl" {
  source = "./acl"
  
}

module "kv" {
  source = "./kv"
}