# *** Functions *********************************************************************************************

function Show-Menu {
    param (
        [string]$Title = 'Menu'
    )
    Clear-Host
    Write-Host "Boise Bee Cyberpatriot Windows script `n  MUST RUN SHELL AS ADMINISTRATOR! `n"
    Write-Host "=============== $Title ================`n"
    
    Write-Host "1: Get List of Local Users"
    Write-Host "2: Set Local User Passwords"
    Write-Host "3: Set Local Audit Policy"
    Write-Host "4: Get Running Services"
    Write-Host "Q: Press 'Q' to quit.`n"
    Write-Host "====================================="
}

function GetLocalUsers{
    Write-Host "`nHere is a list of local users on this system.  Compare these closely to the administrators and authorized users listed in the README. `n"
	(Get-LocalUser).Name | Where-Object {($_ -ne "Guest") -and ($_ -ne "Administrator") -and ($_ -ne "WDAGUtilityAccount") -and ($_ -ne "DefaultAccount")} | sort
    Write-Host `n
}

function SetPasswordPolicy{
    #TODO: figure out registry values to set
    Write-Host "Nothing here yet!"
}

function SetUserPasswords{
# Prereq: Create a file with the list of valid users (e.g. users.txt) DO NOT INCLUDE THE ADMIN ACCOUNT YOU ARE LOGGED INTO!
	$password = Read-Host -Prompt "Enter standard password: " -AsSecureString  
    # <type our standard password here>  it will show up as **********
    # Why not just hardcode it?  Not a good security practice to hardcode credentials in code. 

	$path = Read-Host -Prompt "Enter the path to users file created from the readme file (e.g. c:\temp\users.txt)"
    
    if (($path -ne "") -and (Test-Path -path $path)){
        foreach ($user in (Get-Content $path)) {get-Localuser $user | set-localuser -Password $password -PasswordNeverExpires:$false}
        Write-Host "User passwords set!"
    }
    else {
        Write-Host "Doh! That file path does not exist!"
    }     
}

function GetInstalledPrograms{
	#Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | sort | ft displayname
    Write-Host "Not quite ready yet! Sorry."
}

function SetSecPol{
    #TODO: figure out registry values to set
    Write-Host " :-( Nothing here yet!"
}

function SetAuditPol{
    #Write-Host "Nothing here yet!"
    auditpol /set /category:* /failure:enable /success:enable
    auditpol /set /subcategory:"Account Lockout" /success:enable /failure:enable   
    auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable

    Write-Host "Local audit policies set.`n"
}

function GetRunningServices{
    get-service | where {$_.status -eq "Running"} | sort Displayname | ft displayname, name, status
	# alternate option with path
	#Get-WmiObject win32_service | Select-Object Name, State, PathName | Where-Object {$_.State -like 'Running'}
}

# *** Main **************************************************************************************************

#https://adamtheautomator.com/powershell-menu/

Clear-Host

do
 {
    Show-Menu
    $selection = Read-Host "Please make a selection"
        switch ($selection)
        {
        '1' {GetLocalUsers} 
        #'2' {SetPasswordPolicy}
        '2' {SetUserPasswords}
        #'3' {GetInstalledPrograms}
        #'5' {SetSecPol}
        '3' {SetAuditPol}
        '4' {GetRunningServices}
        }
    pause
 }
 until ($selection -eq 'q')

Clear-Host 
Write-Host "You quit the script.  Manually check the settings to be sure it worked!  `n"
