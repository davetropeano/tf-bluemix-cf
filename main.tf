provider "ibmcloud" {
      bluemix_api_key    = "${var.ibmcloud_bx_api_key}"
      #skip_service_configuration = ["softlayer","cluster"]
}

data "ibmcloud_cf_space" "spacedata" {
  space = "${var.space}"
  org   = "${var.org}"
}

resource "ibmcloud_cf_service_instance" "service-instance" {
  name       = "${var.service_instance_name}"
  space_guid = "${data.ibmcloud_cf_space.spacedata.id}"
  service    = "${var.service}"
  plan       = "${var.plan}"
  tags       = ["cluster-service", "cluster-bind"]
}

resource "ibmcloud_cf_service_key" "serviceKey" {
  name                  = "${var.service_key_name}"
  service_instance_guid = "${ibmcloud_cf_service_instance.service-instance.id}"
}

# Required for the IBM Cloud provider
variable "ibmcloud_bx_api_key" {}

variable "space" {
  default = "dev"
}

variable "org" {
  default = "myorg"
}

variable "service" {
  default = "cloudantNoSQLDB"
}

variable "plan" {
  default = "Lite"
}

variable "service_instance_name" {
  default = "mycloudantdb"
}

variable "service_key_name" {
  default = "mycloudantdbkey"
}

#service instance guid
output "guid" {
  value = "${ibmcloud_cf_service_instance.service-instance.id}"
}

output "credentials" {
      value = "${ibmcloud_cf_service_key.serviceKey.credentials}"
}
