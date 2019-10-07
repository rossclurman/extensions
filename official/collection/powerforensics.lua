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

local function run_powershell(script)
  -- Create powershell process and feed script to its stdin
  local pipe = io.popen("powershell.exe -noexit -nologo -win 1 -nop -command -", "w")
  pipe:write(script)
  pipe:close()
end

local function run_powershellencoded(base64_cmd)
  os.execute("powershell.exe -nologo -win 1 -nop -encoded "..base64_cmd)
end

-- Base64 Function
local bs = { [0] =
   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
   'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
   'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
   'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/',
}
local function base64(s)
   local byte, rep = string.byte, string.rep
   local pad = 2 - ((#s-1) % 3)
   s = (s..rep('\0', pad)):gsub("...", function(cs)
      local a, b, c = byte(cs, 1, 3)
      return bs[a>>2] .. bs[(a&3)<<4|b>>4] .. bs[(b&15)<<2|c>>6] .. bs[c&63]
   end)
   return s:sub(1, #s-pad) .. rep('=', pad)
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
--    Threat status is a set of static results used to aggregate and stack results:
--    Good, Low Risk, Unknown, Suspicious, or Bad
--		Include any host-side processing and analysis necessary to report the appropriate status.
--
--    In addition, one or more log statements can be used to send data in text format.
----------------------------------------------------

if result then
  threatstatus = "Suspicious"
else
  threatstatus = "Good"
end

-- Mandatory: set the returned threat status of the host
-- hunt.set_threatstatus(threatstatus)
