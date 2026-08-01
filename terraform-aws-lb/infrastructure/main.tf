module "network" {

  source = "./modules/network"

  project_name = var.project_name

  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs = var.public_subnet_cidrs

  common_tags = local.common_tags

}

module "security" {

  source = "./modules/security"

  project_name = var.project_name

  vpc_id = module.network.vpc_id

  ssh_allowed_cidr = "0.0.0.0/0"

  common_tags = local.common_tags

}

module "compute" {

  source = "./modules/compute"

  project_name = var.project_name

  instance_type = var.instance_type

  key_name = var.key_name

  subnet_ids = module.network.public_subnet_ids

  web_sg = module.security.web_sg

  common_tags = local.common_tags

}

module "alb" {

  source = "./modules/alb"

  project_name = var.project_name

  subnet_ids = module.network.public_subnet_ids

  alb_sg = module.security.alb_sg

  vpc_id = module.network.vpc_id

  instance_ids = module.compute.instance_ids

  common_tags = local.common_tags

}