terraform {
  source = "../../../..//modules/s3_website"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    website_name = "prochesshabits"
    domain = "prochesshabits.com"
    cloudfront_distribution_id = "E1XD7G9GFPF7LO"
}
