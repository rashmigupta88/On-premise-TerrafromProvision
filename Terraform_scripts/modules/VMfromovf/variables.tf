variable "data_center" { default = "DCRNSUHPLAB01" }
variable "cluster" { default = "CRNSLABCVMW002" }
variable "datastore" { default = "NFS_CNACES84_UNIX_VMSTORE_01" }
variable "network" { default = "1115_hosting_proj_B6" }
variable "remote_url" { default = "http://172.20.24.195/Catalog/OS/RHEL/8/OBSMASTER_RHEL_8.4_X64_Qualys/OBSMASTER_RHEL_8.4_X64_Qualys.ova" }
variable "VM_name" { default = "terrafrom-testVM" }

variable "vsphere_user" { default = "svc_osfactory@ocblab.eng"}
variable "vsphere_password" { default = "CRtcLOSA?QU;%0pl"}
variable "vsphere_server" { default = "10.1.200.40" }
