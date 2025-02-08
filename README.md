# Automated EKS Cluster Deployment on AWS using Terraform and Helm

This repository contains a Terraform module to create and manage an **Elastic Kubernetes Service (EKS)** cluster on AWS, with **Helm** integration for automated application deployment. The module automates the setup of resources such as VPC, subnets, security groups, worker nodes, and the installation of the **AWS Load Balancer Controller** via Helm.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.85.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 3.0.0-pre1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.35.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_aws_load_balancer_controller"></a> [eks\_aws\_load\_balancer\_controller](#module\_eks\_aws\_load\_balancer\_controller) | ./modules/aws-load-balancer-controller | n/a |
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | ./modules/cluster | n/a |
| <a name="module_eks_managed_node_group"></a> [eks\_managed\_node\_group](#module\_eks\_managed\_node\_group) | ./modules/managed-node-group | n/a |
| <a name="module_eks_network"></a> [eks\_network](#module\_eks\_network) | ./modules/network | n/a |

## How to Use

1. **Clone the repository**:
   ```bash
   git clone git@github.com:dgnnj/terraform-eks.git
   cd terraform-eks
   ```
2. **Use variables.tfvars to configure your variables**:
   ```hcl
   cidr_block     = "10.0.0.0/16"
   project_name   = "my-project"
   region         = "us-east-1"
   tags = {
     Department   = "DevOps"
   }
   ```
3. **Initialize Terraform**:
   ```bash
   terraform init
   ```
4. **Plan the execution**:
   ```bash
   terraform plan -var-file variables.tfvars
   ```
5. **Apply the changes**:
   ```bash
   terraform apply -var-file variables.tfvars
   ```
6. **Destroy the changes**:
   ```bash
   terraform destroy -var-file variables.tfvars
   ```
This will create the EKS cluster, worker nodes, and install the AWS Load Balancer Controller via Helm.
  
## Configuration Variables

Here are the variables you can configure in the `variables.tfvars` file:

`cidr_block`: The CIDR block for the VPC (e.g., `10.0.0.0/16`).

`project_name`: The name of the project (e.g., my-project).

`region`: The AWS region where the cluster will be created (e.g., `us-east-1`).

`tags`: Default tags for the created resources (e.g., `Department = "DevOps"`).

## Additional Examples

## Steps to Migrate the State to S3

1. **Update the backend Configuration**:
   - Add the `backend "s3"` block to your Terraform configuration file, typically in the `providers.tf` file (as shown above).
       ```bash
      terraform {
        required_providers {
          ...
        }
        backend "s3" {
          bucket = "my-project"
          key    = "example/terraform.tfstate"
          region = "your-region"
        }
      }
      ```
   - Replace `my-project`, `example/terraform.tfstate`, and `your-region` with your actual S3 bucket name, state file path, and AWS region.

2. **Initialize Terraform and Migrate the State**:
   - Run the following command to initialize Terraform and migrate the existing state to the S3 bucket:
     ```bash
     terraform init -migrate-state
     ```
   - Terraform will detect that you are changing the backend and prompt you to confirm the migration. Type `yes` to proceed.

3. **Verify the Migration**:
   - After the migration, Terraform will store the state file in the specified S3 bucket.
   - You can check the bucket to ensure the `terraform.tfstate` file has been created.

4. **Continue Using Terraform**:
   - Now, all future Terraform operations (e.g., `plan`, `apply`) will use the state file stored in S3.

## Why Use S3 for Terraform State?

- **Team Collaboration**: Multiple team members can access the same state file.
- **State Locking**: Prevents conflicts when multiple users try to modify the infrastructure simultaneously.
- **Durability and Backup**: S3 provides a reliable and durable storage solution for your state files.

## Contribution

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

<!-- END_TF_DOCS -->
