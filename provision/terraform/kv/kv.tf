resource "consul_key_prefix" "app" {
  datacenter = "sfo"

  # Prefix to add to prepend to all of the subkey names below.
  path_prefix = "app/test/"

  subkeys = {
    "elb_cname"         = "one_name"
    "s3_bucket_name"    = "bucket_name"
    "database/hostname" = "database"
    "database/port"     = "port"
    "database/username" = "username"
    "database/name"     = "image"
    "acl_test_value"     = "deny"
  }

  subkey {
    path  = "database/password"
    value = "sdasdasd"
    flags = 2
  }

}


resource "consul_key_prefix" "app2" {
  datacenter = "sfo"

  # Prefix to add to prepend to all of the subkey names below.
  path_prefix = "app2/test/"

  subkeys = {
    "elb_cname"         = "one_name"
    "s3_bucket_name"    = "bucket_name"
    "database/hostname" = "database"
    "database/port"     = "port"
    "database/username" = "username"
    "database/name"     = "image"
    "acl_test_value"     = "deny"
  }

  subkey {
    path  = "database/password"
    value = "sdasdasd"
    flags = 2
  }

}

resource "consul_key_prefix" "app3" {
  datacenter = "sfo"

  # Prefix to add to prepend to all of the subkey names below.
  path_prefix = "app3/test/"

  subkeys = {
    "elb_cname"         = "one_name"
    "s3_bucket_name"    = "bucket_name"
    "database/hostname" = "database"
    "database/port"     = "port"
    "database/username" = "username"
    "database/name"     = "image"
    "acl_test_value"     = "deny"
  }

  subkey {
    path  = "database/password"
    value = "sdasdasd"
    flags = 2
  }

}