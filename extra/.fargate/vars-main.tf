# TF_VAR_region
variable "region" {
  description = "The name of the AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "The name of the AWS profile in the credentials file"
  type        = string
  default     = "default"
}

variable "cluster-name" {
  description = "The name of the EKS Cluster"
  type        = string
  default     = "tfeks-cluster"
}


variable "eks_version" {
  type    = string
  default = "1.22"
}


variable "stages" {
type=list(string)
default=["net","iam","c9net","cluster","nodeg","cicd","eks-cidr","sampleapp"]
}

variable "stagecount" {
type=number
default=8
}

variable "no-output" {
  description = "A secret variable"
  type        = string
  default     = "secret"
  sensitive   = true
}

