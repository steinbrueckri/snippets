# Terraform

[https://stackoverflow.com/questions/57453468/google-cloud-credentials-with-terraform](https://stackoverflow.com/questions/57453468/google-cloud-credentials-with-terraform)

## Google Compute Engine - Restore from Snapshot

image = element(split(":", lookup(var.ip-addresses-map[count.index], "from")),0) == "image" ? element(split(":", lookup(var.ip-addresses-map[count.index], "from")),1) : ""
snapshot = element(split(":", lookup(var.ip-addresses-map[count.index], "from")),0) == "snapshot" ? element(split(":", lookup(var.ip-addresses-map[count.index], "from")),1) : ""
