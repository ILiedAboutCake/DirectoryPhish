# DirectoryPhish

Easily add targets into GoPhish for internal simulated threat training, based on pre existing groups in your Active Directory environment.


## Install

1. Download DirectoryPhish.ps1 or clone this repo.
2. Make sure you have the [AD-DS PowerShell cmdlets](https://docs.microsoft.com/en-us/powershell/module/addsadministration/) installed. 
3. Set your execution policy appropriately.

## Usage

1. Select your target group and run the script (see Examples below).
2. Take the output CSV and login to your GoPhish management panel `https://10.0.0.2:3333/` and select `Users & Groups`.
3. Select `New Group` and give it a name.
4. Click `+ Bulk Import Users` select your CSV and wait for the table to populate. `Save changes`.
5. Catch some phish :)

![](https://i.imgur.com/cRWli69.png)


## Switches

```
--Group (required)
--ExcludeIfIn (optional)
--Domain (optional)
```

## Examples

Get your Domain Users:
```Powershell
.\DirectoryPhish.ps1 --Group "Domain Users"
```

Get your Domain Users that are not in ManagementGroup:
```Powershell
.\DirectoryPhish.ps1 --Group "Domain Users" --ExcludeIfIn "ManagementGroup"
```

Get your Domain Users that only have *@contoso.com email addresses:
```Powershell
.\DirectoryPhish.ps1 --Group "Domain Users" --Domain contoso.com"
```

## Notes/Limits

This script will only return results if the user has an email address in AD under the `EmailAddress` property and will only return this email address.
