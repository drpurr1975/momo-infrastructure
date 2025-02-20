module "yc-vpc" {
  source              = "github.com/terraform-yc-modules/terraform-yc-vpc.git"
  network_name        = "default"
  network_description = "Default network"
  private_subnets = [{
      name           = "subnet-1"
      zone           = "ru-central1-d"
      v4_cidr_blocks = ["10.12.0.0/24"]
    }
  ]
}

module "kube" {
  source               = "github.com/terraform-yc-modules/terraform-yc-kubernetes.git"
  network_id = "${module.yc-vpc.vpc_id}"

  master_locations  = [
    for s in module.yc-vpc.private_subnets:
      {
        zone      = s.zone,
        subnet_id = s.subnet_id
      }
    ]

  public_access        = true  
  create_kms           = true
  service_account_name = "momo-devops"

  master_maintenance_windows = [
    {
      day        = "monday"
      start_time = "23:00"
      duration   = "3h"
    }
  ]

  node_groups = {
    "yc-k8s-ng-01" = {
      auto_scale = {
        min     = var.size_min
        max     = var.size_max
        initial = var.size_initial
      }
      node_cores  = 4
      node_memory = 8
      disk_size   = 64
      node_labels = {
        role        = "worker-01"
        environment = "prod"
      }
      nat = true
    }
  }

  custom_ingress_rules = {
    "rule-1" = {
      protocol       = "TCP"
      description    = "http_ingress"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 80
    },
    "rule-2" = {
      protocol       = "TCP"
      description    = "https_ingress"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    },
    "rule-3" = {
      protocol       = "TCP"
      description    = "rule-3"
      v4_cidr_blocks = ["10.128.0.0/24", "10.129.0.0/24", "10.130.0.0/24"]
      port      = 10501
    }
  }

  custom_egress_rules = {
    "rule1" = {
      protocol       = "TCP"
      description    = "rule-1"
      v4_cidr_blocks = ["10.140.0.0/24"]
      from_port      = 0
      to_port        = 65535
    }
  }
}

module "helm" {
  source = "github.com/terraform-yc-modules/terraform-yc-kubernetes-marketplace.git"

  cluster_id = module.kube.cluster_id

  install_ingress_nginx     = true
  install_cert_manager      = true

  ingress_nginx = {
    replica_count = 1
    service_loadbalancer_ip             = "130.193.59.166"
    service_external_traffic_policy     = "Local"
    create_namespace                    = true
    namespace                           = "ingress-nginx"
  }
  cert_manager = {
    service_account_key = file("/tmp/yc-sa-key.json")
    folder_id = var.folder_id
    email_address = "dr.purr@gmail.com"
  }
}