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
strings = {'Gerritz', 'test'}
outpath = [[c:\windows\temp\edisco.csv]]

--OS = hunt.env.os() -- determine host OS
OS = "windows"
print("Starting Script")



----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------

psscript = "$output = \"" .. outpath .. "\"\n"
psscript = psscript .. [==[
Function Get-StringsMatch {
	param (
		[string]$path = $env:systemroot,
		[string[]]$Strings,
		[int]$charactersAround = 30
	)
    $results = @()
	try {
		$application = New-Object -comobject word.application
	} catch {
		throw "Error opening com object"
	}
    $application.visible = $False
    $files = Get-Childitem $path -Include *.docx,*.doc -Recurse | Where-Object { !($_.psiscontainer) }
    # Loop through all *.doc files in the $path directory
    Foreach ($file In $files) {
		try {
			$document = $application.documents.open($file.FullName,$false,$true)
		} catch {
			Write-Error "Could not open $($file.FullName)"
			continue
		}
        $range = $document.content
		$filesize = [math]::Round((Get-Item $file.FullName).length/1kb)

		foreach ($String in $Strings) {
			If($range.Text -match ".{0,$($charactersAround)}$($String).{0,$($charactersAround)}"){
				 $properties = @{
					File = $file.FullName
					Filesize = $filesize
					Match = $String
					TextAround = $Matches[0]
				 }
				 $results += New-Object -TypeName PsCustomObject -Property $properties
			}
		}
        $document.close()
    }

    $application.quit()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($application)
    If($results){
        $results | Export-Csv $output -NoTypeInformation
        return $results
    }
}

]==]

function file_check(file_name)
  local file_found=io.open(file_name, "r")

  if file_found==nil then
    file_found=file_name .. " ... Error - File Not Found"
  else
    file_found=file_name .. " ... File Found"
  end
  return file_found
end

function make_psstringarray(list)
  -- Converts a lua list (table) into a string powershell list
  psarray = "@("
  for _,value in ipairs(list)
  do
	print("Adding search param: " .. tostring(value))
	psarray = psarray .. "\"".. tostring(value) .. "\"" .. ","
  end
  psarray = psarray:sub(1, -2) .. ")"
  return psarray
end

----------------------------------------------------
-- SECTION 3: Collection / Inspection
----------------------------------------------------

if string.find(OS, "windows") and hunt.env.has_powershell() then
  -- Insert your Windows Code
  print("Operating on Windows")

  -- Create powershell process and feed script/commands to its stdin
  local pipe = io.popen("powershell.exe -noexit -nologo -nop -command -", "w")
  pipe:write(psscript) -- load up powershell functions and vars
  pipe:write([[ Get-StringsMatch -Path C:\Users -Strings ]] .. make_psstringarray(strings))
  r = pipe:close()
  print("Powershell Returned: "..tostring(r))

  result = file_check(outpath)
  if result then
	local file = io.open(outpath, "r") -- r read mode
    local output = file:read("*all") -- *a or *all reads the whole file
    file:close()
	os.remove(outpath)
	hunt.log(output) -- send to Infocyte
  end

elseif string.find(OS, "osx") then
	-- Insert your MacOS Code

elseif string.find(OS, "linux") or hunt.env.has_sh() then
	-- Insert your POSIX (linux) Code

end

----------------------------------------------------
-- SECTION 4: Analysis
--    Optional host-side processing and analysis.
----------------------------------------------------

if result then
  threatstatus = "Suspicious"
else
  threatstatus = "Good"
end

----------------------------------------------------
-- SECTION 5: Results
--    Threat status is a set of static results used to aggregate and stack results:
--    Good, Low Risk, Unknown, Suspicious, or Bad
--
--    One or more log statements can be used to send data in text format.
----------------------------------------------------


-- Mandatory: set the returned threat status of the host
-- hunt.set_threatstatus(threatstatus)
