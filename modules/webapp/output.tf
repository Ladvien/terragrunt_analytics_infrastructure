output "workstation_public_ip"  {
    value = "ssh -i ${replace(var.path_to_public_key, ".pub", "")} ${var.os_user_name}@${aws_instance.workstation.public_ip}"
}

output "public_key_path" {
    value = "${var.path_to_public_key}"
}

output "python3_packages_installed" {
  value = "${local.python3_packages_to_install}"
}

# output "startup_script" {
#     value = "${data.template_file.startup_script.rendered}"
# }

