variable "bucket" {
  type = string
}

variable "hosted_zone" {
  type = string
}

variable "hostnames" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
