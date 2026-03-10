variable "region" {
  description = "AWS Region"
  default     = "eu-north-1"
}

variable "template_bucket_name" {
    description = "S3 Bucket for Cloudformation Name"
    type = string
}

variable "initial_template_file" {
    description = "Cloudformation template path for Initial Version of Product"
    type = string
}

variable "template_vars" {
  description = "Variables for Template File funtion"
  type = map(any)
  default = {}
}

variable "ec2_product_versions" {
  description = "Map of product version names to template file paths"
  type        = map(string)
}

variable "product_name" {
    description = "EC2 Product name"
    type = string
}

variable "product_owner" {
    description = "Product Owner Name"
    type = string
}

variable "portfolio_name" {
    description = "EC2 Portfolio name"
    type = string
}

variable "principal_arn" {
  description = "ARN of the IAM principal (user, role, or root) to associate with the portfolio"
  type        = list(string)
}

variable "constraint_type" {
    description = "Service Catalog Constraint Type"
    type = string
    default = "LAUNCH"

    validation {
      condition = contains(["LAUNCH", "NOTIFICATION", "STACKSET"], var.constraint_type)
      error_message = "constraint_type must be LAUNCH, NOTIFICATION, or STACKSET."
    }
}

variable "launch_role_name" {
  description = "Name of the IAM role used as the Service Catalog launch role"
  type        = string
}