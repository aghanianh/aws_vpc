data "aws_availability_zones" "available" {
    state = "available"
}

variable "cidr_block" {
    type = string 
    default = "10.0.0.0/16"
}

variable "public_subnets" {
    type = list(string)
    default = ["10.0.1.0/24"]
}

variable "private_subnets" {
    type = list(string)
    default = ["10.0.2.0/24"]
}
variable "aws_region" {
    type = string 
    default = "us-east"
}

variable "av_z" {
    type = list(string)
    default = ["us-east-1a"]
}


#aws regiony user input , ete availability zone- sxale exacic patahakan dne , nat gateway... sax user input 
#subnetneri qanaky ( = availabil zone-eri vra ), petq e subnet te che (ete priv subnet chka nat gw petq che)
#foreach count ....