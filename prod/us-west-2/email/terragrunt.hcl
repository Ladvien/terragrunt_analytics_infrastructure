terraform {
  source = "../../..//modules/ses"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    domain = "maddatum.com"
    primary_email = "cthomasbrittain@maddatum.com"
}
