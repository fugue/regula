package rules.virtual_machine_vmsize

resource_type = "Microsoft.Compute/virtualMachines"
input_type = "arm"

default allow = false

allow {
    input.properties.hardwareProfile.vmSize == "Standard_A0"
}