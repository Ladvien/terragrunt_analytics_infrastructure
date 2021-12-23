resource "aws_cloud9_environment_ec2" "workstation" {
  name = "${var.project_name}"
  instance_type = "${var.instance_type}"
  # subnet_id = "${var.subnet}"
  automatic_stop_time_minutes = "${var.minutes_after_save_to_shutdown}"
}

