resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "custom_rules" {
  count                                      = length(var.custom_rules)
  name                                       = lookup(var.custom_rules[count.index], "name", "default_rule_name")
  priority                                   = lookup(var.custom_rules[count.index], "priority")
  direction                                  = lookup(var.custom_rules[count.index], "direction", "Any")
  access                                     = lookup(var.custom_rules[count.index], "access", "Allow")
  protocol                                   = lookup(var.custom_rules[count.index], "protocol", "*")
  source_port_range                          = lookup(var.custom_rules[count.index], "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges                         = lookup(var.custom_rules[count.index], "source_port_range", "*") == "*" ? null : split(",", var.custom_rules[count.index].source_port_range)
  destination_port_ranges                    = split(",", replace(lookup(var.custom_rules[count.index], "destination_port_range", "*"), "*","0-65535"))
  source_address_prefix                      = lookup(var.custom_rules[count.index], "source_application_security_group_ids", null) == null && lookup(var.custom_rules[count.index], "source_address_prefixes", null) == null ? lookup(var.custom_rules[count.index], "source_address_prefix", "*") : null
  source_address_prefixes                    = lookup(var.custom_rules[count.index], "source_application_security_group_ids", null) == null ? lookup(var.custom_rules[count.index], "source_address_prefixes", null) : null
  destination_address_prefix                 = lookup(var.custom_rules[count.index], "destination_application_security_group_ids", null) == null && lookup(var.custom_rules[count.index], "destination_address_prefixes", null) == null ? lookup(var.custom_rules[count.index], "destination_address_prefix", "*") : null
  destination_address_prefixes               = lookup(var.custom_rules[count.index], "destination_application_security_group_ids", null) == null ? lookup(var.custom_rules[count.index], "destination_address_prefixes", null) : null
  description                                = lookup(var.custom_rules[count.index], "description", "Security rule for ${lookup(var.custom_rules[count.index], "name", "default_rule_name")}")
  resource_group_name                        = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name                = azurerm_network_security_group.nsg.name
  source_application_security_group_ids      = lookup(var.custom_rules[count.index], "source_application_security_group_ids", null)
  destination_application_security_group_ids = lookup(var.custom_rules[count.index], "destination_application_security_group_ids", null)
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_association" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}