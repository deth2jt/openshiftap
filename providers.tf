# terraform {
#   required_providers {
#     ibm = {
#       source = "IBM-Cloud/ibm"
#       version = ">= 1.12.0"
#     }
#   }
# }

provider "ibm" {
    #Osaka 21
    #crn:v1:bluemix:public:power-iaas:osa21:a/06d2a1ecba244622a0fb88efb4843fb4:2f6324cc-540f-427d-985c-3475fdc6f225::
    region    =  var.region_name
    zone      =   var.zone_name
    # alias            = "pvs"
}


