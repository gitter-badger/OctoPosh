﻿<#
.Synopsis
   Gets Octopus Projects Variable sets
.DESCRIPTION
   Gets Octopus Projects Variable sets
.EXAMPLE
   Get-OctopusProjectVariable

   This command gets the variable sets of all the projects
.EXAMPLE
   Get-OctopusProjectVariable -name MyProject

   This command gets the Variable Set of the Project named "MyProject"
.EXAMPLE
   Get-OctopusProjectVariable -name MyApp*

   This command gets the Variable Sets of all the projects whose name start with the string MyApp
.EXAMPLE
   Get-OctopusProject -name MyProject | Get-OctopusProjectVariable

   This command gets the Variable Set of the Project named "MyProject"
.EXAMPLE
   $ProjectGroup = Get-OctopusProjectGroup -name "MyImportantProjects"

   $ProjectGroup | Get-OctopusProject | Get-OctopusProjectVariable

   This command gets the Variable Sets of all the projects inside of a Project Group named "MyImportantProjects"
.LINK
   Github project: https://github.com/Dalmirog/Octoposh
#>
function Get-OctopusProjectVariable
{
    [CmdletBinding()]    
    Param
    (
        #Project name
        [Parameter(ValueFromPipelineByPropertyName = $true,Position=0)]
        [string[]]$Projectname
    )

    Begin
    {
        $c = New-OctopusConnection
        $list = @()        
    }
    Process
    {
        #Getting Projects        
        If(!([string]::IsNullOrEmpty($Projectname))){
            
            $Projects = $c.repository.Projects.FindMany({param($Proj) if (($Proj.name -in $Projectname) -or ($Proj.name -like $Projectname)) {$true}})
        }

        else{
        
            $Projects = $c.repository.projects.FindAll()
        }        

        #Getting info by project
        foreach ($p in $Projects){

            $vars = @()

            $projVar = $C.repository.VariableSets.Get($p.links.variables)

            foreach ($var in $projVar.variables){
                
                $obj = [PSCustomObject]@{
                    Name = $var.name
                    Value = $var.value
                    Scope = $var.scope
                    IsSensitive = $var.IsSensitive
                    IsEditable = $var.IsEditable
                    Prompt = $var.Prompt                    
                }

                $vars += $obj
            }
            
            $obj = [PSCustomObject]@{
                ProjectName = $p.name
                Variables = $vars
                LastModifiedOn = $projVar.LastModifiedOn
                LastModifiedBy = $projVar.LastModifiedBy
                Resource = $projVar
                    
                } 
            
            $list += $obj
        }

    }
    End
    {
        return $list
    }
}