terraform {
  backend "s3" {
    bucket         = "assignment4tfstate12345"
    key            = "statefiles/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "assignment4_state_lock_12345"
  }
}
/*
resource "aws_s3_bucket" "statefilebucket123" {
  bucket = "assignment4tfstate12345"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_dynamodb_table" "statelock" {
  name         = "assignment4_state_lock_12345"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LOCKID"
  attribute {
    name = "LOCKID"
    type = "S"
  }

}
*/

resource "aws_vpc" "assignment4-vpc" {
  cidr_block = var.vpc-cidr-block
  tags       = { Name = "terraform-assignment4-vpc" }
}

resource "aws_internet_gateway" "assignment-4-vpc-igw" {
  vpc_id = aws_vpc.assignment4-vpc.id
  #depends_on = [aws_vpc.assignment4-vpc]
}
/*
resource "aws_internet_gateway_attachment" "igw-attachment" {
  vpc_id              = aws_vpc.assignment4-vpc.id
  internet_gateway_id = aws_internet_gateway.assignment-4-vpc-igw.id
}
*/
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.assignment4-vpc.id
  tags   = { Name = "public_route_table" }
}
resource "aws_route_table_association" "rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
  # depends_on     = [aws_route_table.public-route-table]
}
/*resource "aws_route" "internalvpcroute" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "10.0.0.0/16"
  gateway_id             = "local"
  depends_on             = [aws_route_table.public-route-table]
}*/
resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.assignment-4-vpc-igw.id
  #depends_on             = [aws_route_table.public-route-table, aws_internet_gateway.assignment-4-vpc-igw]
}
resource "aws_subnet" "public-subnet" {
  availability_zone = var.az-public-subnet
  cidr_block        = var.subnet-cidr
  vpc_id            = aws_vpc.assignment4-vpc.id
  tags              = { Name = "public_subnet" }
}
resource "aws_security_group" "main-security-group" {
  name        = "main-security-group"
  vpc_id      = aws_vpc.assignment4-vpc.id
  description = "inbound for all IPs,SSH, HTTP,HTTPS, custom TCP:port80. outbound for all protocols and types"
  tags        = { Name = "main_security_group" }
}
resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  security_group_id = aws_security_group.main-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "allows all outbound traffic"
  ip_protocol       = "-1"
  #from_port         = "0"
  #to_port           = "0"
  #depends_on = [aws_security_group.main-security-group]
}
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_ssh" {
  security_group_id = aws_security_group.main-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "allows all inbound ssh"
  ip_protocol       = "TCP"
  from_port         = "22"
  to_port           = "22"
  #depends_on        = [aws_security_group.main-security-group]
}
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_http" {
  security_group_id = aws_security_group.main-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "allows all inbound HTTP"
  ip_protocol       = "TCP"
  from_port         = "80"
  to_port           = "80"
  #depends_on        = [aws_security_group.main-security-group]
}
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_https" {
  security_group_id = aws_security_group.main-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "allows all inbound HTTPS"
  ip_protocol       = "TCP"
  from_port         = "443"
  to_port           = "443"
  #depends_on        = [aws_security_group.main-security-group]
}
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_nginx" {
  security_group_id = aws_security_group.main-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "allows all inbound HTTPS"
  ip_protocol       = "TCP"
  from_port         = "81"
  to_port           = "81"
  #depends_on        = [aws_security_group.main-security-group]
}

resource "aws_network_acl" "NACL" {
  vpc_id = aws_vpc.assignment4-vpc.id
  tags = {
  Name = "assignment4_NACL" }
}
resource "aws_network_acl_rule" "NACL_ingress_rule" {
  network_acl_id = aws_network_acl.NACL.id
  rule_number    = "1"
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = "0"
  to_port        = "0"
  #depends_on     = [aws_network_acl.NACL]
}
resource "aws_network_acl_rule" "NACL_egress_rule" {
  network_acl_id = aws_network_acl.NACL.id
  rule_number    = "1"
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = "0"
  to_port        = "0"
  #depends_on     = [aws_network_acl.NACL]
}

resource "aws_network_acl_association" "NACL-assosiation" {
  network_acl_id = aws_network_acl.NACL.id
  subnet_id      = aws_subnet.public-subnet.id
  #depends_on     = [aws_network_acl.NACL]
}

resource "aws_instance" "ec2-instance" {
  ami                         = var.instance-ami
  associate_public_ip_address = var.instance-public-ip-association
  availability_zone           = var.az-public-subnet
  instance_type               = var.instance-type
  vpc_security_group_ids      = [aws_security_group.main-security-group.id]
  subnet_id                   = aws_subnet.public-subnet.id
  tags = {
    Name = "assignment4_instance"
  }
  #depends_on = [aws_vpc.assignment4-vpc, aws_security_group.main-security-group, aws_subnet.public-subnet]
  key_name = "ec2keypair"
}

resource "aws_ebs_volume" "ebs-vol" {
  availability_zone = var.az-public-subnet
  size              = var.ebs-size
  type              = "gp2"
}

resource "aws_volume_attachment" "vol-attach" {
  device_name = "/dev/sdf" #For Linux-based AMIs, common device names are /dev/sdf, /dev/xvdf, /dev/nvme1n1, etc.
  #For Windows-based AMIs, common device names are xvdf, xvdg, etc.
  instance_id = aws_instance.ec2-instance.id
  volume_id   = aws_ebs_volume.ebs-vol.id
}
resource "aws_s3_bucket" "mybucket" {
  #bucket = "bucket153468sd-assignment4"
  #use new bucket name everytime. otherwise code not reusable.
  tags = {
    Name        = "Terraform-created-bucket"
    environment = "testing"
    purpose     = "for-assigment-4"
  }
  force_destroy = true
}
#push2



