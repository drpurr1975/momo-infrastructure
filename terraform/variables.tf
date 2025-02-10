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
variable "size" {
  type        = number
  default     = 1
  description = "Size of the instance"
}