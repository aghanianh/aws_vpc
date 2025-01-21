resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
}

resource "aws_internet_gateway" "gw" {
    count = (length(var.public_subnets) > 0  || length(var.private_subnets) > 0) ? 1 : 0
    vpc_id = aws_vpc.main.id
}

resource "aws_eip" "ng_eip" {
    count = length(var.private_subnets) > 0 ? 1 : 0
    vpc = true
}   

resource "aws_nat_gateway" "ng" {
    count = length(var.private_subnets)
    subnet_id = aws_subnet.public_subnet[0].id
    allocation_id = aws_eip.ng_eip[0].id 
}


resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnets)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnets[count.index]
    availability_zone = var.av_z[count.index]
    map_public_ip_on_launch = true 

}


resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.main.id 
    cidr_block = var.private_subnets[count.index]
    availability_zone = var.av_z[count.index]
    map_public_ip_on_launch = false 
}

resource "aws_route_table" "public_route" {
    count = length(var.public_subnets) > 0 ? 1 : 0
    vpc_id = aws_vpc.main.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw[0].id
    }
}

resource "aws_route_table" "private_route" {
    count = length(var.private_subnets) > 0 ? 1 : 0
    vpc_id = aws_vpc.main.id 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.ng[0].id 
    }
}

resource "aws_route_table_association" "public_subnet" {
    subnet_id = aws_subnet.public_subnet[0].id 
    route_table_id = aws_route_table.public_route[0].id 
}

resource "aws_route_table_association" "private_subnet" {
    subnet_id = aws_subnet.private_subnet[0].id 
    route_table_id = aws_route_table.private_route[0].id
}