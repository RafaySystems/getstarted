variable "project" {
  type = string
}

variable "rafay_config_file" {
  type    = string
  default = "./artifacts/credentials/config.json"
}

variable "blueprint_name" {
  type = string
}

variable "blueprint_version" {
  type = string
}

variable "base_blueprint" {
  type = string
}

variable "base_blueprint_version" {
  type = string
}
