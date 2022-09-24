provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "C!sc0lab@123"
  vsphere_server       = "10.105.192.183"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "SDA-SPARSHA"
}

data "vsphere_datastore" "datastore" {
  name          = "ESXi-POD5"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = "172.16.51.13"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


resource "vsphere_virtual_machine" "cat8k" {
  name             = "cat8k"
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datacenter_id    = data.vsphere_datacenter.datacenter.id
  host_system_id   = data.vsphere_host.host.id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id         = "other3xLinux64Guest"
  
  ovf_deploy {
    allow_unverified_ssl_cert = true
    remote_ovf_url            = "http://10.105.192.184:8000/c8000v-universalk9.17.06.03a.ova"
    disk_provisioning         = "thick"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
  }


}