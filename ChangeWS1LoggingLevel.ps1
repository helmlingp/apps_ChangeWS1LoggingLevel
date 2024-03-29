<#
.Synopsis
    This Powershell script should be used to change the logging level of the Workspace ONE UEM Agent logs
 .NOTES
    Created:   	    February, 2021
    Created by:	    Phil Helmling, @philhelmling
    Organization:   VMware, Inc.
    Filename:       ChangeWS1LoggingLevel.ps1
    GitHub:         https://github.com/helmlingp/apps_ChangeWS1LoggingLevel
.DESCRIPTION
    Change the logging level of the Workspace ONE UEM Agent logs by editing the WS1 Agent config file(s)
    in C:\ProgramFiles(x86)\Airwatch\AgentUI

.EXAMPLE
    .\ChangeWS1LoggingLevel.ps1 -ConfigFile TaskScheduler.exe.config -Level Debug
    .\ChangeWS1LoggingLevel.ps1 -ConfigFile TaskScheduler.exe.config -Level Information
    .\ChangeWS1LoggingLevel.ps1 -ConfigFile All -Level Debug
#>
param (
    [Parameter(Mandatory=$true)]
    [string]$ConfigFile=$script:ConfigFile,
    [Parameter(Mandatory=$true)]
    [string]$Level=$script:Level
)
if($script:ConfigFile -eq 'All'){$script:ConfigFile='*.config'}

$path = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath "Airwatch\AgentUI"
Get-ChildItem $path\$script:ConfigFile -Recurse | ForEach-Object {
    [xml]$xml = Get-Content -Path $_.FullName
    #Test for old path in XML
    $node = $xml.configuration.loggingConfiguration
    if($node){
        # change attribute on selected node
        if(!$node){
            write-host "no logging config in file $_"
        }else{
            $before = $node.level
            write-host "Before: $before"
            $node.level=$script:Level
            $xml.Save($_.FullName)
            $after = $node.level
            write-host "After: $after"
        }
    } else {
        $node = $xml.configuration.appSettings.add | Where-Object {$_.key -eq "serilog:minimum-level"}
        # change attribute on selected node
        if(!$node){
            write-host "no logging config in file $_"
        }else{
            $before = $node.value
            write-host "Before: $before"
            $node.value=$script:Level
            $xml.Save($_.FullName)
            $after = $node.value
            write-host "After: $after"
        }
    }
}