locals {
  index = length(data.ibm_container_cluster_versions.cluster_versions.valid_openshift_versions) 
  name = "${var.cluster_name}-${random_string.id_val.result}"
}


resource "random_string" "id_val" {
  length  = 4
  special = false
  upper   = false
}


data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}


resource "ibm_is_vpc" "vpc" {
  name = local.name
}


resource "ibm_is_public_gateway" "gateway_subnet" {
  count = var.number_of_zones
  name  = "${local.name}-publicgateway-${count.index + 1}"
  vpc   = ibm_is_vpc.vpc.id
  zone  = "${var.region}-${count.index + 1}"


  timeouts {
    create = "60m"
  }
}


resource "ibm_is_subnet" "subnet" {
  count                    = var.number_of_zones
  name                     = "${local.name}-subnet-${count.index + 1}"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = "${var.region}-${count.index + 1}"
  total_ipv4_address_count = 256
  public_gateway           = ibm_is_public_gateway.gateway_subnet[count.index].id
}



resource "ibm_container_vpc_cluster" "cluster" {
  name                            = local.name
  vpc_id                          = ibm_is_vpc.vpc.id
  flavor                          = var.worker_flavor
  kube_version                    = (var.kube_version != null ? var.kube_version : "${data.ibm_container_cluster_versions.cluster_versions.valid_openshift_versions[local.index]}_openshift")
  worker_count                    = var.workers_per_zone
  disable_public_service_endpoint = var.public_service_endpoint_disabled_val
  resource_group_id               = data.ibm_resource_group.resource_group.id
  cos_instance_crn                = ibm_resource_instance.cos_instance.id
  # wait_till                       = "OneWorkerNodeReady"
  entitlement       = "cloud_pak"
  operating_system  = "REDHAT_8_64"

  dynamic "zones" {
    for_each = ibm_is_subnet.subnet
    content {
      name      = zones.value.zone
      subnet_id = zones.value.id
    }
  }
}


resource "ibm_resource_instance" "cos_instance" {
  name     = local.name
  service  = var.service_offering
  plan     = var.price_plan
  location = "global"
}
