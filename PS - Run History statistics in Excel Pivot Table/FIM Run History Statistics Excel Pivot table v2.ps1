param(  
    [string]   $ComputerName = '.',  
   [string[]] $MaName       = $null,  
   [string[]] $RunProfile   = $null
   )  
  
process {

    cls

    #Do you want to enable transcript for logging all output to file?
    $enableLogging = $TRUE
    $ExportEnabled = $FALSE

    # logging
    # if you need detailed logging for troubleshooting this script, you can enable the transcript
    # get the script location path and use it as default location for storing logs and results 
    $log = $MyInvocation.MyCommand.Definition -replace 'ps1','log'
    $resultPath = $PSScriptRoot + '\'
    Push-Location $resultPath

    if ($enableLogging) 
    {
    Start-Transcript -Path $log -ErrorAction SilentlyContinue
    Write-Host "Logging enabled..."
    Write-Host

    Write-Host "Powershell version"
    $PSVersionTable.PSVersion
    $Host.Version
    (Get-Host).Version
    Write-host
    }

    ## define the target XLS file
    ## where the run history data and their pivot tables will be created
    $file = $MyInvocation.MyCommand.Definition -replace 'ps1','xlsx'
    rm $file -ErrorAction Ignore
          
    #first collect the current run profiles from the FIM Sync serverserver
        
    #Get-WmiObject
    #-Computername $computername
    #default this script calls the local server for the FIM Services

    #skip the runprofiles currently running
    # -Filter 'RunStatus != "in-progress"
    $allrunprofiles =  Get-WmiObject -Computername $computername -Class 'MIIS_RunHistory' -Namespace 'root\MicrosoftIdentityIntegrationServer' -Filter 'RunStatus != "in-progress"' `
    |? {([int]$MaName.Count -eq 0 -or $MaName -contains $_.MaName) -and ([int]$RunProfile.Count -eq 0 -or $RunProfile -contains $_.RunProfile) } 
    
    #we also want to know the first and last date in the run profile collection
    #to find them filter the run profile properties on startdate only
    #and sort them ascending (default)
    $dates = $allrunprofiles | Select-Object -Property @{Name='RunTime';Expression={[DateTime]::Parse($_.RunStartTime)}}| Sort-Object -Property RunTime
     
    $firstdate = $dates | Select-Object -Expand RunTime -First 1
    $firstdate.DateTime

    $lastdate = $dates | Select-Object -Expand RunTime -Last 1
    $lastdate.DateTime

    #report the start date to the Excel sheet
    $firstdate.ToString() | Export-Excel $file -WorkSheetname 'StartDate'

    #report the end date to the Excel sheet
    $lastdate.ToString() | Export-Excel $file -WorkSheetname 'LastDate'

    #next collect the data of the run profile to report on
    # MA Name
    # Run Profile Name
    # Run status
    # start date/time
    # end date/time
    # run time  -> for statistics

    $runprofiles = `        $allrunprofiles | `        Select-Object -Property MaName,RunProfile,RunStatus,RunStartTime,RunEndTime,@{Name='RunTime';Expression={[DateTime]::Parse($_.RunEndTime).Subtract([DateTime]$_.RunStartTime)}}`
        |? {([int]$MaName.Count -eq 0 -or $MaName -contains $_.MaName) -and ([int]$RunProfile.Count -eq 0 -or $RunProfile -contains $_.RunProfile) }


    #process all runprofile data

    #first process successful runs only
    #failed or error run profile executions might impact the run time calculations
    $selection = $runprofiles | where {$_.RunStatus -eq 'success'}
    
    #if you want to include the error run profiles
    #comment out previous statement
    # and remove comments of next line
    # $selection = $runprofiles
    
    $selection |
      Export-Excel $file -WorksheetName 'Min' `
        -IncludePivotTable `
        -PivotRows MaName `
        -PivotColumns RunProfile `
        -PivotData @{RunTime='Min'} `
        -PivotDataToColumn `
        -Numberformat 'uu:mm:ss'
        
    $selection |
      Export-Excel $file -WorksheetName 'Max' `
        -IncludePivotTable `
        -PivotRows MaName `
        -PivotColumns RunProfile `
        -PivotData @{RunTime='Max'} `
        -PivotDataToColumn `
        -Numberformat 'uu:mm:ss'

    $selection |
      Export-Excel $file -WorksheetName 'Average' `
        -IncludePivotTable `
        -PivotRows MaName `
        -PivotColumns RunProfile `
        -PivotData @{RunTime='Average'} `
        -PivotDataToColumn `
        -Numberformat 'uu:mm:ss'
        
    #process error data
    # the section below focusses specifically on error data
    # to get an overview of the error count and error types
    $selection = $runprofiles | where {$_.RunStatus -ne 'success'}
    
    $selection |
      Export-Excel $file -WorksheetName 'Errors' `
        -IncludePivotTable `
        -PivotRows MaName `
        -PivotColumns RunProfile `
        -PivotData @{RunTime='Count'} `
        -PivotDataToColumn `
        -Numberformat 'uu:mm:ss'

    $selection |
      Export-Excel $file -WorksheetName 'ErrorTypes' `
        -IncludePivotTable `
        -PivotRows MaName `
        -PivotColumns RunStatus `
        -PivotData @{RunStatus='Count'} `
        -PivotDataToColumn `
        -Numberformat 'uu:mm:ss'
}  
