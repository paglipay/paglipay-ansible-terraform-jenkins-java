##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  #  access_key = "AKIASWK2AEZTKDWMVD5D"
  #  secret_key = "SECRET_KEY"
  region = "us-east-1"
}

##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"

}


##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
resource "aws_vpc" "app" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id

}

resource "aws_subnet" "public_subnet1" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = true
}

# ROUTING #
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

# SECURITY GROUPS #

#resource "aws_key_pair" "deployer" {
#  key_name   = "aws_rsa"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZV70iuiXao1WhB4xje1sPGzr1Edom5AfKU1IP+MaH1mXOWUcuuyY5aFfhBv6GLFBozN8oZrHad6lppLy1elyek9i/R8ZnIrZg1Ehhxtfqz5vXSsBP/fUp7GiQ2v8QvS7uMAtLGFDobRONX0zG7ZJAK/AxqUU38CMnanv8OePmFwEaf8himjWB20sVscwpBYHZ45DtdXjB8q7WTZMpW2hyC3yhrmkUjnyrwDJsAvyoJDkpzyk/4Rqv2uiAj1ALV7Pvm5h41i/Ru7D9UWT0cvGTc4OipLEcb+B9NlexHY8PJNRwK55qGF9wcGsJ0vXywclfIj1CYUtiHJLEKdjkDpMx paul@ub-desk-230"
#}

# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.app.id

  # HTTP access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 9001
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 9443
    to_port     = 9443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# INSTANCES # https://dev.to/aws-builders/installing-jenkins-on-amazon-ec2-491e
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  # include aws aws_key_pair.deployer.key_name
  key_name = "aws_rsa"

  provisioner "file" {
    source      = "ansible"
    destination = "ansible"
  }
  # add remote exec configuration
  provisioner "remote-exec" {

    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install -y ansible2",
      "pwd",
      "ansible-playbook -i ansible/hosts ansible/playbook.yml"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("aws_rsa.pem")
      host        = aws_instance.nginx1.public_ip
    }
  }

}

#resource "aws-s3-bucket" "jenkins-artifact20-s3" {
#  bucket = "jenkins-artifact20-s3"
#}
