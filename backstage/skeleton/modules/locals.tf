locals {
    dns_record_items = {
        for record in keys(var.dns_record_items):
            record => lookup(var.dns_record_items, record)
    }

    dns_alias_record_items = {
        for record in keys(var.dns_alias_records):
            record => lookup(var.dns_alias_records, record)
    }

    dns_weighted_record_items = {
        for record in keys(var.dns_weighted_record_items):
            record => lookup(var.dns_weighted_record_items, record)
    }

    security_group_rules_cidr = {
        for rule in keys(var.security_group_rules) :
            rule => lookup(var.security_group_rules, rule) if lookup(var.security_group_rules, rule)["addresses"]["type"] == "cidr_blocks"
    }

    security_group_rules_sg = {
        for rule in keys(var.security_group_rules) :
            rule => lookup(var.security_group_rules, rule) if lookup(var.security_group_rules, rule)["addresses"]["type"] == "source_security_group_id"
    }
}