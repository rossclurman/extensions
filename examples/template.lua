--[[
	Infocyte Extension
	Name: Template
	Type: Collection
	Description: Collects additional data
	Author: Infocyte
	Created: 20190919
	Updated: 20190919 (Gerritz)
]]--

----------------------------------------------------
-- SECTION 1: Variables & Functions
----------------------------------------------------
OS = hunt.env.os()


----------------------------------------------------
-- SECTION 2: Collection or Actions
----------------------------------------------------

if string.find(OS, "windows") then
  -- Insert your Windows Code

elseif string.find(OS, "osx") then
	-- Insert your MacOS Code

else
	-- Insert your POSIX (linux) Code

end

----------------------------------------------------
-- SECTION 3: Analysis
--    Host-side processing and analysis can be
--    written here.
----------------------------------------------------



----------------------------------------------------
-- SECTION 4: Output / Results
--    Set the threat status of the overall script.
--    Send any data in text using one or more
--    log statements.
----------------------------------------------------
hunt.log("Extension successfully executed on "..computername)
hunt.setthreatstatus("Good")
