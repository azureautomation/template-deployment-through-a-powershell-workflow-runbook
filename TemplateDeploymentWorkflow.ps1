<#
.SYNOPSIS 

    This workflow runs an ARM template and parameter files that are stored online

.DESCRIPTION 

    This wrokflow requires a vlaue for the resource group towards which the deployment will run to. If your files are stored
    in a private blob container, make sure to append your SAS token.

.PARAMETER 

            DeploymentName - Name for the deployment.
            RGName - Name of the resource group for the deployment.
            TemplateURI - URL for the location of the ARM template. If needed, append the necessary SAS token.
            ParameterFileURI - URL for the location of the ARM template parameter file. If needed, append the necessary SAS token.

.Notes

    Author: Stewart Viera
    Last Update: 4/6/2017

#>

{
    Param
        (
            # Deployment Name
            [Parameter(Mandatory=$true)]
            [String]$DeploymentName,

            # Resource Group Name
            [Parameter(Mandatory=$true)]
            [String]$RGName,

            # Template URI
            [Parameter(Mandatory=$true)]
            [String]$TemplateURI,

            # Parameter File URI
            [Parameter(Mandatory=$true)]
            [String]$ParameterFileURI

        )
        
        $Conn = Get-AutomationConnection -Name AzureRunAsConnection 
        Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID `
        -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint
        
        New-AzureRmResourceGroupDeployment -Mode incremental -ResourceGroupName $RGName -Name $DeploymentName -TemplateUri $TemplateURI -TemplateParameterURI $ParameterFileURI -verbose
        
}