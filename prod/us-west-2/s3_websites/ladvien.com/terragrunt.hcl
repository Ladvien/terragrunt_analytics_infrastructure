terraform {
  source = "../../../..//modules/s3_website"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    website_name = "ladvien"
    domain = "ladvien.com"
}