resource "kubernetes_ingress_v1" "game-2048__ingress-2048" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"            = "alb",
      "alb.ingress.kubernetes.io/scheme"       = "internal",
      "alb.ingress.kubernetes.io/target-type"  = "ip",
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\": 8080}]"
    }
    name      = "ingress-2048"
    namespace = "game-2048"
  }

  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "service-2048"
              port {
                number = "80"
              }
            }
          }
        }
      }
    }
  }
}
