provider "kubernetes" {
config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "jenkins" {
   metadata {
       name = "jenkins" 
   }
}

resource "kubernetes_service" "jenkins-slave" {
   metadata {
     name = "jenkins-slave"
     namespae = "jenkins"
   }

   spec {
     selector  = {
       name = "jenkins"
     }

     type = "ClusterIP"

     port {
      name = "jnlp"
      port = 50000
      target_port = 50000
     }
   }
}

resource "kubernetes_service" "jenkins" {
   metadata {
     name = "jenkins"
     namespae = "jenkins"
   }

   spec {
     selector  = {
       name = "jenkins"
     }

     type = "NodePort"

     port {
      name = "default"
      port = 8080
      node_port = 30201
      target_port = 8080
     }
   }
}

resource "kubernetes_service_account" "jenkins_admin" {
   metadata {
     name = "jenkins-admin"
     namespae = "jenkins"
   }
}

resource "kubernetes_role" "jenkins" {
   metadata {
    name = "jenkins"
    namespace = "jenkins"
    labels {
       "app.kubernetes.io/name" = "jenkins"
     }
   }
    rule {
      verbs = ["create", "delete", "get", "list", "patch", "update", "watch"]
      api_groups = [""]
      resources = ["pods"]
    }
    rule {
      verbs = ["create", "delete", "get", "list", "patch", "update", "watch"]
      api_groups = [""]
      resources = ["pods/exec"]
    }
    rule {
      verbs = ["get", "list", "watch"]
      api_groups = [""]
      resources = ["pods/log"]
    }
    rule {
      verbs = ["get"]
      api_groups = [""]
      resources = ["secrets"]
    }
}

resource "kubernetes_role_binding" "jenkins_role_binding" {
    metadata {
      name = "jenkins-role-binding"
      namespace = "jenkins"
   }

   subject {
       kind = "ServiceAccount"
       name = "jenkins-admin"
       namespace = "jenkins" 
   }
 

   role_ref {
     api_group = "rbac.authorization.k8s.io"
     kind = "Role"
     name = "jenkins"
   }
}


resource "kubernetes_deployment" "jenkins" {
   metadata {
      name = "jenkins"
      namespace = "jenkins"
    }

   spec {
     replicas = 1

     selector {
        match_labels = {
             name = "jenkins"
         }
       }

     template {
         metadata {
            lables {
              name = "jenkins"
            }
         }

          spec {
             volume {
                name = "jenkins"
                config_map {
                       name = "jenkins"
                       default_mode = "0644"
                     }
                   }
             volume {
                name = "plugins"
                config_map {
                       name = "plugins"
                       default_mode = "0644"
                     }
                   }
          }

           container {
             name = "jenkins"
             image = "jenkins_custom:1.0"
             args = ["--argumentRealm.passwd.admin=admin", "--argumentsRealm.roles.admin=admin"]


             port {
                   name = "http"
                   container_port = 8080
                   protocol = "TCP"
              }

             port {
                   name = "slavelistener"
                   container_port = 50000
                   protocol = "TCP"
              }

             port {
                   name = "jmx"
                   container_port = 4000
                   protocol = "TCP"
              }

             port {
                   name = "sshd"
                   container_port = 22
                   protocol = "TCP"
              }

            env {
                 name = "JAVA_OPTS"
                 value = "-Dcom.sun.management.jmxremote.port=4000 -Dcom.sun.management.jmxremote.authentication=false -Dcom.sun.management.jmxremote.ssl=false -Djenkins.install.runSetupWizard=false"
             }

           env {
                 name = "CASA_JENKINS_CONFIG"
                 value = "/tm/p/jenkins.yaml"
             }

           volume_mount {
                 name = "jenkins"
                 mount_path = "/var/jenkins.yaml"
                 sub_path = "jenkins.yaml"
               }

           volume_mount {
                 name = "plugins"
                 mount_path = "/usr/share/jenkins/ref/plugins.txt"
                 sub_path = "plugins.txt"
               }
           security_context {
                  run_as_user = 0
                  allow_privilege_escalation = false
               }
           }
     }
   }
}

resource "kubernetes_config_map" "jenkins" {
    metadata {
      name = "jenkins"
      namespace = "jenkins"
      labels = {
         "name" = "jenkins"
      }
   }
   data = {
    "jenkins.yaml" = "$(file(jenkins.yaml"))"
   }
}

resource "kubernetes_config_map" "plugins" {
    metadata {
      name = "plugins"
      namespace = "jenkins"
      labels = {
         "name" = "plugins"
      }
   }
   data = {
    "plugins.txt" = "$(file("plugins.txt"))"
   }
}

