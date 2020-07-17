resource "consul_acl_policy" "agent" {
  name  = "agent"
  rules = <<-RULE
    key_prefix "cluster/consul/" {
      policy = "read"
    }
    RULE
}

resource "consul_acl_token" "token_path" {
  description = "my path token"
  policies = ["${consul_acl_policy.agent.name}"]
  local = false
}

resource "consul_acl_policy" "app1" {
  name  = "app1"
  rules = <<-RULE
    key_prefix "cluster/consul/" {
      policy = "read"
    }
    RULE
}

resource "consul_acl_token" "token_app1" {
  description = "Token for app1"
  policies = ["${consul_acl_policy.app1.name}"]
  local = false
}

resource "consul_acl_policy" "app2" {
  name  = "app2"
  rules = <<-RULE
    key_prefix "cluster/consul/" {
      policy = "read"
    }
    RULE
}

resource "consul_acl_token" "token_app2" {
  description = "Token for app2"
  policies = ["${consul_acl_policy.app2.name}"]
  local = false
}

resource "consul_acl_policy" "vault_storage" {
  name  = "vault_storage"
  rules = <<-RULE
    key_prefix "cluster/consul/" {
      policy = "read"
    }
    RULE
}

resource "consul_acl_token" "token_vault_storage" {
  description = "Token for vault storage"
  policies = ["${consul_acl_policy.vault_storage.name}"]
  local = false
}


resource "consul_acl_policy" "consul-replicate" {
  name  = "consul_replicate"
  rules = <<-RULE
    key_prefix "cluster/consul/" {
      policy = "read"
    }
    RULE
}

resource "consul_acl_token" "token_consul_replicate" {
  description = "Token for consul replicate"
  policies = ["${consul_acl_policy.consul-replicate.name}"]
  local = false
}