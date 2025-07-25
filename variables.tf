// variables.tf
variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-020cba7c55df1f615"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"  # or any CIDR you prefer
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "key_name" {
  default = "N.V"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "movie-ticket-app"
}

# variables.tf

variable "db_user" {
  description = "The master username for the RDS DB"
  type        = string
  default = "dbadmin"
}

variable "db_password" {
  description = "The master password for the RDS DB"
  type        = string
  sensitive   = true
  default = "password123"
}
