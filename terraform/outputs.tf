# Ansible inventory output
output "ansible_inventory" {
  value = <<EOT
[master]
${aws_instance.master.public_ip} ansible_user=ubuntu master_private_ip=${aws_instance.master.private_ip}

[worker]
${aws_instance.worker.public_ip} ansible_user=ubuntu

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT
}

output "master_public_ip" {
  value = aws_instance.master.public_ip
}
output "worker_public_ip" {
  value = aws_instance.worker.public_ip
}
