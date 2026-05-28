output "vnet_id" {
  description = "ID de la red virtual creada en el módulo network"
  value       = azurerm_virtual_network.vnet.id
}


#output "vnet_name" {
#  description = "Nombre de la red virtual creada en el módulo network"
#  value       = azurerm_virtual_network.vnet.name
#}

#output "vnet_address_space" {
#  description = "Espacio de direcciones de la red virtual creada en el módulo network"
#  value       = azurerm_virtual_network.vnet.address_space
#}


