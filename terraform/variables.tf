variable "instance_count" {
  default = 2
}
variable "vpc_cidr" {
  default = "172.31.0.0/16"
}
variable "aws_profile" {
  type        = string
  description = " Provide the AWS profile name"
  default     = "customprofile"
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

variable "bucket_name" {
  description = "Name of the bucket"
  default     = "fw-internal-tfstate-bucket"
}
variable "es_subnets_id" {
  type        = list(string)
  description = "List of subnet id"
  default     = ["172.31.32.0/20", "172.31.80.0/20"]
}

variable "es_instance_type" {
  description = "ElasticSearch Instance type"
  default     = "t3.medium"
}

variable "es_ami_id" {
  description = "AMI id"
  default     = "ami-0e48bed011d8a3608"
}
variable "es_min_instances" {
  description = "Minimum number of instances"
  default     = "2"
}

variable "es_desired_instances" {
  description = "Desired number of instances"
  default     = "2"
}

variable "es_max_instances" {
  description = "Maximum number of instances"
  default     = "2"
}
variable "env" {
  default = "dev"
}
