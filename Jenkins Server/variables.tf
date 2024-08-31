variable "vpc_cidr" {
  description = "VPC_CIDR"
  type        = string

}
variable "public_subnets" {
  description = "Subnets CIDR"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"

}