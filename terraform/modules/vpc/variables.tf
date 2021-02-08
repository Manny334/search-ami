variable "aws_profile" {
  type        = string
  description = " Provide the AWS profile name"
  default     = "customprofile"
}
variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["us-east-1a", "us-east-1c"]

}

variable "es_subnets_cidr" {
  type        = list(string)
  description = "List of subnet id"
  default     = ["172.31.32.0/20", "172.31.80.0/20"]
}


variable "env" {
  description = "Set the Environment"
  default     = "dev"
}
