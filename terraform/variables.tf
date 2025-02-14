variable "zone" {
  type        = string
  default     = "ru-central1-d"
  description = "Zone of the instance"
}
variable "cloud_id" {
  type        = string
  description = "Yandex.Cloud ID"
}
variable "folder_id" {
  type        = string
  description = "Yandex.Cloud folder ID"
}
variable "size_initial" {
  type        = number
  default     = 1
  description = "Size of the instance"
}
variable "size_min" {
  type        = number
  default     = 1
  description = "Size of the instance"
}
variable "size_max" {
  type        = number
  default     = 2
  description = "Size of the instance"
}
variable "cluster_name" {
  type        = string
  default     = "momo-store"
  description = "Name of the Kubernetes cluster"
}