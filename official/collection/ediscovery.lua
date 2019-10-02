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
strings = {'TestString', 'TestString'}

OS = hunt.env.os() -- determine host OS


----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------

local initscript = [[
$output   = "c:\temp\edisco.csv"

Function Get-StringMatch ($path, $String, $charactersAround = 30){
    $results = @()
    $application = New-Object -comobject word.application
    $application.visible = $False
    $files = Get-Childitem $path -Include *.docx,*.doc -Recurse | Where-Object { !($_.psiscontainer) }
    # Loop through all *.doc files in the $path directory
    Foreach ($file In $files)
    {
        $document = $application.documents.open($file.FullName,$false,$true)
        $range = $document.content

        If($range.Text -match ".{$($charactersAround)}$($String).{$($charactersAround)}"){
             $properties = @{
                File = $file.FullName
                Match = $String
                TextAround = $Matches[0]
             }
             $results += New-Object -TypeName PsCustomObject -Property $properties
        }
        $document.close()
    }

    $application.quit()
    If($results){
        $results | Export-Csv $output -NoTypeInformation -Append
        return $results
    }
}
]]


----------------------------------------------------
-- SECTION 3: Collection / Inspection
----------------------------------------------------

if string.find(OS, "windows") then
  -- Insert your Windows Code
  -- Create powershell process and feed script/commands to its stdin
  local pipe = io.popen("powershell.exe -nologo -win 1 -nop -command -", "w")
  pipe:write(initscript)
  for i = 1, #v do  -- #v is the size of v for lists.
  pipe:write([[Get-StringMatch -Path C:\ ]]..string)

    print(v[i])  -- Indices start at 1 !! SO CRAZY!
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
