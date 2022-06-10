# New VM In PowerShell:

# Declare Variables Here From User Input.
#
$VMName = Read-Host -Prompt "Enter VM Name "
$Ram = Read-Host -Prompt "Enter Ram Required(gb) "
#$VMPath = Read-Host -Prompt "Enter Path to Store VM "
$OSDrive = Read-Host -Prompt "Enter OS Drive Size(gb) "
$DataDrive = Read-Host -Prompt "Enter Data Drive Size(gb) "
$ISOPath = Read-Host -Prompt "Enter Path to ISO "
$vSwitch = Read-Host -Prompt "Enter vSwitch Name "
$vCPU = Read-host -Prompt "Enter Number of vCPUs "


# Create New VM
New-VM -Name $VMName -MemoryStartupBytes $Ram -Generation 2 -SwitchName $vSwitch -NewVHDPath "E:\Hyper-V\Virtual Hard Disks\$VMName\C_DRIVE.vhdx" -NewVHDSizeBytes $OSDrive

#Remove Existing DVD Drive.
#Remove-VMDvdDrive -VMName "$VMName" -ControllerNumber 1 -ControllerLocation 0

# Add DVD Drive and Path to ISO.
Get-VM $VMName | Add-VMDvdDrive -Path "$ISOPath"

# Add a Data Drive.

if (-not ($DataDrive -eq $null)){
     # If Data Drive Required.
     New-VHD -Path "E:\Hyper-V\Virtual Hard Disks\$VMName\E_DRIVE.vhdx" -SizeBytes $DataDrive -Dynamic
     Add-VMHardDiskDrive -VMName "$VMName" -Path "E:\Hyper-V\Virtual Hard Disks\$VMName\E_DRIVE.vhdx"
 }


# Set Proccesor Count vCPU
Set-VM -Name $VMName -ProcessorCount $vCPU

$OsDvdDrive = Get-VMDvdDrive -VMName $VMName -ControllerNumber 0
Set-VMFirmware -VMName $VMName -FirstBootDevice $OSDvdDrive 
