--[[
	Infocyte Extension
	Name: PowerForensics
	Type: Collection
	Description: Deploy PowerForensics and gathers forensic data
	Author: Infocyte
	Created: 9-19-2019
	Updated: 9-19-2019 (Gerritz)
]]--


----------------------------------------------------
-- SECTION 1: Variables
----------------------------------------------------
outpath = [[c:\windows\temp\ic]]

--OS = hunt.env.os() -- determine host OS
OS = "windows"
print("Starting Script")


----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------

psscript = [[
Install-Module -name PowerForensics
]]

function run_powershell(script)
  -- Create powershell process and feed script to its stdin
  local pipe = io.popen("powershell.exe -noexit -nologo -win 1 -nop -command -", "w")
  pipe:write(script)
  pipe:close()
end

function run_powershellencoded(base64_cmd)
  os.execute("powershell.exe -nologo -win 1 -nop -encoded "..base64_cmd)
end

----------------------------------------------------
-- SECTION 3: Collection / Inspection
----------------------------------------------------

if not string.find(OS, "windows") and hunt.env.has_powershell() then
  -- Insert your Windows Code
  print("Operating on Windows")

  -- Create powershell process and feed script/commands to its stdin
  local pipe = io.popen("powershell.exe -noexit -nologo -nop -command -", "w")
  pipe:write(psscript) -- load up powershell functions and vars
  pipe:write([[ Get-StringsMatch -Path C:\Users -Strings ]] .. make_psstringarray(strings))
  r = pipe:close()
  print("Powershell Returned: "..tostring(r))

end

----------------------------------------------------
-- SECTION 4: Results
--	Set threat status to aggregate and stack results in the Infocyte app:
--		Good, Low Risk, Unknown, Suspicious, or Bad
----------------------------------------------------

if result then
  threatstatus = "Suspicious"
else
  threatstatus = "Good"
end

-- Mandatory: set the returned threat status of the host
-- hunt.set_threatstatus(threatstatus)
