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

data "vsphere_datacenter" "dc" {
  name = var.data_center
}

data "vsphere_host" "hs" {
  name = "prnslabinfesx11.ocblab.eng"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_network" "net" {
  name = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.VM_name
  datacenter_id = data.vsphere_datacenter.dc.id
  }


resource "vsphere_virtual_machine" "learn" {
  
  name             = "NEW-terraformVM"
  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id
  folder           = "VM Unix/System Cell/OSFactory & CaaS Team"

  
  network_interface {
    network_id = data.vsphere_network.net.id
  }
  
  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }


  guest_id = "rhel8_64Guest"

  clone {
     
    template_uuid = data.vsphere_virtual_machine.template.id
	
	customize {
      linux_options {
        host_name = "image-refresh-instance"
        domain    = "test.internal"
      }

      network_interface {
        ipv4_address = "10.1.235.242"
        ipv4_netmask = "24"
      }

      ipv4_gateway = "10.1.235.254"
    }
  }
 
 provisioner "remote-exec" {
 
 inline = [
	"cd /home/rashmi/Automation/",
	"ansible-playbook patching.yml --vault-password-file vault.txt"
]


connection {
type = "ssh"
user = "root"
host = "10.1.235.227"
private_key = file("rashmi.pem")
}
}
 
 
}


  
output "vm_ip" {
  value = vsphere_virtual_machine.learn.guest_ip_addresses
}




