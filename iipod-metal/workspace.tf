data "coder_workspace" "ii" {}

# resource "coder_metadata" "ip_attachment" {
#   resource_id = equinix_metal_ip_attachment.public_ip.id
#   item {
#     key   = "elastc ip"
#     value = equinix_metal_ip_attachment.public_ip.address
#   }
# }
