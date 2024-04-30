# IBM provider variables
# uncomment if using local terraform
# variable "ibmcloud_api_key" {}

# Global variables
variable "cluster_name" {
  type        = string
  default     = "ibm-openshift"
  description = "name of cluster - prefix"
}

variable "region_name" {
  type        = string
  default     = "jp-osa"
  description = "region name"
}

variable "resource_group" {
  type        = string
  default     = "Default"
  description = "resource group"
}

variable "number_of_zones" {
  type        = number
  default     = 1
  description = "number of zones"
  validation {
    condition     = var.number_of_zones >= 1 && var.number_of_zones <= 3
    error_message = "chose from: 1 2 3"
  }
}

# OpenShift variables
variable "worker_flavor" {
  type        = string
  default     = "bx2.4x16"
  description = "worker flavor"
}

variable "workers_per_zone" {
  type        = string
  default     = "3"
  description = "workers per zone"
}

variable "public_service_endpoint_disabled_val" {
  type        = bool
  default     = false
  # default     = true
  description = "public service endpoint disabled"
}

variable "kube_version" {
  type        = string
  default     = null
  description = "kube version"
}

# Cloud Object Storage (COS) variables
variable "service_offering" {
  type        = string
  default     = "cloud-object-storage"
  description = "service offering"
}

variable "price_plan" {
  type        = string
  default     = "standard"
  description = "pricing plan "
}