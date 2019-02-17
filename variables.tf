variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "common_key" {
  description = "Desired name of AWS key pair"
  default    = "own_key"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-674cbc1e"
    us-east-1 = "ami-1d4e7a66"
    us-west-1 = "ami-969ab1f6"
    us-west-2 = "ami-8803e0f0"
  }
}

# Ubuntu Precise 12.04 LTS (x64)
variable "ecs_amis" {
  default = {
    eu-west-1 = "ami-0885003261a52af1c"
    us-east-1 = "ami-032564940f9afd5c0"
    us-west-1 = "ami-030dcc999f03d168b"
    us-west-2 = "ami-0291b991e70d83d33"
  }
}