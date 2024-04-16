variable "project" {
  type = string
}

variable "opa_excluded_namespaces" {
  type = list(string)
}

variable "opa-repo" {
  type = string
}

variable "opa-branch" {
  type = string
}
