resource "aws_instance" "workstation" {
  ami                     = var.centos_ami
  instance_type           = "t3.micro"
  
  subnet_id               = "${var.subnets[0]}"
  key_name                = "${var.project_name}-ssh-key"
  vpc_security_group_ids  = ["${var.allow_ssh_security_group_id}"]


  user_data = var.startup_script
  provisioner "file" {
    source                = "${var.aws_cli_creds_path}"
    destination           = "/home/centos/.aws/config"

    connection {
      type          = "ssh"
      user          = "centos"
      private_key   = "${file(replace(var.path_to_public_key, ".pub", ""))}"
      host          = self.public_ip
    }

  }

  tags = {
    Name = "${var.project_name}-temporary-workstation"
  }
}

resource "aws_key_pair" "workstation_key" {
  key_name          = "${var.project_name}-ssh-key"
  public_key        = file(var.path_to_public_key)
  lifecycle {
    ignore_changes = [public_key]
  }
}

