variable "project" {
  type = string
}

variable "public_repositories" {
  type = map(object({
    endpoint = string
    type     = string
  }))
}
