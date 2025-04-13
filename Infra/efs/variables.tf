variable "performance_mode" {
  description = "The performance mode for the EFS file system"
  type        = string
  default     = "generalPurpose"
}

variable "encrypted" {
  description = "Indicates if the EFS file system is encrypted"
  type        = bool
  default     = true
}

