# module "yc-vpc" {
#   source              = "github.com/terraform-yc-modules/terraform-yc-vpc.git"
#   network_name        = "default"
#   network_description = "Default network"
#   private_subnets = [{
#     name           = "subnet-1"
#     zone           = "ru-central1-a"
#     v4_cidr_blocks = ["10.10.0.0/24"]
#     },
#     {
#       name           = "subnet-2"
#       zone           = "ru-central1-b"
#       v4_cidr_blocks = ["10.11.0.0/24"]
#     },
#     {
#       name           = "subnet-3"
#       zone           = "ru-central1-d"
#       v4_cidr_blocks = ["10.12.0.0/24"]
#     }
#   ]
# }

module "kube" {
  source     = "github.com/terraform-yc-modules/terraform-yc-kubernetes.git"
  network_id = var.network_id

  master_locations = [
    {
      zone      = "ru-central1-d"
      subnet_id = var.subnet_id
    }
  ]

  master_maintenance_windows = [
    {
      day        = "monday"
      start_time = "23:00"
      duration   = "3h"
    }
  ]

  node_groups = {
    "yc-k8s-ng-01" = {
      description = "Kubernetes nodes group 01"
      fixed_scale = {
        size = var.size
      }
      node_labels = {
        role        = "worker-01"
        environment = "prod"
      }
      nat = true
    }
  }
<<<<<<< HEAD
=======
  cluster_name = var.cluster_name
  public_access = true
  
  # custom_ingress_rules = {
  #   "rule1" = {
  #     protocol = "TCP"
  #     description = "rule-1"
  #     v4_cidr_blocks = ["0.0.0.0/0"]
  #     port = 80
  #   }
  # }
>>>>>>> 7177436 (add terraform balancer target group)
}