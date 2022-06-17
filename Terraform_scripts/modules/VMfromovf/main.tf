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

data "vsphere_ovf_vm_template" "ovf" {
  name             = "terrafrom-testVM"
  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id
  host_system_id   = data.vsphere_host.hs.id
  #remote_ovf_url   = "http://172.20.24.195/Catalog/OS/RHEL/8/OBSMASTER_RHEL_8.4_X64_Qualys/OBSMASTER_RHEL_8.4_X64_Qualys.ova"
  #remote_ovf_url  = "http://172.20.24.195/Catalog/OS/UBUNTU/UBUNTU_18.04/OBSMASTER_Ubuntu_18.04_X64_Qualys_RNov21.ova"
  remote_ovf_url = var.remote_url
  ovf_network_map = {
    "Network 1": data.vsphere_network.net.id
  }
}


resource "vsphere_virtual_machine" "vm" {
  datacenter_id    = data.vsphere_datacenter.dc.id
  name             = data.vsphere_ovf_vm_template.ovf.name
  resource_pool_id = data.vsphere_ovf_vm_template.ovf.resource_pool_id
  datastore_id     = data.vsphere_ovf_vm_template.ovf.datastore_id
  host_system_id   = data.vsphere_ovf_vm_template.ovf.host_system_id
  folder           = "VM Unix/System Cell/OSFactory & CaaS Team"
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  dynamic "network_interface" {
    for_each = data.vsphere_ovf_vm_template.ovf.ovf_network_map
    content {
      network_id = network_interface.value
	  
    }
	
  }
  ovf_deploy {
    remote_ovf_url = var.remote_url
    #remote_ovf_url  = "http://172.20.24.195/Catalog/OS/RHEL/8/OBSMASTER_RHEL_8.4_X64_Qualys/OBSMASTER_RHEL_8.4_X64_Qualys.ova"
	#remote_ovf_url  = "http://172.20.24.195/Catalog/OS/UBUNTU/UBUNTU_18.04/OBSMASTER_Ubuntu_18.04_X64_Qualys_RNov21.ova"
	
	disk_provisioning = "thin"
	ovf_network_map = data.vsphere_ovf_vm_template.ovf.ovf_network_map

 
   
  }
  }
  
  
# Name of VM created using OVA retrieved   
output "vm_name" {
  value = data.vsphere_ovf_vm_template.ovf.name
}  
  
    
  


  
  

