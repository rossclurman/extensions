--[[
    Infocyte Extension
    Name: Keyboard Layout
    Type: Collection
    Description: Discovers if a second keyboard layout has been added. Flags if
        keyboard layout is Russian or Chinese.
    Author: Stephen Ramage (PwC UK)
    Created: 20191028
    Updated: 20191028
]]--

----------------------------------------------------
-- SECTION 1: Inputs (Variables)
----------------------------------------------------


----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------

function print_table (tbl, indent)
    if not indent then indent = 0 end
    local toprint = ""
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        toprint = toprint .. tostring(k) .. ": "
        if (type(v) == "table") then
            toprint = toprint .. tprint(v, indent + 2) .. "\r\n"
        else
            toprint = toprint .. tostring(v) .. "\r\n"
        end
    end
    print(toprint)
end


-- You can define shell scripts here if using any.
initscript = [==[

]==]

----------------------------------------------------
-- SECTION 3: Collection / Inspection
----------------------------------------------------

-- All Lua and hunt.* functions are cross-platform.
host_info = hunt.env.host_info()
os = host_info:os()
hunt.verbose("Starting Extention. Hostname: " .. host_info:hostname() .. ", Domain: " .. host_info:domain() .. ", OS: " .. host_info:os() .. ", Architecture: " .. host_info:arch())



-- All OS-specific instructions should be behind an 'if' statement
if hunt.env.is_windows() then
    -- Insert your Windows code
    t = hunt.registry.list_keys('\\Registry\\User')
    for k, key in pairs(t) do
        query = '\\Registry\\User\\' .. key .. '\\Keyboard Layout\\Preload'
        print('Querying Key: ' .. query)
        results = hunt.registry.list_keys(query)
        print_table(results)
        results = hunt.registry.list_values(query)
        print_table(results)
    end

    query = '\\Registry\\Machine\\Keyboard Layout\\Preload'
    print('Querying Key: ' .. query)
    results = hunt.registry.list_keys(query)
    print_table(results)
    results = hunt.registry.list_values(query)
    print_table(results)

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
