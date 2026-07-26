variable "region" {
  description = "ovh region to deploy OpenFiat node infrastructure into."
  type        = string
}

variable "node_count" {
  description = "Number of OpenFiat node instances to provision."
  type        = number
  default     = 3
}

variable "instance_size" {
  description = "Provider-specific instance/machine size identifier."
  type        = string
}

variable "tags" {
  description = "Common resource tags/labels."
  type        = map(string)
  default     = { project = "openfiat" }
}
