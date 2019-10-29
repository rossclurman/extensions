--[[
    Infocyte Extension
    Name: Yara Scanner
    Type: Collection
    Description: Example script showing how to use YARA
    Author: Infocyte
    Created: 20191018
    Updated: 20191018 (Gerritz)
]]--

----------------------------------------------------
-- SECTION 1: Inputs (Variables)
----------------------------------------------------

rule = [==[
rule is_malware {
  strings:
    $flag = "IAmMalware"
  condition:
    $flag
}
]==]


----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------


----------------------------------------------------
-- SECTION 3: Collection / Inspection
----------------------------------------------------

-- All Lua and hunt.* functions are cross-platform.
host_info = hunt.env.host_info()
os = host_info:os()
hunt.verbose("Starting Extention. Hostname: " .. host_info:hostname() .. ", Domain: " .. host_info:domain() .. ", OS: " .. host_info:os() .. ", Architecture: " .. host_info:arch())

-- Load Yara rules
result = false
yara = hunt.yara.new()
yara:add_rule(rule)

-- All OS-specific instructions should be behind an 'if' statement
if hunt.env.is_windows() then
  -- Insert your Windows code
    file = "c:\\malware\\lives\\here\\bad.exe"

    for _, signature in pairs(yara:scan(file)) do
        hunt.log("Found " .. signature .. " in file!")
        result = true
    end

elseif hunt.env.is_macos() then
    -- Insert your MacOS Code

elseif hunt.env.is_linux() or hunt.env.has_sh() then
    -- Insert your POSIX (linux) Code

else
    hunt.warn("WARNING: Not a compatible operating system for this extension [" .. host_info:os() .. "]")
end

----------------------------------------------------
-- SECTION 4: Results
----------------------------------------------------

if result == true then
    hunt.bad()
else
    hunt.good()
end
hunt.log("Result: Extension successfully executed on " .. hostname)
