variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI ID for region"
  type        = string
  default     = "ami-0df7a207adb9748c7"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Key pair name"
  type        = string
  default     = "lab5-key"
}

variable "public_key_path" {
  description = "Path to .pub"
  type        = string
  default     = "../key/nt533-key.pub"
}

variable "private_key_path" {
  description = "Path to private key (.pem) for SSH commands"
  type        = string
  default     = "../key/nt533-key"
}
