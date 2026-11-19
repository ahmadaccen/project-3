provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "monitor_server" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-08582c33155c10f7c"
  vpc_security_group_ids = ["sg-08204c0b0b8c7f580"]

  tags = {
    Name = "CloudWatch-Monitor-Server"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    InstanceId = aws_instance.monitor_server.id
  }

  alarm_description = "Alarm when CPU exceeds threshold"
}
