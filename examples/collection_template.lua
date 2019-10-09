--[[
    Infocyte Extension
    Name: Template
    Type: Collection
    Description: Example script show format, style, and options for gathering
     additional data from a host.
    Author: Infocyte
    Created: 20190919
    Updated: 20190919 (Gerritz)
]]--

----------------------------------------------------
-- SECTION 1: Variables
----------------------------------------------------
OS = hunt.env.os() -- determine host OS


----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------

-- Paste shell scripts here if using.
script = [==[

]==]

----------------------------------------------------
-- SECTION 3: Collection / Inspection
----------------------------------------------------

if string.find(OS, "windows") then
  -- Insert your Windows code
  --[[
  local pipe = io.popen("powershell.exe -noexit -nologo -nop -command -", "w")
  pipe:write(script) -- load up powershell functions and vars
  r = pipe:close()
  ]]--

  result = "Test" -- filler


elseif string.find(OS, "osx") then
    -- Insert your MacOS Code


elseif string.find(OS, "linux") or hunt.env.has_sh() then
    -- Insert your POSIX (linux) Code


end

----------------------------------------------------
-- SECTION 4: Results
--  Threat status is a set of static results used to aggregate and stack
--  results:
--      Good, Low Risk, Unknown, Suspicious, or Bad
--    Include any host-side processing and analysis necessary to report the
--   appropriate status.
--
--  In addition, one or more log statements can be used to send data in text
--   format.
----------------------------------------------------

if string.find(result, "test") then
  threatstatus = "Good"
elseif string.find(result, "bad") then
  threatstatus = "Bad"
else
  threatstatus = "Unknown"
end

-- Mandatory: set the returned threat status of the host
hunt.set_threatstatus(threatstatus)

-- one or more log statements can be used to send resulting data or messages in
-- text format to your Infocyte instance
hunt.log("Extension successfully executed on "..hostname)
hunt.log(result)
