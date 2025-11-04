# Lab 05 – K3s on EC2 with OpenFaaS (Terraform + Ansible)

## Structure
- `terraform/`: create 2 EC2 instances (master, worker) dynamically in default VPC.
- `ansible/`: configure K3s server/agent, install Dashboard & OpenFaaS, deploy hello-python function.
- `commands/`: `lab5_manual_commands.cmd` with step-by-step commands for report screenshots.

## Quick start
1. `cd terraform && terraform init && terraform apply -auto-approve`
2. `terraform output -raw ansible_inventory > ../ansible/inventory.ini`
3. `cd ../ansible && ansible-playbook -i inventory.ini playbook.yml`
4. Verify:
   - `ssh ubuntu@<master_ip>` (use your key)
   - `kubectl get nodes -o wide`
   - `kubectl -n kubernetes-dashboard create token admin-user`
   - `GW=$(kubectl -n openfaas get svc gateway -o jsonpath='{.spec.ports[0].nodePort}')`
   - `curl http://127.0.0.1:$GW/function/hello-python -d "UIT"`

## Notes
- Region defaults to ap-southeast-1, Ubuntu 22.04 AMI set accordingly.
- SSH key paths default to `../key/nt533-key(.pub)`—adjust in variables if needed.
- For the lab report, you can re-run each step manually using the commands in `commands/`.
