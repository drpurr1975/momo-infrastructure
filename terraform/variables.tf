variable "zone" {
  type        = string
  default     = "ru-central1-d"
  description = "Zone of the instance"
}
variable "cloud_id" {
  type        = string
  default     = "b1g557taev4t7m7thfpo"
  description = "Yandex.Cloud ID"
}
variable "folder_id" {
  type        = string
  default     = "b1gnuvue6d2ju33503m5"
  description = "Yandex.Cloud folder ID"
}
variable "size" {
  type        = number
  default     = 2
  description = "Size of the instance"
}
variable "cluster_name" {
  type        = string
  default     = "momo-store"
  description = "Name of the Kubernetes cluster"  
}
variable "subnet_id" {
  type        = string
  default     = "fl86j1k5qddvoef4e9hq"
  description = "ID of the subnet"
}
variable "network_id" {
  type        = string
  default     = "enpuhc98a2jpm6jjrsfh"
  description = "ID of the network"
}