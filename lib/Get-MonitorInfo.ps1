# src: https://social.technet.microsoft.com/Forums/windows/en-US/219cf510-2c8d-4311-ae15-c3c982dfc7a7/get-screen-resolution-of-all-monitors?forum=winserverpowershell 

#get a list of all monitors and info regarding resolution
function Get-MonitorInfo {
	Add-Type -AssemblyName System.Windows.Forms;
	$Monitors = [System.Windows.Forms.Screen]::AllScreens;

	return $Monitors;
	
}

