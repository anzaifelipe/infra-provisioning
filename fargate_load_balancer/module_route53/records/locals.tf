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
}