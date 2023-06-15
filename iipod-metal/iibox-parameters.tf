# https://deploy.equinix.com/developers/docs/metal/locations/capacity/#checking-capacity
# We may want to check capacity now and then
# metal capacity get -P c3.small.x86 | grep normal
# | ny5  | c3.small.x86 | normal      |
# | ny7  | c3.small.x86 | normal      |
# | sv15 | c3.small.x86 | normal      |
# | sv16 | c3.small.x86 | normal      |
# | ty11 | c3.small.x86 | normal      |
# Then updateplans
data "coder_parameter" "metro" {
  name         = "metro"
  display_name = "Metro"
  description  = "The Equinix Metal Metro for the machine"
  default      = "ny"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  option {
    name  = "New York, USA"
    value = "ny"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Flag_of_Texas.svg/1200px-Flag_of_Texas.svg.png"
  }
  option {
    name  = "Silicon Valley, USA"
    value = "sv"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg/1200px-Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg.png"
  }
  option {
    name  = "Tokyo, Japan"
    value = "ty"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg/1200px-Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg.png"
  }
  # option {
  #   name  = "Dallas, Texas, USA"
  #   value = "da"
  #   icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Flag_of_Texas.svg/1200px-Flag_of_Texas.svg.png"
  # }
  # option {
  #   name  = "Sydney, Australia"
  #   value = "sy"
  #   icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg/1200px-Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg.png"
  # }
  # option {
  #   name  = "Washington, DC, USA"
  #   value = "dc"
  #   icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg/1200px-Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg.png"
  # }
}

data "coder_parameter" "plan" {
  name         = "plan"
  display_name = "Plan"
  description  = "The Equinix Metal Plan for the machine"
  default      = "c3.small.x86"
  option {
    name  = "c3.small.x86"
    value = "c3.small.x86"
  }
  option {
    name  = "c3.medium.x86"
    value = "c3.medium.x86"
  }
  option {
    name  = "m3.large.x86"
    value = "m3.large.x86"
  }
}

data "coder_parameter" "os" {
  name         = "os"
  display_name = "Operating System"
  description  = "The Equinix Metal Operating System for the machine"
  default      = "ubuntu_22_04"
  option {
    name  = "Ubuntu 20.04 LTS"
    value = "ubuntu_20_04"
  }
  option {
    name  = "Ubuntu 22.04 LTS"
    value = "ubuntu_22_04"
  }
}
