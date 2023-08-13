
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
/*
resource "aws_vpc" "assignment2-vpc" {
  cidr_block = var.vpc-cidr-block
  tags       = { Name = "terraform-assignment2-vpc" }
}

resource "aws_internet_gateway" "assignment-2-vpc-igw" {
  vpc_id = aws_vpc.assignment2-vpc.id
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.assignment2-vpc.id
  tags   = { Name = "public-route-table-tags" }
}

resource "aws_route_table_association" "rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_subnet" "public-subnet" {
  availability_zone = var.az-public-subnet
  cidr_block        = var.subnet-cidr
  vpc_id            = aws_vpc.assignment2-vpc.id
  tags              = { Name = "public-subnet-tags" }
}
resource "aws_security_group" "main-security-group" {
  name        = "main-security-group"
  vpc_id      = aws_vpc.assignment2-vpc.id
  description = "inbound for all IPs -SSH, HTTP. outbound for all protocols and types"
  tags        = { Name = "main_security group tags" }
}

resource "aws_network_acl" "NACL" {
  vpc_id = aws_vpc.assignment2-vpc.id
  tags = {
  Name = "NACL" }
}
resource "aws_network_acl_association" "NACL-assosiation" {
  network_acl_id = aws_network_acl.NACL.id
  subnet_id      = aws_subnet.public-subnet.id
}

resource "aws_instance" "ec2-instance" {
  ami                         = var.instance-ami
  associate_public_ip_address = var.instance-public-ip-association
  availability_zone           = var.az-public-subnet
  instance_type               = var.instance-type
  vpc_security_group_ids      = [aws_security_group.main-security-group.id]
  subnet_id                   = aws_subnet.public-subnet.id
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

*/


