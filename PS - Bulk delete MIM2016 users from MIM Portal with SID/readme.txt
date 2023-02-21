Powershell Script to delete orphaned users from MIM Portal 

Input: csv file with orphaned portal objectSids from users and groups that were provisioned into the MIM Service/Portal by the Sync engine, but that got orphaned because missing connections in other connected platforms in MIM Sync

 

 

<#
Useful links
http://www.wapshere.com/missmiis/using-powershell-to-update-fim-portal-objects-from-a-csv
https://social.technet.microsoft.com/Forums/en-US/a5486d43-7e76-4d1e-b906-9fbecf6a600a/using-powershell-to-delete-a-user-in-the-fim-portal?forum=ilm2
https://www.petri.com/powershell-import-csv-cmdlet-parse-comma-delimited-csv-text-file
#>
#----------------------------------------------------------------------------------------------------------
 set-variable -name URI -value "http://localhost:5725/resourcemanagementservice' " -option constant
#----------------------------------------------------------------------------------------------------------
 function DeleteObject
 {
    PARAM($objectId  , $objectType)
    END
    {
       $importObject = New-Object Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject
       $importObject.ObjectType = $objectType
       $importObject.TargetObjectIdentifier = $objectId
       $importObject.SourceObjectIdentifier = $objectId
       $importObject.State = 2
       $importObject | Import-FIMConfig -uri $URI
     }
 }
#----------------------------------------------------------------------------------------------------------
 if(@(get-pssnapin | where-object {$_.Name -eq "FIMAutomation"} ).count -eq 0) {add-pssnapin FIMAutomation}
 clear-host
 # the script will look for a CSCV file that will contain the objects to delete
 if($args.count -ne 1) {throw "Missing file parameter"}
 $CSVFile = $args[0]
 # Parse CSV file. Note we're not using import-csv because we don't know what the column headers will be.
$CSVlist = Import-Csv $CSVFile
$CSVList
foreach ($object in $csvlist)
{
<#Installer Account / Default Admin: 7fb2b853-24f0-4498-9534-4e10589723c4
Built-in Synchronization Account : fb89aefa-5ea1-47f1-8890-abe7797d6497
FIM Service Account : e05d1f1b-3d5e-4014-baa6-94dee7d68c89
Anonymous : b0b36673-d43b-4cfa-a7a2-aff14fd90522
#>
 $object
 if(0 -eq [String]::Compare($object.rdn,"7fb2b853-24f0-4498-9534-4e10589723c4", $true))
 {throw "You can't delete the Installer account"}
 
 if(0 -eq [String]::Compare($object.rdn,"fb89aefa-5ea1-47f1-8890-abe7797d6497", $true))
 {throw "You can't delete Built-in Synchronization Account"}
 if(0 -eq [String]::Compare($object.rdn,"e05d1f1b-3d5e-4014-baa6-94dee7d68c89", $true))
 {throw "You can't delete the FIM Servcie Account"}
 
 if(0 -eq [String]::Compare($object.rdn,"b0b36673-d43b-4cfa-a7a2-aff14fd90522", $true))
 {throw "You can't delete Anonymous"}

try
{
 DeleteObject -objectType $object.ObjectType -objectId $object.rdn
 write-host "`nObject Deleted successfully`n"
 }
#----------------------------------------------------------------------------------------------------------
 catch
 {
    $exMessage = $_.Exception.Message
    if($exMessage.StartsWith("L:"))
    {write-host "`n" $exMessage.substring(2) "`n" -foregroundcolor white -backgroundcolor darkblue}
    else {write-host "`nError: " $exMessage "`n" -foregroundcolor white -backgroundcolor darkred}
    Exit
 }
#----------------------------------------------------------------------------------------------------------
}