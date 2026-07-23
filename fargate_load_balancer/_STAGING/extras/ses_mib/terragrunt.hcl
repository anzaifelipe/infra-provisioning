locals {
  enabled   = true
  dns       = read_terragrunt_config(find_in_parent_folders("dns.hcl"))
  zone_id   = local.dns.locals.dns.zone_id
  zone_name = local.dns.locals.dns.zone_name
  sender    = read_terragrunt_config(find_in_parent_folders("mail.hcl"))
  mail      = local.sender.locals.mail
}

include {
    path = find_in_parent_folders()
}

terraform {
    source = local.enabled ? "../../../module_ses" : null
}

inputs = {
    domain              = local.zone_name
    verify_dkim         = true
    verify_domain       = true
    zone_id             = local.zone_id
    mail_from           = null
    #mails_list          = [local.mail]
}