--[[
	Infocyte Extension
	Name: Template
	Type: Collection
	Description: Example script show format, style, and options for gathering additional data from a host.
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

----------------------------------------------------
-- SECTION 3: Collection / Inspection
----------------------------------------------------

if string.find(OS, "windows") then
  -- Insert your Windows Code
  result = "Test data" -- filler

elseif string.find(OS, "osx") then
	-- Insert your MacOS Code

elseif string.find(OS, "linux") or hunt.env.has_sh() then
	-- Insert your POSIX (linux) Code

end

----------------------------------------------------
-- SECTION 4: Analysis
--    Optional host-side processing and analysis.
----------------------------------------------------

if string.find(result, "test") then
  threatstatus = "Good"
elseif string.find(result, "bad") then
  threatstatus = "Bad"
else
  threatstatus = "Unknown"
end

----------------------------------------------------
-- SECTION 5: Results
--    Threat status is a set of static results used to aggregate and stack results:
--    Good, Low Risk, Unknown, Suspicious, or Bad
--
--    One or more log statements can be used to send data in text format.
----------------------------------------------------

hunt.log("Extension successfully executed on "..hostname)
hunt.log(result)

-- Mandatory: set the returned threat status of the host
hunt.setthreatstatus(threatstatus)
