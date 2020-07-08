job "tickets" {

  datacenters = ["sfo-ncv"]
  region      = "sfo-region"
  type        = "service"

  group "tickets" {
    count = 1

    task "tickets" {
      driver = "docker"
      config {
        image   = "elizhl/basic-backend-app"
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }

    network {
      mode = "bridge"
      port "http" {
        static = 5000
        to     = 5000
      }
    }

    service {
      name = "tickets"
      port = "http"
      tags = ["${NOMAD_JOB_NAME}"]

      check {
        type     = "http"
        port     = "http"
        path     = "/health"
        interval = "5s"
        timeout  = "2s"
      }
    }
  }

  group "email" {
    count = 1

    task "email" {
      driver = "docker"
      config {
        image   = "elizhl/notifications-api"
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }

    network {
      mode = "bridge"
      port "http" {
        static = 8000
        to     = 8000
      }
    }

    service {
      name = "email"
      port = "http"
      tags = ["${NOMAD_JOB_NAME}"]

      check {
        type     = "http"
        port     = "http"
        path     = "/health"
        interval = "5s"
        timeout  = "2s"
      }
    }
  }
}