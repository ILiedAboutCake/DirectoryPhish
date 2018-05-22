# USAGE: DirectoryPhish.ps1 -Group AD_Group_Name (Required), -ExcludeIfIn [optional] -Domain [optional]
# ExcludeIfIn is great to filter out users of a larger scope.
# Domain is great if you have multiple domains in your corporate forest
# https://github.com/ILiedAboutCake/DirectoryPhish

param(
    [parameter(Mandatory = $true)][string]$Group, 
    [string]$ExcludeIfIn, 
    [string]$Domain
)

Write-Host "Attempting to get all users in $Group and making $Group.csv in this working directory"

#handle groups to exclude, make sure they exist
if ($ExcludeIfIn)
{
    Try
    {
        $groupDN = (Get-ADGroup -Identity $ExcludeIfIn).DistinguishedName
        $AD = Get-ADGroupMember -Identity $Group -Recursive |
            Where-Object objectClass -eq "user" |
            Get-ADUser -Properties MemberOf | 
            Where-Object -FilterScript { $_.MemberOf -notcontains $groupDN}
    }
    Catch
    {
        Throw "Group named $ExcludeIfIn not found in AD. Check your group name if it exists."
    }
}
#check to make sure the group exists
Else
{
    Try
    {
        $AD = Get-ADGroupMember -Identity $Group -Recursive |
            Where-Object objectClass -eq "user"
    }
    Catch
    {
        Throw "$Group not found in AD. Check your spelling/case sensitivity"
    }
}

#get the data from the group we need out of AD, and output a CSV with proper GoPhish ready columns
$AD | 
    Get-ADUser -Properties EmailAddress,Title,GivenName,Surname | 
    select GivenName,Surname,EmailAddress,Title | 
    Where-Object {$_.EmailAddress -ne $null} | 
    Where-Object -Property EmailAddress -Like *$Domain* | #only return certain domain TLDs, $null does not change this
    Select-Object -Property @{
        Name = 'First Name'
        Expression = {$_.'GivenName'}
    }, @{
        Name = 'Last Name'
        Expression = {$_.'Surname'}
    }, @{
        Name = 'Email'
        Expression = {$_.'EmailAddress'}
    }, @{
        Name = 'Position'
        Expression = {$_.'Title'}
    } |
    Export-Csv $Group".csv" -NoTypeInformation
