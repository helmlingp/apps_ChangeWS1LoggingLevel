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
Get-ChildItem $path\$script:ConfigFile -Recurse | 
ForEach-Object {
    [xml]$xmlDoc = Get-Content $_.FullName
    $node = $xmldoc.configuration.loggingConfiguration
    # change attribute on selected node
    $node.value=$script:Level
    $xmldoc.Save($_.FullName)
}