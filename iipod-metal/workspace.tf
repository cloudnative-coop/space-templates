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
    key   = "ssh"
    value = "ssh -tA ii@${local.dns_fqdn} tmux at"
  }
  item {
    key   = "ssh pod"
    value = "ssh -t ii@${local.dns_fqdn} kubectl exec -it iipod-0 -- tmux at"
  }
  item {
    key   = "scp kubeconfig"
    value = "scp root@${equinix_metal_device.machine.access_public_ipv4}:.kube/config /tmp/kubeconfig ; export KUBECONFIG=/tmp/kubeconfig"
  }
  item {
    key   = "Gnome/VNC"
    value = "http://${local.dns_fqdn}:6080/?resize=remote&autoconnect=true"
  }
  item {
    key   = "direct ssh"
    value = "ssh root@${equinix_metal_device.machine.access_public_ipv4}"
  }
  # item {
  #   key   = "serial console"
  #   value = "ssh ${equinix_metal_device.machine.id}@sos.${equinix_metal_device.machine.deployed_facility}.platformequinix.com"
  # }
  item {
    key   = "equinix console"
    value = "https://console.equinix.com/devices/${equinix_metal_device.machine.id}/overview"
  }
}

output "vnc_desktop" {
  value = "http://${local.dns_fqdn}:6080/?resize=remote&autoconnect=true"
}

output "ssh" {
  value = "ssh -tA ii@${local.dns_fqdn} tmux at"
}
output "ssh_pod" {
  value = "ssh -t ii@${local.dns_fqdn} kubectl exec -it iipod-0 -- tmux at"
}
output "scp_kubeconfig" {
  value = "ssh root@${equinix_metal_device.machine.access_public_ipv4}:.kube/config /tmp/kubeconfig ; export KUBECONFIG=/tmp/kubeconfig"
}
