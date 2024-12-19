locals {
  all_instance_ids = concat(
    module.ec2_app1.instance_ids,
    module.ec2_bastion.instance_ids,
    module.ec2_centos.instance_ids
  )

  instance_tags = {
    for id in local.all_instance_ids :
    id => {
      os   = data.aws_instance.instance_lookup[id].tags["OS"]
      name = data.aws_instance.instance_lookup[id].tags["Name"]
    }
  }

  instance_fstype = {
    for id, tags in local.instance_tags :
    id => tags.os == "ubuntu" ? "ext4" : "xfs"
  }
}

data "aws_instance" "instance_lookup" {
  for_each = toset(local.all_instance_ids)
  instance_id = each.value
}

resource "aws_cloudwatch_dashboard" "system_metrics" {
  dashboard_name = format("%s-%s-%s-monitoring-dashboard", var.customer, var.project, var.environment)

  dashboard_body = jsonencode({
    "widgets" = flatten([
      for id in local.all_instance_ids : [
        {
          "type"       : "metric",
          "x"          : 0,
          "y"          : length(local.all_instance_ids) * 0,
          "width"      : 12,
          "height"     : 6,
          "properties" : {
            "metrics" : [
              ["AWS/EC2", "CPUUtilization", "InstanceId", id]
            ],
            "period"  : 300,
            "stat"    : "Average",
            "region"  : "${var.region}",
            "title"   : format("CPU Utilization - %s", local.instance_tags[id].name)
          }
        },
        {
          "type"       : "metric",
          "x"          : 0,
          "y"          : length(local.all_instance_ids) * 6,
          "width"      : 12,
          "height"     : 6,
          "properties" : {
            "metrics" : [
              ["CWAgent", "mem_used_percent", "InstanceId", id]
            ],
            "period"  : 300,
            "stat"    : "Average",
            "region"  : "${var.region}",
            "title"   : format("Memory Utilization - %s", local.instance_tags[id].name)
          }
        },
        {
          "type"       : "metric",
          "x"          : 0,
          "y"          : length(local.all_instance_ids) * 12,
          "width"      : 12,
          "height"     : 6,
          "properties" : {
            "metrics" : [
              ["CWAgent", "disk_used_percent", "InstanceId", id, "path", "/", "device", "nvme0n1p1", "fstype", local.instance_fstype[id]]
            ],
            "period"  : 300,
            "stat"    : "Average",
            "region"  : "${var.region}",
            "title"   : format("Disk Utilization - %s", local.instance_tags[id].name)
          }
        }
      ]
    ])
  })
}
