# Marks AWS as a resource provider.
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# `aws_emr_cluster` is built-in to Terraform. We name ours `emr-spark-cluster`.
resource "aws_emr_cluster" "emr-spark-cluster" {
  name          = "emr-spark-test"
  release_label = "emr-5.2.0"         # 2016 November
  applications  = ["Hadoop", "Spark"]

  ec2_attributes {
    key_name         = "${var.key_name}"
    subnet_id        = "subnet-c5fefdb1"
    instance_profile = "EMR_EC2_DefaultRole"
  }

  master_instance_type = "m3.xlarge"
  core_instance_type   = "m3.xlarge"
  core_instance_count  = 2               # Increase as needed.
  log_uri              = "${var.s3_uri}"

  # These can be altered freely, they don't affect the config.
  tags {
    name = "Test Spark Cluster"
    role = "EMR_DefaultRole"
    env  = "env"
  }

  configurations = "spark-env.json"

  # This is the effect of `aws emr create-cluster --use-default-roles`.
  service_role = "EMR_DefaultRole"

  # Spark YARN config to S3 for the ECS cluster to grab.
  provisioner "remote-exec" {
    inline = [
      "aws s3 cp /etc/hadoop/conf/core-site.xml ${var.copy_bucket}",
      "aws s3 cp /etc/hadoop/conf/yarn-site.xml ${var.copy_bucket}",
    ]

    # Necessary to massage settings the way AWS wants them.
    connection {
      type        = "ssh"
      user        = "hadoop"
      host        = "${aws_emr_cluster.emr-spark-cluster.master_public_dns}"
      private_key = "${file("${var.pem_path}")}"
    }
  }
}

# Pipable to other programs.
output "emr_dns" {
  value = "${aws_emr_cluster.emr-spark-cluster.master_public_dns}"
}

#
# ECS Resources
#

# ECS cluster is only a name that ECS machines may join
resource "aws_ecs_cluster" "ecs-test" {
  lifecycle {
    create_before_destroy = true
  }

  name = "ecs-test"
}

# Template for container definition, allows us to inject environment
data "template_file" "ecs_ecs-test_task" {
  template = "${file("${path.module}/containers.json")}"

  vars {
    image = "${var.service_image}"
  }
}

# Allows resource sharing among multiple containers
resource "aws_ecs_task_definition" "ecs-test-task" {
  family                = "ecs-test"
  container_definitions = "${data.template_file.ecs_ecs-test_task.rendered}"
  depends_on            = ["aws_emr_cluster.emr-spark-cluster"]
}

# Defines running an ECS task as a service
resource "aws_ecs_service" "ecs-test" {
  name                               = "ecs-test"
  cluster                            = "${aws_ecs_cluster.ecs-test.id}"
  task_definition                    = "${aws_ecs_task_definition.ecs-test-task.family}:${aws_ecs_task_definition.ecs-test-task.revision}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = "0"                                                                                                 # allow old services to be torn down
  deployment_maximum_percent         = "100"
}
