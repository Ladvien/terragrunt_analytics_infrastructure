resource "aws_instance" "workstation" {
  ami                     = var.centos_ami
  instance_type           = "${var.instance_type}"
  
  subnet_id               = "${var.subnets[0]}"
  key_name                = "${var.project_name}-ssh-key"
  vpc_security_group_ids  = ["${var.allow_ssh_security_group_id}"]

  iam_instance_profile    = "${aws_iam_instance_profile.airflow_admin_instance_profile.name}"

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

resource "aws_iam_instance_profile" "airflow_admin_instance_profile" {
  name = "airflow_admin_instance_profile"
  role = "${var.iam_role_for_workstation_name}"
}

locals {
  python3_packages_to_install = "${join(" ", var.python3_packages)}"
}

# This script ensures the Python setup script has completed
# before stating the workstation is ready for use.
# resource "null_resource" "wait_for_python_script_to_finish" {
#   provisioner "remote-exec" {
#     connection {
#       type          = "ssh"
#       user          = "centos"
#       private_key   = "${file(replace(var.path_to_public_key, ".pub", ""))}"
#       host          = aws_instance.workstation.public_ip
#     }

#     inline = [
#       "#!/bin/bash",
#       "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do",
#       "  echo -e '\\033[1;36mWaiting for cloud-init...'",
#       "  sleep 5",
#       "done",
#       "echo -e '\\u001b[32mWorkstation setup complete!'"
#     ]
#   }
# }