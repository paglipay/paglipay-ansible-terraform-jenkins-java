##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

##################################################################################
# RESOURCES
##################################################################################

# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  # include aws aws_key_pair.deployer.key_name
  key_name = "aws_rsa"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("aws_rsa.pem")
    host        = aws_instance.nginx1.public_ip
  }

  provisioner "file" {
    source      = "../ansible"
    destination = "/home/ec2-user/ansible"
  }

  provisioner "file" {
    source      = "../templates/userdata.sh"
    destination = "/home/ec2-user/userdata.sh"
  }

  provisioner "file" {
    source      = "../spring-demo.zip"
    destination = "/home/ec2-user/spring-demo.zip"
  }

  # add remote exec configuration
  provisioner "remote-exec" {

    inline = [
      "sudo yum update -y",
      # "sudo amazon-linux-extras install -y ansible2",
      # "pwd",
      # "ls -la",
      # "ansible-playbook -i ansible/hosts ansible/playbook.yml",
      # "chmod +x /home/ec2-user/userdata.sh",
      # "sh /home/ec2-user/userdata.sh",
      "sudo yum install -y maven docker",
      # "unzip /spring-demo.zip",  # Assuming project is transferred beforehand
      # "cd spring-demo",
      # "mvn clean install",
      "docker build -t spring-demo .",
      "docker run --rm -it -p 5000:5000/tcp paglipayspring-demo:latest"
    ]
    on_failure = continue
  }

#   user_data = <<EOF
# #! /bin/bash
# sudo amazon-linux-extras install -y nginx1
# sudo service nginx start
# sudo rm /usr/share/nginx/html/index.html
# echo '<html><head><title>Taco Team Server 1</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
# EOF

  tags = local.common_tags

}

resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server 2</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF

  tags = local.common_tags

}