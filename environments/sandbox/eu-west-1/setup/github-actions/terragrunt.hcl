terraform {
  source = "${path_relative_from_include()}//modules/github-actions"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  repository = "miguellobato84/aws-resources"
  plan = {
    enabled = true
  }
  apply = {
    enabled = true
    branch  = "main"
  }
}