#EC2 Variables
variable "ami" {
  description = "Amazon Linux 2 AMI"
  default     = "ami-0e8c04af2729ff1bb"
}

variable "instance_type"           { default = "t2.nano" }
variable "key_name"                { default = "ec2Key" }
variable "subnet_count"            { default = "1" }
variable "private_subnet_count"    { default = "1" }

variable "vpc_cidr"                { default = "10.1.0.0/16" }
variable "public_cidrs"            {
  type    = "list"
  default = ["10.1.1.0/24"]
}
variable "private_cidrs"           {
  type    = "list"
  default = ["10.1.2.0/24"]
}

#ASG
variable "min_size"                { default = "2" }
variable "max_size"                { default = "4" }

#ALB
variable "alb_name"                { default = "MyTestAlb" }
variable "target_group"            { default = "MyTestTargetGroup" }
variable "svc_port"                { default = 80 }
variable "lb_listener_port"        { default = 80 }
variable "lb_listener_protocol"    { default = "HTTP" }

#DB
variable "storage"                 { default = "50" }
variable "storage_type"            { default = "gp2" }
variable "engine"                  { default = "mysql" }
variable "engine_version"          { default = "5.7"}
variable "db_instance_class"       { default = "db.m5.xlarge"}
variable "db_name"                 { default = "myTestDb"}
variable "username"                { default = "shan" }
variable "password"                { default = "shantest11" }
