variable "project" {
  type = string
}

variable "constraint_templates" {
  type = list(string)
}

variable "opa-repo" {
  type = string
}

variable "opa-branch" {
  type = string
}