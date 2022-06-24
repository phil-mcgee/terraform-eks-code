data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "tf-state-ip-172-31-78-18-1656092965593858851"
    region = var.region
    key    = "terraform/terraform_locks_iam.tfstate"
  }
}
