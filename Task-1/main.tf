provider "kubernetes" {
  config_path = "C:/Users/Admin/.kube/config"  # Replace with your actual kubeconfig path
}

resource "kubernetes_namespace" "myapp-namespace" {
  metadata {
    name = "myapp-namespace"
  }
}

resource "kubernetes_deployment" "myapp-deployment" {
  metadata {
    name = "myapp-deployment"
    namespace = kubernetes_namespace.myapp-namespace.metadata[0].name
  
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        App = "myapp"
      }
    }

    template {
      metadata {
        labels = {
          App = "myapp"
        }
      }

      spec {
        container {
          image = "myapp:1.0.0.1"
          name  = "myapp"
          command = ["./start.sh"]

          env {
            name  = "DATABASE_URL"
            value = "jdbc:postgresql://db:5432/mydb"
          }

          env {
            name  = "LOG_LEVEL"
            value = "info"
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
