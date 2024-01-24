variable "project" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "s3_bucket" {
  type = string
  default = "null"
  description = "The name of the AWS S3 bucket for storing backups"
}

variable "cluster_location" {
  type = string
  description = "The AWS region the cluster will be provisioned"
}