#src:  https://mcpmag.com/articles/2017/09/07/creating-a-balloon-tip-notification-using-powershell.aspx
function DisplayStartupMessage {
    param(
        $environmentName = "default",
        $title = "ENVEE"
    )    

    Add-Type -AssemblyName System.Windows.Forms;
    $global:balloon = New-Object System.Windows.Forms.NotifyIcon;
    $path = (Get-Process -id $pid).Path;
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) ;
    $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::None;
    $balloon.BalloonTipText = "Setting up environment: $($environmentName), please wait...";
    $balloon.BalloonTipTitle = $title; 
    $balloon.Visible = $true ;
    $balloon.ShowBalloonTip(20000);
}

function DisplayCompleteMessage {
    param(
        $environmentName = "default",
        $title = "ENVEE"
    )

    $global:balloon = New-Object System.Windows.Forms.NotifyIcon;
    $path = (Get-Process -id $pid).Path;
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path);
    $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::None;
    $balloon.BalloonTipText = "Environment '$($environmentName)' has been setup.";
    $balloon.BalloonTipTitle = $title;  
    $balloon.Visible = $true;
    $balloon.ShowBalloonTip(2000);
}
