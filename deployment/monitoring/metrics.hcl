job "metrics" {

  datacenters = ["sfo-ncv"]
  region      = "sfo-region"
  type        = "service"

    group "grafana" {

    task "grafana" {
      driver = "docker"
      config {
        image = "grafana/grafana"
         port_map {
          service_port = 3000
        }

        volumes = [
          "/vagrant/deployment/monitoring/grafana/config.ini:/etc/grafana/config.ini",
          "/vagrant/deployment/monitoring/grafana/provisioning:/etc/grafana/provisioning",
          "/vagrant/deployment/monitoring/grafana/dashboards:/var/lib/grafana/dashboards"
        ]
      }

      env {
        GF_SECURITY_ADMIN_PASSWORD="secret"
        GF_INSTALL_PLUGINS="grafana-clock-panel,briangann-gauge-panel,natel-plotly-panel,grafana-simple-json-datasource"
      }

      resources {
        cpu    = 50
        memory = 50

        network {
            mbits = 10
            port "service_port" {
            static = 3999
            to     = 3999
            }
        }
      }

      service {
        name = "grafana"
        port = "service_port"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }

  group "telegraf" {
      
    task "telegraf" {
      driver = "docker"
      config {
        image = "telegraf"
         volumes = [
          "/vagrant/deployment/monitoring/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf",
        ]
        port_map {
          service_port = 8125
        }
      }

      resources {
        cpu    = 50
        memory = 50
        network {
            mbits = 10
            port "service_port" {
              static = 8125
            }
        }
      }
      
      service {
        name = "telegraf"
        port = "service_port"
      }
    }
  }
}