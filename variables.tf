data "aws_region" "current_reg" {}
data "aws_availability_zones" "available" {
    state = "available"
}

variable "cidr_block" {
    type = string 
    default = "10.0.0.0/16"
}

variable "public_subnet" {
    type = string 
    default = "10.0.1.0/24"
}

variable "private_subnet" {
    type = string 
    default = "10.0.2.0/24"
}

locals  {
    av_z = data.aws_availability_zones.available.names[0]
    aws_region = data.aws_region.current_reg.name
}
#aws regiony user input , ete availability zone- sxale exacic patahakan dne , nat gateway... sax user input 
#subnetneri qanaky ( = availabil zone-eri vra ), petq e subnet te che (ete priv subnet chka nat gw petq che)
#