terraform {
  source = "../../../..//modules/s3-bucket"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    bucket_name = "ladviens-image-store"
}
