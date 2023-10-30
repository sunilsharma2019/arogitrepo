#resource "random_password" "vm_password" {
#  count            = var.nb_instances
#  length           = 16
#  special          = true
#  override_special = "!#$%&*()-_=+[]{}<>:?"
#}
#resource "azurerm_key_vault_secret" "vm_pwd" {
#  count        = var.nb_instances  
#  name         = "${var.vm_hostname}-${count.index}"
#  value        = random_password.vm_password[count.index].result
#  key_vault_id = var.key_vault_id
#}

resource "azurerm_public_ip" "vm_public_ip" {
  count              = ((var.allot_pip && var.nb_instances > 0) == true) ? var.nb_instances : 0
  name = (
    (count.index >= 99) ?
      "${var.vm_hostname}-${count.index + 1}-pip" :
    (count.index >= 9) ?
      "${var.vm_hostname}-0${count.index + 1}-pip" :
      "${var.vm_hostname}-00${count.index + 1}-pip"
    
  )
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = var.tags
}

resource "azurerm_network_interface" "vm_nic" {
  count                         = var.nb_instances
#  name                          = "${var.vm_hostname}-nic-${count.index}"
  name = (
    (count.index >= 99) ?
      "${var.vm_hostname}-nic-${count.index + 1}" :
    (count.index >= 9) ?
      "${var.vm_hostname}-nic-0${count.index + 1}" :
      "${var.vm_hostname}-nic-00${count.index + 1}"
    
  )
  location                      = var.resource_group.location
  resource_group_name           = var.resource_group.name
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name = (
      (count.index >= 99) ?
        "${var.vm_hostname}-ip-${count.index + 1}" :
      (count.index >= 9) ?
        "${var.vm_hostname}-ip-0${count.index + 1}" :
        "${var.vm_hostname}-ip-00${count.index + 1}"
      
    )
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = (var.allot_pip == true) ? azurerm_public_ip.vm_public_ip[count.index].id : null
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "vm_nic_sg_attach" {
  count                     = var.nb_instances
  network_interface_id      = azurerm_network_interface.vm_nic[count.index].id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_virtual_machine" "vm-linux" {
  count                            = var.nb_instances
  name = (
    (count.index >= 99) ?
      "${var.vm_hostname}-${count.index + 1}" :
    (count.index >= 9) ?
      "${var.vm_hostname}-0${count.index + 1}" :
      "${var.vm_hostname}-00${count.index + 1}"
    
  )
  location                         = var.resource_group.location
  resource_group_name              = var.resource_group.name
  vm_size                          = var.vm_size[count.index]
  network_interface_ids            = [element(azurerm_network_interface.vm_nic.*.id, count.index)]
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination
  zones                            = [("${(count.index + 1) % 3 }" == 0) ? "3" : "${(count.index + 1) % 3 }"]

  storage_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  storage_os_disk {
    name = (
      (count.index >= 99) ?
        "osdisk-${var.vm_hostname}-${count.index + 1}" :
      (count.index >= 9) ?
        "osdisk-${var.vm_hostname}-0${count.index + 1}" :
        "osdisk-${var.vm_hostname}-00${count.index + 1}"
    )
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = var.os_sa_type
    disk_size_gb      = var.os_disk_size_gb
  }

  dynamic storage_data_disk {
    for_each = range(var.nb_data_disk)
    content {
      name = (
        (count.index >= 99) ?
          "${var.vm_hostname}-${count.index + 1}_DataDisk_${storage_data_disk.value}" :
        (count.index >= 9) ?
          "${var.vm_hostname}-0${count.index + 1}_DataDisk_${storage_data_disk.value}" :
          "${var.vm_hostname}-00${count.index + 1}_DataDisk_${storage_data_disk.value}"
      )    
      create_option     = "Empty"
      lun               = storage_data_disk.value
      disk_size_gb      = var.data_disk_size_gb
      managed_disk_type = var.data_sa_type
    }
  }

  dynamic storage_data_disk {
    for_each = var.extra_disks
    content {
      name = (
        (count.index >= 99) ?
          "${var.vm_hostname}-${count.index + 1}_DataDisk_${storage_data_disk.value}" :
        (count.index >= 9) ?
          "${var.vm_hostname}-0${count.index + 1}_DataDisk_${storage_data_disk.value}" :
          "${var.vm_hostname}-00${count.index + 1}_DataDisk_${storage_data_disk.value}"
      )
      create_option     = "Empty"
      lun               = storage_data_disk.key + var.nb_data_disk
      disk_size_gb      = storage_data_disk.value.size
      managed_disk_type = var.data_sa_type
    }
  }

  os_profile {
    computer_name = (
      (count.index >= 99) ?
        "${var.vm_hostname}-${count.index + 1}" :
      (count.index >= 9) ?
        "${var.vm_hostname}-0${count.index + 1}" :
        "${var.vm_hostname}-00${count.index + 1}"
    )
    admin_username = var.admin_username
#    admin_password = azurerm_key_vault_secret.vm_pwd[count.index].value
    custom_data    = var.custom_data
  }

  os_profile_linux_config {
    disable_password_authentication = var.enable_ssh_key

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = var.ssh_key
    }

    dynamic ssh_keys {
      for_each = var.enable_ssh_key ? var.ssh_key_values : []
      content {
        path     = "/home/${var.admin_username}/.ssh/authorized_keys"
        key_data = ssh_keys.value
      }
    }

  }

  boot_diagnostics {
    enabled     = var.boot_diagnostics
    storage_uri = ""
  }

  tags = var.tags

}

resource "azurerm_backup_protected_vm" "vm" {
  count               = var.recovery_vault_name != null ? var.nb_instances : 0
  resource_group_name = var.rsv_resource_group_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = azurerm_virtual_machine.vm-linux[count.index].id
  backup_policy_id    = var.backup_policy_id
}

resource "azurerm_monitor_diagnostic_setting" "vm_ip_diag" {
  count                      = (var.enable_diagnostic == true && var.allot_pip == true) ? length(var.loganalytics_id) : 0
##  count                      = length(var.loganalytics_id)
  name                       = format("diag%s", count.index)
  target_resource_id         = azurerm_public_ip.vm_public_ip[count.index].id
  log_analytics_workspace_id = var.loganalytics_id[count.index]

  log {
    category = "DDoSProtectionNotifications"
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "DDoSMitigationFlowLogs"
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "DDoSMitigationReports"
    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}