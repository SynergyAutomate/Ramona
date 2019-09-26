#Enter name of the ResourceGroup in which you have the snapshots
$resourceGroupName ='SynergyTrainingEast'

#Enter name of the snapshot that will be used to create Managed Disks
$snapshotName = 'SYNTRN-DISK-IMAGE'

#Enter name of the Managed Disk
$diskName = 'SYNTRN-VM-01-ManagedDisk'

#Enter size of the disk in GB
$diskSize = '64'

#Enter the storage type for Disk. PremiumLRS / StandardLRS.
$storageType = 'Standard_LRS'

#Enter the Azure region where Managed Disk will be created. It should be same as Snapshot location
$location = 'AustraliaEast'

#Set the context to the subscription Id where Managed Disk will be created
Select-AzureRmSubscription -SubscriptionId 'a37c98ae-984d-4d55-8df1-7e1fb972a805'

#Get the Snapshot ID by using the details provided
$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName 

#Create a new Managed Disk from the Snapshot provided 
$disk = New-AzureRmDiskConfig -AccountType $storageType -Location $location -CreateOption Copy -SourceResourceId $snapshot.Id

New-AzureRmDisk -Disk $disk -ResourceGroupName $resourceGroupName -DiskName $diskName

#Enter the name of an existing virtual network where virtual machine will be created
$virtualNetworkName = 'SynergyTrainingNET'

#Enter the name of the virtual machine to be created
$virtualMachineName = 'SYNTRN-VM-01'

#Provide the size of the virtual machine
$virtualMachineSize = 'Standard_D3_v2'

#Initialize virtual machine configuration
$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $virtualMachineSize

#(Optional Step) Add data disk to the configuration. Enter DataDisk Id
#$VirtualMachine = Add-AzureRmVMDataDisk -VM $VirtualMachine -Name $dataDiskName -ManagedDiskId <DataDisk ResourceID> -Lun "0" -CreateOption "Attach"



#Use the Managed Disk Resource Id to attach it to the virtual machine. Use OS type based on the OS present in the disk - Windows / Linux
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId "/subscriptions/a37c98ae-984d-4d55-8df1-7e1fb972a805/resourceGroups/SynergyTrainingEast/providers/Microsoft.Compute/disks/SYNTRN-VM-01-ManagedDisk" -CreateOption Attach -Windows

#Create a public IP 
$publicIp = New-AzureRmPublicIpAddress -Name ($VirtualMachineName.ToLower()+'_ip') -ResourceGroupName $resourceGroupName -Location $snapshot.Location -AllocationMethod Dynamic

#Get VNET Information
$vnet = Get-AzureRmVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName

# Create NIC for the VM
$nic = New-AzureRmNetworkInterface -Name ($VirtualMachineName.ToLower()+'_nic') -ResourceGroupName $resourceGroupName -Location $snapshot.Location -SubnetId $vnet.Subnets[0].Id

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

#Create the virtual machine with Managed Disk
New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName -Location $snapshot.Location