--[[
    Infocyte Extension
    Name: Enable Volume Shadow Copy
    Type: Action
    Description: Enables Volume Shadow Copy (VSS) on Windows hosts to harden against certain ransomware attacks.
    Author: Infocyte
    Created: 20191008
    Updated: 20191008 (Gerritz)
]]--

----------------------------------------------------
-- SECTION 1: Inputs (Variables)
----------------------------------------------------
OS = hunt.env.os() -- determine host OS


----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------

psscript = [==[
# https://serverfault.com/questions/259381/how-to-enable-volume-shadow-copy-using-powershell
# https://social.technet.microsoft.com/forums/windowsserver/en-US/fb69840d-5f52-4711-8168-2faa23088233/shadow-copy-schedule-per-script
# https://docs.microsoft.com/en-us/previous-versions/windows/desktop/vsswmi/create-method-in-class-win32-shadowcopy
function Enable-ShadowCopies {
param(
    [Parameter(Mandatory=$true)]
    [String]$Drive
)
$volumeWMI = Get-WmiObject -Class Win32_Volume -Filter "DriveLetter = '$Drive'";
$volumeID = ($volumeWMI.DeviceID.SubString(10)).SubString(0,($volumeWMI.DeviceID.SubString(10)).Length-1);

$scheduler = New-Object -ComObject Schedule.Service
$scheduler.Connect("localhost")
$tskDef = $scheduler.NewTask(0);
$tskRegInfo = $tskDef.RegistrationInfo;
$tskSettings = $tskDef.Settings;
$tskTriggers = $tskDef.Triggers;
$tskActions = $tskDef.Actions;
$tskPrincipals = $tskDef.Principal;

# Registration Info
$tskRegInfo.Author = "Infocyte";

# Settings
$tskSettings.DisallowStartIfOnBatteries = $false;
$tskSettings.StopIfGoingOnBatteries = $false
$tskSettings.AllowHardTerminate = $false;
$tskSettings.IdleSettings.IdleDuration = "PT600S";
$tskSettings.IdleSettings.WaitTimeout = "PT3600S";
$tskSettings.IdleSettings.StopOnIdleEnd = $false;
$tskSettings.IdleSettings.RestartOnIdle = $false;
$tskSettings.Enabled = $true;
$tskSettings.Hidden = $false;
$tskSettings.RunOnlyIfIdle = $false;
$tskSettings.WakeToRun = $false;
$tskSettings.ExecutionTimeLimit = "PT259200S";
$tskSettings.Priority = "5";
$tskSettings.StartWhenAvailable = $false;
$tskSettings.RunOnlyIfNetworkAvailable = $false;

# Triggers
$tskTrigger1 = $tskTriggers.Create(3);
$tskTrigger2 = $tskTriggers.Create(3);

## Trigger 1
$tskTrigger1.Id = "Trigger1"
$tskTrigger1.StartBoundary = (Get-Date -format "yyyy-MM-dd")+"T07:00:00";
$tskTrigger1.DaysOfWeek = 0x3E; # Monday - Friday - http://msdn.microsoft.com/en-us/library/windows/desktop/aa384024(v=vs.85).aspx
$tskTrigger1.Enabled = $true;

## Trigger 2
$tskTrigger2.Id = "Trigger2";
$tskTrigger2.StartBoundary = (Get-Date -format "yyyy-MM-dd")+"T12:00:00";
$tskTrigger2.DaysOfWeek = 0x3E; # Monday - Friday - http://msdn.microsoft.com/en-us/library/windows/desktop/aa384024(v=vs.85).aspx
$tskTrigger2.Enabled = $true;

# Principals (RunAs User)
$tskPrincipals.Id = "Author";
$tskPrincipals.UserID = "SYSTEM";
$tskPrincipals.RunLevel = 1;

# Actions
$tskActions.Context = "Author"
$tskAction1 = $tskActions.Create(0);

# Action 1
$tskAction1.Path = "C:\Windows\system32\vssadmin.exe";
$tskAction1.Arguments = "Create Shadow /AutoRetry=15 /For="+$volumeWMI.DeviceID;
$tskAction1.WorkingDirectory = "%systemroot%\system32";

# Configure VSS, Add scheduled task
vssadmin Add ShadowStorage /For=$Drive /On=$Drive /MaxSize=10%;
$tskFolder = $scheduler.GetFolder("\")
$tskFolder.RegisterTaskDefinition("ShadowCopyVolume$volumeID", $tskDef, 6, "SYSTEM", $null,5);
}
]==]


----------------------------------------------------
-- SECTION 3: Actions
----------------------------------------------------

if string.find(OS, "windows") and hunt.env.has_powershell() then
  -- Insert your Windows Code

  -- Create powershell process and feed script/commands to its stdin
  local pipe = io.popen("powershell.exe -noexit -nologo -nop -command -", "w")
  pipe:write(psscript) -- load up powershell functions and vars
  pipe:write("Enable-ShadowCopies -Drive C")
  r = pipe:close()
  print("Powershell Returned: "..tostring(r))
  hunt.log(output) -- send to Infocyte

end


----------------------------------------------------
-- SECTION 4: Output
----------------------------------------------------
