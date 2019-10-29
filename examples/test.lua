-- Inputs
aws_id = nil
aws_secret = nil
s3_region = 'us-east-2' -- US East (Ohio)
s3_bucket = 'test-extensions'


-- functions

function table.val_to_str ( v )
  if  type( v ) == "string" then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return type( v ) == "table" and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if type( k ) == "string" and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

-- Tests

print("(os.print) Starting Tests at " .. os.date("%x"))

host_info = hunt.env.host_info()

hunt.print("(hunt.print) Starting tests" .. os.date("%x"))
hunt.log("OS (hunt.log): " .. host_info:os())
hunt.warn("Architecture (hunt.warn): " .. host_info:arch())
hunt.debug("Hostname (hunt.debug): " .. host_info:hostname())
hunt.verbose("Domain (hunt.verbose): " .. host_info:domain())
hunt.error("Error (hunt.error): Great Succcess!")

print("is_windows(): " .. tostring(hunt.env.is_windows()))
print("is_linux(): " .. tostring(hunt.env.is_linux()))
print("is_macos(): " .. tostring(hunt.env.is_macos()))
print("has_powershell(): " .. tostring(hunt.env.has_powershell()))
print("has_python(): " .. tostring(hunt.env.has_python()))
print("has_python2(): " .. tostring(hunt.env.has_python2()))
print("has_python3(): " .. tostring(hunt.env.has_python3()))

print("OS (hunt.env.os): " .. hunt.env.os())
print("API: " .. hunt.net.api())
print("APIv4: " .. table.tostring(hunt.net.api_ipv4()))
print("os.getenv() temp: " .. os.getenv("TEMP"))
print("os.getenv() name: " .. os.getenv("COMPUTERNAME"))

print("DNS lookup: " .. table.tostring(hunt.net.nslookup("www.google.com")))
print("Reverse Lookup: " .. table.tostring(hunt.net.nslookup("8.8.8.8")))


client = hunt.web.new("https://infocyte-support.s3.us-east-2.amazonaws.com/developer/infocytedevkit.exe")
client:disable_tls_verification()
client:download_file("C:/windows/temp/devkit2.exe")
-- data = client:download_data()

procs = hunt.process.list()
hunt.print("ProcessList: " .. table.tostring(procs))
for _, proc in pairs(procs) do
    hunt.print("Found pid " .. proc:pid() .. " @ " .. proc:path())
    hunt.print("- Owned by: " .. proc:owner())
    hunt.print("- Started by: " .. proc:ppid())
    hunt.print("- Command Line: " .. proc:cmd_line())
end

hunt.process.kill_process('C:\\windows\\system32\\calc.exe')

r = hunt.registry.list_keys('\\Registry\\User')
print("Registry: " .. table.tostring(t))

rule = [[
rule OffsetExample {
	strings:
		$mz = "MZ"

	condition:
		$mz at 0
}
]]

yara = hunt.yara.new()
yara:add_rule(rule)
path = [[C:\windows\system32\calc.exe]]
for _, signature in pairs(yara:scan(path)) do
    hunt.print("Found " .. signature .. " in file!")
end


print("SHA1 file: " .. hunt.sha1(path))
print("Sha1 data: " .. hunt.sha1_data(hunt.unbase64("dGVzdA==")))
print('unbase64 ("test"): ' .. hunt.bytes_to_string(hunt.unbase64("dGVzdA==")))


recovery = hunt.recovery.s3(aws_id, aws_secret, 'us-east-2', 'test-extensions')
recovery.upload_file('c:\\windows\\system32\\notepad.exe', 'evidence.bin')
recovery.upload_file('c:\\windows\\system32\\notepad.exe', 'recovery/evidence.bin')
