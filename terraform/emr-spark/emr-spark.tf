provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

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
  core_instance_count  = 2
  log_uri              = "${var.s3_uri}"

  tags {
    name = "Test Spark Cluster"
    role = "EMR_DefaultRole"
    env  = "env"
  }

  service_role = "EMR_DefaultRole"
}

output "id" {
  value = "${aws_emr_cluster.emr-spark-cluster.id}"
}
