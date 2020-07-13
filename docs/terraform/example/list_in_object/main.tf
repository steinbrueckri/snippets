locals {
  reponame = toset(flatten([
    for k, v in var.repos : [
      for folder in v : "${k}-${folder}"
    ]
  ]))
}

resource "null_resource" "my-repo" {
  for_each = local.reponame
  name     = each.key
}
