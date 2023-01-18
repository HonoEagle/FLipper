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


#For powershell
Write-Host "Network Adapter: $networkName"
Write-Host "IP Type: $ipType"
Write-Host "IP Address: $ipAddress"
Write-Host "Subnet Mask: $subnetMask"
Write-Host "Default Gateway: $defaultGateway"



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
$text | Out-File -FilePath "C:\info.txt" -Encoding UTF8

# Open the text file
Start-Process "notepad.exe" "C:\info.txt"
