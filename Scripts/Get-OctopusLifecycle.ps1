﻿<#
.Synopsis
   Gets information about Octopus Lifecycles
.DESCRIPTION
   Gets information about Octopus Lifecycles
.EXAMPLE
   Get-OctopusLifecycle

   This command gets all the Lifecycles of the current Instance
.EXAMPLE
   Get-OctopusLifecycle -name MyLifecycle

   This command gets the Lifecycle named "MyLifecycle"
.EXAMPLE
   Get-OctopusProject -name MyProject | Get-OctopusLifecycle

   This command gets the Lifecycle of the project called "MyProject"
.EXAMPLE
   Get-OctopusProjectGroup -name "MyProjectGroup" | Get-OctopusProject | Get-OctopusLifecycle

   This command gets the Lifecycles of all the projects inside the project group called "MyProjectGroup"
.LINK
   Github project: https://github.com/Dalmirog/Octoposh
#>
function Get-OctopusLifeCycle
{
    [CmdletBinding()]    
    Param
    (
        #Lifecycle Name
        [alias("LifecycleName")]
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name
    )

    Begin
    {
        $c = New-OctopusConnection
        $list = @()
    }
    Process
    {

        #Getting Lifecycles        
        If(!([string]::IsNullOrEmpty($Name))){
            
            $Lifecycles = $c.repository.Lifecycles.FindMany({param($lc) if (($lc.name -in $name)) {$true}})
        }

        else{
        
            $Lifecycles = $c.repository.Lifecycles.FindAll()
        }        

        #Getting info by Lifecycle
        foreach ($Lifecycle in $Lifecycles){            
            
            $obj = [PSCustomObject]@{
                LifecycleName = $Lifecycle.name
                Id = $Lifecycle.Id                
                Resource = $Lifecycle           
            }
            
            $list += $obj

        }       


    }
    End
    {
        $list
    }
}