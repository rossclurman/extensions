--[[
    Infocyte Extension
    Name: Template
    Type: Action
    Description: Example script show format, style, and options for commiting
     an action against a host.
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
-- SECTION 3: Actions
----------------------------------------------------

if string.find(OS, "windows") then
  -- Insert your Windows Code
  os.execute('shutdown') --filler

elseif string.find(OS, "osx") then
    -- Insert your MacOS Code

elseif string.find(OS, "linux") or hunt.env.has_sh() then
    -- Insert your POSIX (linux) Code

end

----------------------------------------------------
-- SECTION 4: Results
----------------------------------------------------

hunt.log("Extension successfully executed on "..hostname)
