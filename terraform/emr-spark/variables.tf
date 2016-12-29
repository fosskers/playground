# From your `~/.aws/credentials
variable "access_key" {}

# From your `~/.aws/credentials
variable "secret_key" {}

# Can be overridden if necessary
variable "region" {
  default = "us-east-1"
}

variable "amis" {
  type = "map"

  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
  }
}

# Path to your EC2 secret key
variable "pem_path" {}

# The name of your EC2 key
variable "key_name" {}

# Location to dump EMR logs
variable "s3_uri" {}

variable "copy_bucket" {}

variable "service_image" {}

variable "ecs_service_role" {}
