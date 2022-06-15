# Create New VM In PowerShell:


Write-Host "`nHyper-V VM Deploy.`r`nCreated By: James Maher 2022`n`r`nNOTE: VHD Path is hardcoded to 'E:\Hyper-V\Virtual Hard Disks\VMName\C_DRIVE.vhdx and E_DRIVE.vhdx if you choose a data drive'`r`n`n[*] Please Enter Required Fields`n" -ForegroundColor Yellow

# Declare Variables Here From User Input.

$VMName = Read-Host -Prompt "Enter VM Name "
$i = Read-Host -Prompt "Enter Ram Required(gb) "
$Ram = [int64]$i * 1GB
#$VMPath = Read-Host -Prompt "Enter Path to Store VM "
$j = Read-Host -Prompt "Enter OS Drive Size(gb) "
$OSDrive = [int64]$j * 1GB

# Do we need a Data Drive? Get answer from User.
if ($Selection -ne "Y" ){
   $Selection = Read-Host "Do you require a Data Drive? (Y/N)"
    Switch ($Selection)
        {
            Y {Write-host "Yes Chosen" -ForegroundColor Green}
            N {Write-Host "No Chosen" -ForegroundColor Yellow}
        }
    If($Selection -eq "Y")
    {
    Write-Host "Provide Data Drive Size in GB" -ForegroundColor Green
    $k = Read-Host -Prompt "Enter Data Drive Size(gb) "
    $DataDrive = [int64]$k * 1GB

    }
    If($Selection -eq "N")
    {
    Write-Host "Continuing with Script"


    }
}

$ISOPath = Read-Host -Prompt "Enter Path to ISO "
$vSwitch = Read-Host -Prompt "Enter vSwitch Name "
$vCPU = Read-host -Prompt "Enter Number of vCPUs "

# Create New VM
New-VM -Name $VMName -MemoryStartupBytes $Ram -Generation 2 -SwitchName $vSwitch -NewVHDPath "E:\Hyper-V\Virtual Hard Disks\$VMName\C_DRIVE.vhdx" -NewVHDSizeBytes $OSDrive

#Remove Existing DVD Drive.
#Remove-VMDvdDrive -VMName "$VMName" -ControllerNumber 1 -ControllerLocation 0

# Add DVD Drive and Path to ISO.
Get-VM $VMName | Add-VMDvdDrive -Path $ISOPath

# Add a Data Drive.

if ( $Selection -eq 'y' )
{
    New-VHD -Path "E:\Hyper-V\Virtual Hard Disks\$VMName\E_DRIVE.vhdx" -SizeBytes $DataDrive -Dynamic
    Add-VMHardDiskDrive -VMName "$VMName" -Path "E:\Hyper-V\Virtual Hard Disks\$VMName\E_DRIVE.vhdx"
}


# Set Proccesor Count vCPU
Set-VM -Name $VMName -ProcessorCount $vCPU

$OsDvdDrive = Get-VMDvdDrive -VMName $VMName -ControllerNumber 0
Set-VMFirmware -VMName $VMName -FirstBootDevice $OSDvdDrive



# Ask the user if the VM should be started? Get answer from User.
$Selection = ''
if ($Selection -ne "Y" ){
   $Selection = Read-Host "Do you want to start $VMName (Y/N)"
    Switch ($Selection)
        {
            Y {Write-host "You Chose: Yes`r`n" -ForegroundColor Green}
            N {Write-Host "You Chose: No`r`n" -ForegroundColor Yellow}
        }
    If($Selection -eq "Y")
        {
        Start-VM -Name $VMName ; vmconnect localhost $VMName
        }
    If($Selection -eq "N")
    {
    Write-Host "[*] $VMName Created Successfully!`n`n`n"
    }
}
