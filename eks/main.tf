data "aws_caller_identity" "current" {}

module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "~> 20.31"
  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true # Enable public access to the API server
  authentication_mode                      = "API"
  cluster_name                             = "dummy-cluster"
  cluster_version                          = "1.31"
  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.public_subnets
  kms_key_owners                           = [data.aws_caller_identity.current.arn]
  eks_managed_node_groups = {
    medium = {
      enable_monitoring = false
      instance_types    = ["t3.medium"] # Changed to t3.medium
      min_size          = 1
      max_size          = 1
      desired_size      = 1
      disk_size         = 20
      labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
      subnet_ids = module.vpc.public_subnets # Add this to ensure nodes can be created in public subnets
    }
  }

  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
      configuration_values = jsonencode({
        env = {
          # https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "dummy-vpc"
  cidr   = "10.0.0.0/16"

  azs            = ["us-west-2a", "us-west-2b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_dns_support      = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true # Enable auto-assign public IPs

  public_subnet_tags = { # Required tags for EKS
    "kubernetes.io/cluster/dummy-cluster" = "shared"
    "kubernetes.io/role/elb"              = "1"
  }
}