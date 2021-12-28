output "workstation_public_ip"  {
    value = "ssh -i ${replace(var.path_to_public_key, ".pub", "")} centos@${aws_instance.workstation.public_ip}"
}

output "public_key_path" {
    value = "${var.path_to_public_key}"
}