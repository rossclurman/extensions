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

host_info = hunt.env.host_info()
os = host_info:os()
hunt.verbose("Starting Extention. Hostname: " .. host_info:hostname() .. ", Domain: " .. host_info:domain() .. ", OS: " .. host_info:os() .. ", Architecture: " .. host_info:arch())


if hunt.env.is_windows() and hunt.env.has_powershell() then
	-- Insert your Windows Code
    hunt.debug("Operating on Windows")

    -- Create powershell process and feed script/commands to its stdin
    local pipe = io.popen("powershell.exe -noexit -nologo -nop -command -", "w")
    pipe:write(psscript) -- load up powershell functions and vars
    pipe:write([[Get-ForensicMFT]])
    r = pipe:close()
    hunt.verbose("Powershell Returned: "..tostring(r))

end

----------------------------------------------------
-- SECTION 4: Results
--	Set threat status to aggregate and stack results in the Infocyte app:
--		Good, Low Risk, Unknown, Suspicious, or Bad
----------------------------------------------------

if result then
  hunt.suspicious()
else
  hunt.good()
end
