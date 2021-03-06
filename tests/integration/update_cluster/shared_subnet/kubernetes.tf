output "cluster_name" {
  value = "sharedsubnet.example.com"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-sharedsubnet-example-com.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-sharedsubnet-example-com.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-sharedsubnet-example-com.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-sharedsubnet-example-com.id}"]
}

output "node_subnet_ids" {
  value = ["subnet-12345678"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-sharedsubnet-example-com.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-sharedsubnet-example-com.name}"
}

output "region" {
  value = "us-test-1"
}

output "subnet_ids" {
  value = ["subnet-12345678"]
}

output "vpc_id" {
  value = "vpc-12345678"
}

provider "aws" {
  region = "us-test-1"
}

resource "aws_autoscaling_group" "master-us-test-1a-masters-sharedsubnet-example-com" {
  name                 = "master-us-test-1a.masters.sharedsubnet.example.com"
  launch_configuration = "${aws_launch_configuration.master-us-test-1a-masters-sharedsubnet-example-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["subnet-12345678"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "sharedsubnet.example.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-test-1a.masters.sharedsubnet.example.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-sharedsubnet-example-com" {
  name                 = "nodes.sharedsubnet.example.com"
  launch_configuration = "${aws_launch_configuration.nodes-sharedsubnet-example-com.id}"
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = ["subnet-12345678"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "sharedsubnet.example.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.sharedsubnet.example.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_ebs_volume" "us-test-1a-etcd-events-sharedsubnet-example-com" {
  availability_zone = "us-test-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                                = "sharedsubnet.example.com"
    Name                                             = "us-test-1a.etcd-events.sharedsubnet.example.com"
    "k8s.io/etcd/events"                             = "us-test-1a/us-test-1a"
    "k8s.io/role/master"                             = "1"
    "kubernetes.io/cluster/sharedsubnet.example.com" = "owned"
  }
}

resource "aws_ebs_volume" "us-test-1a-etcd-main-sharedsubnet-example-com" {
  availability_zone = "us-test-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                                = "sharedsubnet.example.com"
    Name                                             = "us-test-1a.etcd-main.sharedsubnet.example.com"
    "k8s.io/etcd/main"                               = "us-test-1a/us-test-1a"
    "k8s.io/role/master"                             = "1"
    "kubernetes.io/cluster/sharedsubnet.example.com" = "owned"
  }
}

resource "aws_iam_instance_profile" "masters-sharedsubnet-example-com" {
  name = "masters.sharedsubnet.example.com"
  role = "${aws_iam_role.masters-sharedsubnet-example-com.name}"
}

resource "aws_iam_instance_profile" "nodes-sharedsubnet-example-com" {
  name = "nodes.sharedsubnet.example.com"
  role = "${aws_iam_role.nodes-sharedsubnet-example-com.name}"
}

resource "aws_iam_role" "masters-sharedsubnet-example-com" {
  name               = "masters.sharedsubnet.example.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.sharedsubnet.example.com_policy")}"
}

resource "aws_iam_role" "nodes-sharedsubnet-example-com" {
  name               = "nodes.sharedsubnet.example.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.sharedsubnet.example.com_policy")}"
}

resource "aws_iam_role_policy" "masters-sharedsubnet-example-com" {
  name   = "masters.sharedsubnet.example.com"
  role   = "${aws_iam_role.masters-sharedsubnet-example-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.sharedsubnet.example.com_policy")}"
}

resource "aws_iam_role_policy" "nodes-sharedsubnet-example-com" {
  name   = "nodes.sharedsubnet.example.com"
  role   = "${aws_iam_role.nodes-sharedsubnet-example-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.sharedsubnet.example.com_policy")}"
}

resource "aws_key_pair" "kubernetes-sharedsubnet-example-com-c4a6ed9aa889b9e2c39cd663eb9c7157" {
  key_name   = "kubernetes.sharedsubnet.example.com-c4:a6:ed:9a:a8:89:b9:e2:c3:9c:d6:63:eb:9c:71:57"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.sharedsubnet.example.com-c4a6ed9aa889b9e2c39cd663eb9c7157_public_key")}"
}

resource "aws_launch_configuration" "master-us-test-1a-masters-sharedsubnet-example-com" {
  name_prefix                 = "master-us-test-1a.masters.sharedsubnet.example.com-"
  image_id                    = "ami-12345678"
  instance_type               = "m3.medium"
  key_name                    = "${aws_key_pair.kubernetes-sharedsubnet-example-com-c4a6ed9aa889b9e2c39cd663eb9c7157.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-sharedsubnet-example-com.id}"
  security_groups             = ["${aws_security_group.masters-sharedsubnet-example-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-test-1a.masters.sharedsubnet.example.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "nodes-sharedsubnet-example-com" {
  name_prefix                 = "nodes.sharedsubnet.example.com-"
  image_id                    = "ami-12345678"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-sharedsubnet-example-com-c4a6ed9aa889b9e2c39cd663eb9c7157.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-sharedsubnet-example-com.id}"
  security_groups             = ["${aws_security_group.nodes-sharedsubnet-example-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.sharedsubnet.example.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_security_group" "masters-sharedsubnet-example-com" {
  name        = "masters.sharedsubnet.example.com"
  vpc_id      = "vpc-12345678"
  description = "Security group for masters"

  tags = {
    KubernetesCluster                                = "sharedsubnet.example.com"
    Name                                             = "masters.sharedsubnet.example.com"
    "kubernetes.io/cluster/sharedsubnet.example.com" = "owned"
  }
}

resource "aws_security_group" "nodes-sharedsubnet-example-com" {
  name        = "nodes.sharedsubnet.example.com"
  vpc_id      = "vpc-12345678"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster                                = "sharedsubnet.example.com"
    Name                                             = "nodes.sharedsubnet.example.com"
    "kubernetes.io/cluster/sharedsubnet.example.com" = "owned"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-sharedsubnet-example-com.id}"
  source_security_group_id = "${aws_security_group.masters-sharedsubnet-example-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-sharedsubnet-example-com.id}"
  source_security_group_id = "${aws_security_group.masters-sharedsubnet-example-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-sharedsubnet-example-com.id}"
  source_security_group_id = "${aws_security_group.nodes-sharedsubnet-example-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-sharedsubnet-example-com.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-sharedsubnet-example-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-sharedsubnet-example-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-sharedsubnet-example-com.id}"
  source_security_group_id = "${aws_security_group.nodes-sharedsubnet-example-com.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-sharedsubnet-example-com.id}"
  source_security_group_id = "${aws_security_group.nodes-sharedsubnet-example-com.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-sharedsubnet-example-com.id}"
  source_security_group_id = "${aws_security_group.nodes-sharedsubnet-example-com.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-sharedsubnet-example-com.id}"
  source_security_group_id = "${aws_security_group.nodes-sharedsubnet-example-com.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-sharedsubnet-example-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-sharedsubnet-example-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

terraform = {
  required_version = ">= 0.9.3"
}
