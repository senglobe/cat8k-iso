data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_host" "host" {
  name          = var.host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network1" {
  name          = var.int1
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network2" {
  name          = var.int2
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network3" {
  name          = var.int3
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_file"  {
  datacenter = data.vsphere_datacenter.datacenter.id
  datastore        = data.vsphere_datastore.datastore.id
  destination_file = "/config.iso"
  source_file      = var.day0
}

resource "vsphere_virtual_machine" "cat8k" {
  name             = var.hostname
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  host_system_id   = data.vsphere_host.host.id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id         = "other3xLinux64Guest"
  num_cpus         = 4
  memory           = 4096
  disk {
    label = "disk0"
    size = "16"
  }
  /*
  disk {
    label = "disk1"
    path = var.day0
  }
*/
  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id
    path         = var.iso
 }

  network_interface {
    network_id = data.vsphere_network.network1.id
  }
  network_interface {
    network_id = data.vsphere_network.network2.id
  }
  network_interface {
    network_id = data.vsphere_network.network3.id
  }
  wait_for_guest_net_timeout = -1
}
