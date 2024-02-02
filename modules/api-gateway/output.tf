output "source_code_paths" {
    value = local.source_code_paths
}

output "source_code_paths_check" {
    value = "${var.folder_to_lambda_source_code}/${local.source_code_paths[0]}"
}