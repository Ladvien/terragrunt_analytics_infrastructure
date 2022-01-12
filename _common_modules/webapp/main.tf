resource "aws_instance" "workstation" {
  ami                     = var.centos_ami
  instance_type           = "${var.instance_type}"
  
  subnet_id               = "${var.subnets[0]}"
  key_name                = "${var.project_name}-ssh-key"
  vpc_security_group_ids  = ["${var.allow_ssh_security_group_id}"]

  user_data               = "${data.template_file.startup_script.rendered}"

  ebs_block_device{
    device_name = "/dev/sda1"
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination   = true 
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

locals {
  python3_packages_to_install = "${join(" ", var.python3_packages)}"
}
