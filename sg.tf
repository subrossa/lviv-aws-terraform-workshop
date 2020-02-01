module "public-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"
  name = "${local.prefix}-public-sg"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  vpc_id = module.vpc.vpc_id
}

module "private-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"

  computed_ingress_with_source_security_group_id = [
    {
      rule = "all-all-tcp"
      source_security_group_id = module.public-sg.this_security_group_id
    }
  ]

  name = "${local.prefix}-private-sg"
  vpc_id = module.vpc.vpc_id
}

module "rds-sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"

  name = "${local.prefix}-postgresql-sg"
  vpc_id = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule = "postgresql-tcp"
      source_security_group_id = module.private-sg.this_security_group_id
    }
  ]
}