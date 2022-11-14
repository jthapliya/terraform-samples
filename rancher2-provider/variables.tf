variable "aws_access_key" {
  type        = string
  description = "AWS creds - access key"
  default     = "AWS_ACCESS_KEY"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS creds - secret key"
  default     = "AWS_SECREY_KEY"
}

variable "rancher2_access_key" {
  type        = string
  description = "Rancher api key"
  default     = "RANCHER_KEY"
}

variable "rancher2_secret_key" {
  type        = string
  description = "Rancher api secret"
  default     = "RANCHER_SECRET"
}
