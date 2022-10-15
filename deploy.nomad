variable "image_tag" {
  type    = string
  default = "latest"
}

job "hello-world" {

  datacenters = ["main"]
  type        = "service"

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "30s"
    progress_deadline = "2m"
    health_check      = "checks"
    auto_revert       = true
  }

  group "application" {
    count = 1

    network {
      port "http" {
        host_network = "private"
      }
    }

    task "server" {
      driver = "docker"

      config {
        image        = "docker.your-domain.tld/hello-world:${var.image_tag}"
        network_mode = "host"
      }

      resources {
        cpu    = 100
        memory = 16
      }

      env {
        SERVER_HOST_IP = "${NOMAD_IP_http}"
        SERVER_PORT    = "${NOMAD_PORT_http}"
      }

      service {
        provider     = "nomad"
        name         = "hello-world"
        port         = "http"
        address_mode = "host"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.hello-world.rule=Host(`hello.your-domain.tld`)",
          "traefik.http.routers.hello-world.tls=true",
          "traefik.http.routers.hello-world.tls.certresolver=letsencrypt",
          "traefik.http.routers.hello-world.middlewares=response-compress@file",
        ]

        check {
          type         = "http"
          address_mode = "host"
          port         = "http"
          path         = "/"
          interval     = "10s"
          timeout      = "1s"

          check_restart {
            limit = 2
            grace = "10s"
          }
        }
      }

      template {
        data = <<-EOF
          {{with nomadVar "nomad/jobs/hello-world"}}
          MESSAGE="{{.message}}"
          {{end}}
        EOF

        destination = "secrets/vars.env"
        env         = true
      }
    }
  }
}