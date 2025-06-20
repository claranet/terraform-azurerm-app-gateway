locals {
  subnet_id = var.create_subnet ? one(module.subnet[*].id) : var.subnet_id
}
