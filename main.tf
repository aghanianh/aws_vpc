resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
}

resource "aws_eip" "ng_eip" {
    vpc = true
}

resource "aws_nat_gateway" "ng" {
    subnet_id = aws_subnet.public_subnet
    allocation_id = aws_eip.ng_eip.id 
    depends_on = [ aws_internet_gateway.gw ]

}


resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet
    availability_zone = local.av_z
    map_public_ip_on_launch = true 
    
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id 
    cidr_block = var.private_subnet
    availability_zone = local.av_z
    map_public_ip_on_launch = false 
}

resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.main.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}



resource "aws_route_table" "private_route" {
    vpc_id = aws_vpc.main.id 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.ng.id 
    }
}

resource "aws_route_table_association" "public_subnet" {
    subnet_id = aws_subnet.public_subnet.id 
    route_table_id = aws_route_table.public_route.id 
}

resource "aws_route_table_association" "private_subnet" {
    subnet_id = aws_subnet.private_subnet.id 
    route_table_id = aws_route_table.private_route.id
}



