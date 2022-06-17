terraform {
  required_providers {
    vsphere = {
      source  = "terraform.local/local/vsphere"
      version = "2.0.2"
    }
  }
}
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
 }

 module "VMfromovf" {
source = "./modules/VMfromovf"

}

#module "CreatecloneRHEL" {
#source = "./modules/CreatecloneRHEL"
#}

