data "aws_secretsmanager_secret" "secret" {
  name = "roboshop/all"
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}



data "terraform_remote_state" "mutable" {
  backend = "s3"
  config = {
    bucket = "terraform-sfiles"
    key    = "terraform/mutable/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

output "avinash" {
  value = data.terraform_remote_state.mutable
}