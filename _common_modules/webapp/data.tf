data "template_file" "startup_script" {
  template = "${file(var.startup_script_path)}"
  vars = {
    # AWS_ACCOUNT_ID          = "${local.aws_account_id}"
    # AWS_SECRET_ACCESS_KEY   = "${local.aws_secret_access_key}"
    AWS_REGION              = "${var.region}"
    PYTHON3_PACKAGES        = "${local.python3_packages_to_install}"
    OS_USER_NAME            = "${var.os_user_name}"
  }
}
