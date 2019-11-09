####################################################
#╔═╗╔╗╔╦  ╦┬┬─┐┌─┐┌┐┌┌┬┐╔═╗┌┐┌┌┬┐  ┌─┐╔═╗┌┬┐┬ ┬┌─┐ #
#║╣ ║║║╚╗╔╝│├┬┘│ │││││││║╣ │││ │   └─┐║╣  │ │ │├─┘ #
#╚═╝╝╚╝ ╚╝ ┴┴└─└─┘┘└┘┴ ┴╚═╝┘└┘ ┴   └─┘╚═╝ ┴ └─┘┴   #
####################################################                                                 
# ENVEE v0.1                                       #
# author: Ryan Radford (werkn.github.io)           #
####################################################                                                 
param(
    $environmentToStart
)    
                                                 

# import scripts
. $PSScriptRoot/lib/Set-Window.ps1
. $PSScriptRoot/lib/Notifications.ps1
. $PSScriptRoot/lib/Get-MonitorInfo.ps1

#setup our config file path
$CONFIG_FILE_PATH = "$PSScriptRoot\config.json";
$MONITORS = Get-MonitorInfo;

#load json 
$configFile = Get-Content -Raw -Path $CONFIG_FILE_PATH | ConvertFrom-Json;

$environments = $configFile.environments;

#iterate over each environment
foreach ($currentEnv in $environments) {
    
    if ($currentEnv.name.Equals($environmentToStart)) {
        Write-Host "Starting environment $($environmentToStart)...";
        DisplayStartupMessage -environmentName $environmentToStart -title "ENVEE"

        #iterate over each collection of desktops for environment
        foreach ($desktops in $currentEnv.environment) {

            #iterate over desktop and apps for said desktop
            foreach ($desktop in $desktops.PsObject.Properties) {

                foreach ($app in $desktop.Value.PsObject.Properties) {
                
                    #capture app properties
                    foreach ($appProperty in $app.Value.PsObject.Properties) {
                    
                        $appName = $appProperty.Value.path;
                        $processName = $appProperty.Value.processName;                       
                        $appStartupDelay = $appProperty.Value.startupDelay;
                        $monitorIndex = $appProperty.Value.monitor;
                        $x = $appProperty.Value.topLeft.x;
                        $y = $appProperty.Value.topLeft.y;
                        $width = $appProperty.Value.size.width;
                        $height = $appProperty.Value.size.height;
                        
                        $mon = $MONITORS[$monitorIndex];
						
                        #if were using percent calculate position
                        if ($appProperty.Value.size.mode -eq "percent") {
                            $width = $width * $mon.Bounds.Width;
                            $height = $height * $mon.Bounds.Height;
                        }
						
                        if ($appProperty.Value.topLeft.mode -eq "percent") {  
                            $x = ($x * $mon.Bounds.Width) + $mon.Bounds.X;
                            $y = ($y * $mon.Bounds.Height) + $mon.Bounds.Y;
                        }

                        #check our app/process we want to move and resize is running
                        #note: `-ErrorAction Stop` forces a terminating error that we can
                        #catch, otherwise catch block is skipped
                        $processListForAppName = Get-Process -Name $processName -ErrorAction SilentlyContinue;   

                        if ([string]::IsNullOrEmpty($processListForAppName)) {

                            #process is not running
                            write-warning "No process found for name: $($appName), attempting to start new instance...";
							

                            if (-NOT ([string]::IsNullOrEmpty($appProperty.Value.args))) {
                                $appArgs = "";
                                #build argument list
                                foreach ($appArg in $appProperty.Value.args) {
                                    $appArgs = "$appArgs $appArg";
                                }

                                #check if app exists, attempt to start it and wait for it to become ready
                                write-host "trying... 'start-process $appName $appArgs";
                                start-process $appName $appArgs;

                            }
                            else {
                                
                                start-process $appName;
                            }

                            #not sure if injecting artificial delay is necessary, this might need to be tweaked
                            #or we should identify some method, flag, api callback to verify if an application is
                            #launched and visible... for now we set delay on a per app basis in config.json
                            start-sleep $appStartupDelay; 

                        }

                        #some apps have multiple instances/processes (like chrome)
                        #grab the process.MainWindowHandle that is not zero
                        #currently this is an easy way to identify the active window (one being displayed
                        #that is not a thread or child process)
                        foreach ($windowHandle in (Get-Process -Name $processName).MainWindowHandle) {
                        
                            if ([int]$windowHandle -gt 0) {
                                write-information "Resizing and moving window for $($appName)"
                                Set-Window -ProcessName $processName -ProcessHandle $windowHandle -X $x -Y $y -width $width -height $height -Passthru;
                            }
                        }

                        #check if window is to be maximized
                        if (-NOT ([string]::IsNullOrEmpty($appProperty.Value.maximized))) {
                            $maximizedArgument = $appProperty.Value.maximized;

                            #check if maximized is set to true
                            if ($maximizedArgument -eq $true) {
                                .\virtual-desktop-keys.exe "--sendup";
                                start-sleep 2;
                            }

                        }

                        #check for window snapping
                        if (-NOT ([string]::IsNullOrEmpty($appProperty.Value.snap))) {
                            $snapArgument = $appProperty.Value.snap;
                            start-process $PSScriptRoot\virtual-desktop-keys.exe $snapArgument;

                            start-sleep 3;
                        }
                    }

                }

                #switch to next virtual desktop
                write-host "Switching to next virtual desktop";
                start-process $PSScriptRoot\virtual-desktop-keys.exe --right;

                start-sleep 2;

            }

            #play exclamation sound when complete
            [System.Media.SystemSounds]::Exclamation.Play();
            DisplayCompleteMessage -environmentName $environmentToStart -title "ENVEE";
        }

    }
}
