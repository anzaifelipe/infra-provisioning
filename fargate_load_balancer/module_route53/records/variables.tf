variable dns_record_items {
    description = "Map of DNS records"
    type = map
    default = {}
}

variable dns_alias_records {
    description = "Map of DNS alias records"
    type = map
    default = {}
}

variable dns_weighted_record_items {
    description = "Map of DNS Weighted records"
    type = map
    default = {}
}


variable zone_id {
    description = "ID of Route53 zone"
    type = string
}