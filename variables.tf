variable "vpc-cidr-block" {
  default = "10.0.0.0/16"
}
variable "az-public-subnet" {
  default = "us-east-1a"
}
variable "subnet-cidr" {
  default = "10.0.0.0/24"
}
variable "instance-ami" {
  default = "ami-053b0d53c279acc90"
}
variable "instance-type" {
  default = "t2.micro"
}
variable "instance-public-ip-association" {
  default = true
}
variable "ebs-size" {
  default = "8"
}

