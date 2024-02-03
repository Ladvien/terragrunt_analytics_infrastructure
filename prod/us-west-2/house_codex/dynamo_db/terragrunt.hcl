terraform {
  source = "../../../..//modules/dynamo_db"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    project_name = "house_codex"
    table_name = "house_codex"

}
