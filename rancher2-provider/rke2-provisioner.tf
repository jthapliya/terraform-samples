terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.21.0"
    }
  }
}

provider "rancher2" {
  # Configuration options
  api_url    = "RANCHER_APP_URL"
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
}

# Create amazonec2 cloud credential
resource "rancher2_cloud_credential" "tfp-aws-creds" {
  name = "tfp-aws-creds-test"
  amazonec2_credential_config {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}

# Create amazonec2 machine config v2
resource "rancher2_machine_config_v2" "tfp-rke2-mc-config" {
  generate_name = "tfp-rke2-mc-config-test"
  amazonec2_config {
    ami            = "ami-547a9325"
    region         = "us-gov-east-1"
    security_group = ["rancher-nodes"]
    subnet_id      = "subnet-05271819e52bddce5"
    vpc_id         = "vpc-0e4465562b3bf481f"
    zone           = "a"
    ssh_user       = "ec2-user"
    instance_type  = "t3.xlarge"
  }
}

# Create a new rancher v2 amazonec2 RKE2 Cluster v2
resource "rancher2_cluster_v2" "tfp-rke2-cluster" {
  name                                     = "tfp-rke2-cluster-test"
  kubernetes_version                       = "v1.22.10+rke2r2"
  enable_network_policy                    = false
  default_cluster_role_for_project_members = "user"
  rke_config {
    machine_pools {
      name                         = "pool1"
      cloud_credential_secret_name = rancher2_cloud_credential.tfp-aws-creds.id
      control_plane_role           = true
      etcd_role                    = true
      worker_role                  = true
      quantity                     = 3
      machine_config {
        kind = rancher2_machine_config_v2.tfp-rke2-mc-config.kind
        name = rancher2_machine_config_v2.tfp-rke2-mc-config.name
      }
    }
    upgrade_strategy {
      control_plane_concurrency = 1
      worker_concurrency = "10%"
    }
  }
}
