provider "consul" {
  address    = "172.20.20.11:8500"
  datacenter = "sfo"
}

resource "consul_keys" "app" {
  datacenter = "sfo"
  token      = "a7ef48f5-fc6f-edb9-9f14-f44db8e4e298"

  # Set the test value
  key {
    path  = "app/test"
    value = "This is value"
  }
  key {
    path  = "app/test-folder/test2"
    value = "This is a folder new"
  }
}
