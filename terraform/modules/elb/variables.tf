variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_id" {
  type = string
}

variable "vpc_subnets" {
  type = list(string)
}
variable "env" {
  default = "dev"
}
variable "aws_profile" {
  type        = string
  description = " Provide the AWS profile name"
  default     = "customprofile"
}
variable "host_header_prod" {
  type        = string
  description = "Describe the host for the prod target group"
  default     = "search.prod.internal.freightwise.app"
}
variable "host_header_kibana" {
  type        = string
  description = "Describe the host for the kibana target group"
  default     = "search-kibana.prod.internal.freightwise.app"
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

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["us-east-1a", "us-east-1c"]
}
