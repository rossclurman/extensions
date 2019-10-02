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
-- SECTION 1: Variables & Functions
----------------------------------------------------
infocyteips = get_infocyteips() -- "3.209.70.118"
workingfolder = os.getenv("TEMP")
computername = os.getenv("COMPUTERNAME")
OS = hunt.env.os() -- determine host OS
myinstance = get_hunt_api() -- "alpo1.infocyte.com"

local function run_powershell(script)
  -- Create powershell process and feed script to its stdin
  local pipe = io.popen("powershell.exe -nologo -win 1 -nop -command -", "w")
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
-- SECTION 2: Actions / Collection
----------------------------------------------------

if not string.find(OS, "windows") then
  -- Put your powershell script in here:
  local script = [[
  Install-Module -name PowerForensics
  ]]
  run_powershell(script)
end
----------------------------------------------------
-- SECTION 3: Output / Results
----------------------------------------------------
log("Extension successfully executed on "..computername)
setthreatstatus("Unknown")
