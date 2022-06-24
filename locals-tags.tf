locals {
  default_tags = var.default_tags_enabled ? {
    env   = var.environment
    stack = var.stack
  } : {}

  extra_tags = merge(local.default_tags, var.extra_tags)

  app_gateway_tags = merge(local.extra_tags, var.app_gateway_tags)
  ip_tags          = merge(local.extra_tags, var.ip_tags)
  nsg_tags         = merge(local.extra_tags, var.nsg_tags)
}
