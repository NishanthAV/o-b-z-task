**1.We define the Kubernetes provider and specify the path to the kube config file.**

**2.We create a kubernetes_deployment resource with the desired metadata and specifications.**

**3.Inside the spec block, we define the number of replicas, selector labels, and the template for the pod.**

**4.Inside the pod template, we specify the container with the image, command, environment variables, and the exposed port.**

**5.Source Code(main.tf)**
```
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

```

**6.Commands to execute**
```
terraform init
terraform apply
```
**7.Make sure to save this configuration to a main.tf file and then run terraform init and terraform apply to apply the deployment to your Kubernetes cluster.**