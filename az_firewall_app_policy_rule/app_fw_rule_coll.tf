resource "azurerm_firewall_policy_rule_collection_group" "az_fw_policy_rule_coll_grp" {
  name               = var.az_fw_policy_rule_name
  firewall_policy_id = var.fw_policy_id
  priority           = var.priority_group_rule
  network_rule_collection {
    name     = var.az_fw_policy_net_rule_name
    action   = var.az_fw_policy_net_rule_action
    priority = var.priority_net_rule
    dynamic rule {
    for_each = var.ntwk_rules_data
    content {
      name                  = "${rule.value.rule_name}"
      protocols             = [rule.value.rule_protocols]
      source_addresses      = [rule.value.rule_src_address]
      destination_addresses = [rule.value.rule_dst_address]
      destination_ports     = rule.value.rule_dst_ports
    }
  }
  }

  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 500
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = ["*.microsoft.com"]
    }
  }

}