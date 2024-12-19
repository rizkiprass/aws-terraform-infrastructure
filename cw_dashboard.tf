locals {
  all_instance_ids = concat(
    ["i-08b555ebc85248a63",
      "i-0f3cb7608094b2e24",
      "i-0a2722f633e1966c2",
      "i-0f96b9ba2438c04a4",
      "i-0a94f14c016023bf3",
      "i-0df1de6eadf0c6940",
      "i-01735b6f41910f52c",
      "i-0ca3b53ec30e8943a",
      "i-0ce6df5de821668c9",
      "i-0f48247c1adffe398",
    "i-0eaea3fbc92f4782d"]
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
  for_each    = toset(local.all_instance_ids)
  instance_id = each.value
}

resource "aws_cloudwatch_dashboard" "system_metrics" {
  dashboard_name = format("%s-%s-monitoring-dashboard", var.customer, var.environment)

  dashboard_body = jsonencode({
    "widgets" = flatten([
      for id in local.all_instance_ids : [
        {
          "type" : "metric",
          "x" : 0,
          "y" : length(local.all_instance_ids) * 0,
          "width" : 12,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/EC2", "CPUUtilization", "InstanceId", id]
            ],
            "period" : 300,
            "stat" : "Average",
            "region" : "${var.region}",
            "title" : format("CPU Utilization - %s", local.instance_tags[id].name)
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : length(local.all_instance_ids) * 6,
          "width" : 12,
          "height" : 6,
          "properties" : {
            "metrics" : [
              [
                "CWAgent", "mem_used_percent", "InstanceId", id,
                "ImageId", "${data.aws_instance.instance_lookup[id].ami}",
                "InstanceType", "${data.aws_instance.instance_lookup[id].instance_type}"
              ]
            ],
            "period" : 300,
            "stat" : "Average",
            "region" : "${var.region}",
            "title" : format("Memory Utilization - %s", local.instance_tags[id].name)
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : length(local.all_instance_ids) * 12,
          "width" : 12,
          "height" : 6,
          "properties" : {
            "metrics" : [
              [
                "CWAgent", "disk_used_percent",
                "InstanceId", id,
                "path", "/",
                "device", "nvme0n1p1",
                "fstype", local.instance_fstype[id],
                "ImageId", "${data.aws_instance.instance_lookup[id].ami}",
                "InstanceType", "${data.aws_instance.instance_lookup[id].instance_type}"
              ]
            ],
            "period" : 300,
            "stat" : "Average",
            "region" : "${var.region}",
            "title" : format("Disk Utilization - %s", local.instance_tags[id].name)
          }
        }

      ]
    ])
  })
}
