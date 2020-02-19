resource "azurerm_resource_group" "example" {
  name     = "acceptanceTestResourceGroup1"
  location = "West US"
}

resource "azurerm_network_security_group" "testnsg" {
  name                = "testnsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_network_security_rule" "validrule1" {
  name                        = "validrule1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "34"
  source_address_prefixes    = ["10.10.10.10","*"]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.testnsg.name
}

resource "azurerm_network_security_rule" "validrule2" {
  name                        = "validrule2"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = ["10.10.10.10"]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.testnsg.name
}

resource "azurerm_network_security_rule" "invalidrule1" {
  name                        = "invalidrule1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "20-25"
  source_address_prefixes    = ["10.10.10.10","*"]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.testnsg.name
}

resource "azurerm_network_security_rule" "invalidrule2" {
  name                        = "validrule2"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "27"]
  source_address_prefix       = "Any"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.testnsg.name
}

resource "azurerm_network_security_rule" "invalidrule3" {
  name                        = "validrule3"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["18-30", "88"]
  source_address_prefix       = "Any"
  destination_address_prefix  = "0.0.0.0/0"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.testnsg.name
}
