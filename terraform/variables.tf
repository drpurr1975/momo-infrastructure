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