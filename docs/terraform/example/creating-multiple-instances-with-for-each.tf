# Ref.: https://stackoverflow.com/questions/60716579/terraform-creating-multiple-instances-with-for-each

variable "gce_instances" {
  type = map(object({
    instance_count = number
    instance_name  = string
    data_volume    = string
    additional_disks = map(object({
      size = number
      type = string

    }))

  }))
  default = {
    web = {
      instance_count = 3,
      instance_name  = "web",
      data_volume    = "data"
      additional_disks = {
        "disk1" = {
          size = 100
          type = "ssd"

        },
        "disk2" = {
          size = 100
          type = "ssd"

        }

      }

    },
    db = {
      instance_count = 3,
      instance_name  = "db",
      data_volume    = "data"
      additional_disks = {
        "disk1" = {
          size = 100
          type = "ssd"

        },
        "disk2" = {
          size = 100
          type = "ssd"

        }

      }

    }

  }

}

locals {
  service_instance_groups = [
    for svc in var.gce_instances : [
      for i in range(1, svc.instance_count + 1) : {
        instance_name    = "${svc.instance_name}-${i}"
        data_volume      = svc.data_volume
        additional_disks = svc.additional_disks

      }

    ]

  ]

  service_instances = flatten(local.service_instance_groups)


}

output "service_instances" {
  value = local.service_instances

}

