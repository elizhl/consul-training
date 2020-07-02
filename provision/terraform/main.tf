provider "consul" {
  address    = var.ip_address
  datacenter = var.datacenters[0]
}

module "acl" {
  source = "./acl"
  
}

module "kv" {
  source = "./kv"
}