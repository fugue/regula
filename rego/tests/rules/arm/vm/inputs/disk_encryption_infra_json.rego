# Copyright 2020-2021 Fugue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
package tests.rules.arm.vm.inputs.disk_encryption_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "resources": [
    {
      "apiVersion": "2021-06-01-preview",
      "location": "[resourceGroup().location]",
      "name": "regulavault3",
      "properties": {
        "accessPolicies": [
          {
            "objectId": "[subscription().subscriptionId]",
            "permissions": {
              "certificates": [],
              "keys": [
                "Get",
                "WrapKey",
                "UnwrapKey"
              ],
              "secrets": []
            },
            "tenantId": "[subscription().tenantId]"
          }
        ],
        "enablePurgeProtection": true,
        "enabledForDiskEncryption": true,
        "sku": {
          "family": "A",
          "name": "Standard"
        },
        "tenantId": "[subscription().tenantId]"
      },
      "resources": [
        {
          "apiVersion": "2021-06-01-preview",
          "dependsOn": [
            "Microsoft.KeyVault/vaults/regulavault3"
          ],
          "name": "key1",
          "properties": {
            "keySize": 4096,
            "kty": "RSA"
          },
          "type": "keys"
        },
        {
          "apiVersion": "2021-06-01-preview",
          "dependsOn": [
            "Microsoft.KeyVault/vaults/regulavault3"
          ],
          "name": "secret1",
          "properties": {
            "value": "hunter2"
          },
          "type": "secrets"
        }
      ],
      "type": "Microsoft.KeyVault/vaults"
    },
    {
      "apiVersion": "2021-06-01-preview",
      "dependsOn": [
        "Microsoft.Compute/diskEncryptionSets/regulades1",
        "Microsoft.KeyVault/vaults/regulavault3"
      ],
      "name": "regulavault3/add",
      "properties": {
        "accessPolicies": [
          {
            "objectId": "[reference(resourceId('Microsoft.Compute/diskEncryptionSets', 'regulades1'), '2021-04-01', 'Full').identity.PrincipalId]",
            "permissions": {
              "certificates": [],
              "keys": [
                "Get",
                "WrapKey",
                "UnwrapKey"
              ],
              "secrets": []
            },
            "tenantId": "[subscription().tenantId]"
          }
        ]
      },
      "type": "Microsoft.KeyVault/vaults/accessPolicies"
    },
    {
      "apiVersion": "2021-04-01",
      "dependsOn": [
        "Microsoft.KeyVault/vaults/regulavault3/keys/key1"
      ],
      "identity": {
        "type": "SystemAssigned"
      },
      "location": "[resourceGroup().location]",
      "name": "regulades1",
      "properties": {
        "activeKey": {
          "keyUrl": "[reference(resourceId('Microsoft.KeyVault/vaults/keys', 'regulavault3', 'key1'), '2021-06-01-preview', 'Full').properties.keyUriWithVersion]",
          "sourceVault": {
            "id": "[resourceId('Microsoft.KeyVault/vaults', 'regulavault3')]"
          }
        }
      },
      "type": "Microsoft.Compute/diskEncryptionSets"
    },
    {
      "apiVersion": "2021-04-01",
      "comments": "Encrypted inline, unattached",
      "dependsOn": [
        "Microsoft.KeyVault/vaults/regulavault3/secrets/secret1"
      ],
      "location": "[resourceGroup().location]",
      "name": "reguladisk1",
      "properties": {
        "creationData": {
          "createOption": "Empty"
        },
        "diskSizeGB": 2,
        "encryptionSettingsCollection": {
          "enabled": true,
          "encryptionSettings": [
            {
              "diskEncryptionKey": {
                "secretUrl": "[reference(resourceId('Microsoft.KeyVault/vaults/secrets', 'regulavault3', 'secret1'), '2021-06-01-preview', 'Full').properties.secretUriWithVersion]",
                "sourceVault": {
                  "id": "[resourceId('Microsoft.KeyVault/vaults', 'regulavault3')]"
                }
              }
            }
          ]
        }
      },
      "type": "Microsoft.Compute/disks"
    },
    {
      "apiVersion": "2021-04-01",
      "comments": "Encrypted using DES, attached as data disk",
      "dependsOn": [
        "Microsoft.Compute/diskEncryptionSets/regulades1",
        "Microsoft.KeyVault/vaults/regulavault3/accessPolicies/add"
      ],
      "location": "[resourceGroup().location]",
      "name": "reguladisk2",
      "properties": {
        "creationData": {
          "createOption": "Empty"
        },
        "diskSizeGB": 2,
        "encryption": {
          "diskEncryptionSetId": "[resourceId('Microsoft.Compute/diskEncryptionSets', 'regulades1')]"
        }
      },
      "type": "Microsoft.Compute/disks"
    },
    {
      "apiVersion": "2021-04-01",
      "comments": "Unencrypted, attached as OS disk",
      "location": "[resourceGroup().location]",
      "name": "reguladisk3",
      "properties": {
        "creationData": {
          "createOption": "Empty"
        },
        "diskSizeGB": 2
      },
      "type": "Microsoft.Compute/disks"
    },
    {
      "apiVersion": "2021-04-01",
      "comments": "Unencrypted, attached as data disk",
      "location": "[resourceGroup().location]",
      "name": "reguladisk4",
      "properties": {
        "creationData": {
          "createOption": "Empty"
        },
        "diskSizeGB": 2
      },
      "type": "Microsoft.Compute/disks"
    },
    {
      "apiVersion": "2021-04-01",
      "comments": "Unencrypted, unattached",
      "location": "[resourceGroup().location]",
      "name": "reguladisk5",
      "properties": {
        "creationData": {
          "createOption": "Empty"
        },
        "diskSizeGB": 2
      },
      "type": "Microsoft.Compute/disks"
    },
    {
      "apiVersion": "2018-10-01",
      "location": "switzerlandnorth",
      "name": "regulanet1",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "10.0.0.0/16"
          ]
        },
        "subnets": [
          {
            "name": "subnet1",
            "properties": {
              "addressPrefix": "10.0.0.0/24"
            }
          }
        ]
      },
      "type": "Microsoft.Network/virtualNetworks"
    },
    {
      "apiVersion": "2021-03-01",
      "dependsOn": [
        "Microsoft.Network/virtualNetworks/regulanet1"
      ],
      "location": "[resourceGroup().location]",
      "name": "regulanic1",
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', 'regulanet1', 'subnet1')]"
              }
            }
          }
        ]
      },
      "type": "Microsoft.Network/networkInterfaces"
    },
    {
      "apiVersion": "2021-03-01",
      "dependsOn": [
        "Microsoft.Network/virtualNetworks/regulanet1"
      ],
      "location": "[resourceGroup().location]",
      "name": "regulanic2",
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', 'regulanet1', 'subnet1')]"
              }
            }
          }
        ]
      },
      "type": "Microsoft.Network/networkInterfaces"
    },
    {
      "apiVersion": "2021-03-01",
      "dependsOn": [
        "Microsoft.Network/virtualNetworks/regulanet1"
      ],
      "location": "[resourceGroup().location]",
      "name": "regulanic3",
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', 'regulanet1', 'subnet1')]"
              }
            }
          }
        ]
      },
      "type": "Microsoft.Network/networkInterfaces"
    },
    {
      "apiVersion": "2021-07-01",
      "dependsOn": [
        "Microsoft.Network/networkInterfaces/regulanic1",
        "Microsoft.Compute/disks/reguladisk2",
        "Microsoft.Compute/disks/reguladisk4",
        "Microsoft.Compute/diskEncryptionSets/regulades1",
        "Microsoft.KeyVault/vaults/regulavault3/accessPolicies/add"
      ],
      "location": "[resourceGroup().location]",
      "name": "regulavm1",
      "properties": {
        "hardwareProfile": {
          "vmSize": "Standard_B1s"
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', 'regulanic1')]",
              "properties": {
                "deleteOption": "Detach"
              }
            }
          ]
        },
        "osProfile": {
          "adminPassword": "abcd1234!",
          "adminUsername": "azureuser",
          "computerName": "vm"
        },
        "storageProfile": {
          "dataDisks": [
            {
              "createOption": "Attach",
              "lun": 0,
              "managedDisk": {
                "diskEncryptionSet": {
                  "id": "[resourceId('Microsoft.Compute/diskEncryptionSets', 'regulades1')]"
                },
                "id": "[resourceId('Microsoft.Compute/disks', 'reguladisk2')]"
              }
            },
            {
              "createOption": "Attach",
              "lun": 1,
              "managedDisk": {
                "id": "[resourceId('Microsoft.Compute/disks', 'reguladisk4')]"
              }
            }
          ],
          "imageReference": {
            "offer": "0001-com-ubuntu-server-focal",
            "publisher": "canonical",
            "sku": "20_04-lts-gen2",
            "version": "latest"
          }
        }
      },
      "type": "Microsoft.Compute/virtualMachines"
    },
    {
      "apiVersion": "2021-07-01",
      "dependsOn": [
        "Microsoft.Network/networkInterfaces/regulanic2",
        "Microsoft.Compute/disks/reguladisk3"
      ],
      "location": "[resourceGroup().location]",
      "name": "regulavm2",
      "properties": {
        "hardwareProfile": {
          "vmSize": "Standard_B1s"
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', 'regulanic2')]",
              "properties": {
                "deleteOption": "Detach"
              }
            }
          ]
        },
        "storageProfile": {
          "dataDisks": [],
          "osDisk": {
            "createOption": "Attach",
            "managedDisk": {
              "id": "[resourceId('Microsoft.Compute/disks', 'reguladisk3')]"
            },
            "osType": "Linux"
          }
        }
      },
      "type": "Microsoft.Compute/virtualMachines"
    },
    {
      "apiVersion": "2021-07-01",
      "dependsOn": [
        "Microsoft.Network/networkInterfaces/regulanic3"
      ],
      "location": "[resourceGroup().location]",
      "name": "regulavm3",
      "properties": {
        "hardwareProfile": {
          "vmSize": "Standard_B1s"
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', 'regulanic3')]",
              "properties": {
                "deleteOption": "Detach"
              }
            }
          ]
        },
        "osProfile": {
          "adminPassword": "abcd1234!",
          "adminUsername": "azureuser",
          "computerName": "vm"
        },
        "storageProfile": {
          "dataDisks": [
            {
              "createOption": "Empty",
              "diskSizeGB": 2,
              "lun": 0
            }
          ],
          "imageReference": {
            "offer": "0001-com-ubuntu-server-focal",
            "publisher": "canonical",
            "sku": "20_04-lts-gen2",
            "version": "latest"
          }
        }
      },
      "type": "Microsoft.Compute/virtualMachines"
    }
  ]
}

