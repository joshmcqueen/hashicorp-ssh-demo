provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "analytics" {
  ami           = "ami-098f3b1d228f57491"
  instance_type = "t2.micro"
  key_name      = "dev-key"
  security_groups = ["sg-00e7a9e288aa9d997"]
  subnet_id = "subnet-0697082b2bedf9846"

  tags = {
    Name  = "analytics"
    Terraform = "true"
  }
}

resource "aws_instance" "vault" {
  ami           = "ami-086fe1a2524b289cb"
  instance_type = "t2.micro"
  key_name      = "dev-key"
  security_groups = ["sg-00e7a9e288aa9d997"]
  subnet_id = "subnet-0697082b2bedf9846"

  tags = {
    Name  = "vault"
    Terraform = "true"
  }
}

resource "aws_instance" "client" {
  ami           = "ami-0d1cd67c26f5fca19"
  instance_type = "t2.micro"
  key_name      = "dev-key"
  security_groups = ["sg-00e7a9e288aa9d997"]
  subnet_id = "subnet-0697082b2bedf9846"

  tags = {
    Name  = "client"
    Terraform = "true"
  }
}