data "coder_workspace" "ii" {}

resource "coder_metadata" "ip_attachment" {
  resource_id = equinix_metal_ip_attachment.public_ip.id
  item {
    key   = "elastc ip"
    value = equinix_metal_ip_attachment.public_ip.address
  }
}
resource "coder_metadata" "device_info" {
  count       = data.coder_workspace.ii.transition == "start" ? 1 : 0
  resource_id = equinix_metal_device.machine.id
  item {
    key   = "direct ssh"
    value = "ssh root@${equinix_metal_device.machine.access_public_ipv4}"
  }
  item {
    key   = "serial console"
    value = "ssh ${equinix_metal_device.machine.id}@sos.${equinix_metal_device.machine.deployed_facility}.platformequinix.com"
  }
  item {
    key   = "equinix console"
    value = "https://console.equinix.com/devices/${equinix_metal_device.machine.id}/overview"
  }
}
