resource "null_resource" "null" {
  count = length(data.aws_instances.mutable.private_ips)
  triggers = {
    a = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_USER"]
      password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_PASS"]
      host     = data.aws_instances.mutable.private_ips[count.index]
#      The above host line can also be written as
#     host = element(data.aws_instances.mutable.private_ips, count.index)
    }

    inline = [
      "ansible-pull -U https://github.com/GurukaYadav/roboshop-ansible.git roboshop.yml -e HOST=localhost -e ROLE=${var.COMPONENT} -e ENV=${var.ENV} -e DOCDB_ENDPOINT=${data.terraform_remote_state.mutable.outputs.DOCDB_ENDPOINT} -e REDIS_ENDPOINT=${data.terraform_remote_state.mutable.outputs.REDIS_ENDPOINT} -e RDS_ENDPOINT=${data.terraform_remote_state.mutable.outputs.RDS_ENDPOINT}"
    ]
  }
}