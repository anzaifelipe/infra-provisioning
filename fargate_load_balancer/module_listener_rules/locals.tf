locals {
    rule_hosted_based = {
        for rule in keys(var.rule_hosted_based):
            rule => lookup(var.rule_hosted_based, rule)
    }
}