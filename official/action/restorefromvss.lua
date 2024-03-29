--[[
    Infocyte Extension
    Name: Restore from Volume Shadow Copy
    Type: Action
    Description: Restores a volume, folder, or file from Volume Shadow Copy (VSS) on Windows hosts to recover from certain ransomware attacks.
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
$vssvolume = (Get-WmiObject Win32_ShadowCopy | Sort-Object InstallDate -Descending)[0].DeviceObject + "\"
cmd /c mklink /d C:\vssbackup "$vssvolume"
]==]


----------------------------------------------------
-- SECTION 3: Actions
----------------------------------------------------

if string.find(OS, "windows") and hunt.env.has_powershell() then
  -- Insert your Windows Code

  -- Create powershell process and feed script/commands to its stdin
  local pipe = io.popen("powershell.exe -noexit -nologo -nop -command -", "w")
  pipe:write(psscript) -- load up powershell functions and vars
  r = pipe:close()
  print("Powershell Returned: "..tostring(r))
  hunt.log(output) -- send to Infocyte
end


----------------------------------------------------
-- SECTION 4: Output
----------------------------------------------------

hunt.log([[ Volume Shadow Copy has been mounted to C:\vssbackup\ ]])
