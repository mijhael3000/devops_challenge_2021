
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "scalable-nginx-example"
    labels = {
      App = "ScalableNginxExample"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
        }
      }
      spec {
        volume {
          name = "cache"
        }

        container {
          image = "nginx:1.7.8"
          name  = "nginx-container"

          port {
            container_port = 80
          }

          volume_mount {
            mount_path = "/usr/share/nginx/html/cache"
            name = "cache"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }

        init_container {
          name = "python-container1"
          image = "806571974127.dkr.ecr.us-east-2.amazonaws.com/mijha-repo:latest"
          command = ["bash","/script/myscript.sh"]
#          command = ["sleep","3600"]
          volume_mount {
            mount_path = "/workdir"
            name = "cache"
          }

        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.hostname
}