<#
.Synopsis
    Used as When to Call Install Complete custom script for ChangeWS1LoggingLevel.ps1
 .NOTES
    Created:   	    February, 2021
    Created by:	    Phil Helmling, @philhelmling
    Organization:   VMware, Inc.
    Filename:       TestChangeWS1LoggingLevel.ps1
    GitHub:         https://github.com/helmlingp/apps_ChangeWS1LoggingLevel
.DESCRIPTION
    Used to test the logging level of the Workspace ONE UEM Agent logs by reading the WS1 Agent config file(s)
    in C:\ProgramFiles(x86)\Airwatch\AgentUI and return exitcode 0 if same as level specified or exitcode 1 if not.
    Add as custom script under Deployment Options > When to Call Install Complete.
    
    **** IMPORTANT ****
    -ConfigFile and -Level parameters should match the Install Command -ConfigFile and -Level parameters

.EXAMPLE
    powershell.exe -ep bypass -file .\TestChangeWS1LoggingLevel.ps1 -ConfigFile TaskScheduler.exe.config -Level Debug
.EXAMPLE
    powershell.exe -ep bypass -file .\TestChangeWS1LoggingLevel.ps1 -ConfigFile TaskScheduler.exe.config -Level Information
.EXAMPLE
    powershell.exe -ep bypass -file .\TestChangeWS1LoggingLevel.ps1 -ConfigFile All -Level Debug
#>
param (
    [Parameter(Mandatory=$true)]
    [string]$ConfigFile=$script:ConfigFile,
    [Parameter(Mandatory=$true)]
    [string]$Level=$script:Level
)

$ec = 1

if($script:ConfigFile -eq 'All'){$script:ConfigFile='*.config'}
$path = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath "Airwatch\AgentUI"
Get-ChildItem $path\$script:ConfigFile -Recurse | 
ForEach-Object {
    [xml]$xmlDoc = Get-Content $_.FullName
    $node = $xmldoc.configuration.loggingConfiguration
    # change attribute on selected node
    if($node){
        
        $nodelevel = $node.level
        
        if($nodelevel -eq $script:Level){
            $ec = 0
        }
    }
}

exit $ec