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
-- SECTION 1: Inputs (Variables)
----------------------------------------------------
aws_key_id = ''
s3_secret = ''
s3_region = 'us-east-2' -- US East (Ohio)
s3_bucket = 'test-extensions'

----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------

initscript = [==[
$n = Get-PackageProvider -name NuGet
if ($n.version.major -ne 2) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Scope CurrentUser -Force
}
if (-NOT (Get-Module PowerForensics)) {
    Write-Host "Installing PowerForensics"
    Install-Module -name PowerForensics -Force -Scope CurrentUser
}
if (-NOT (Get-Module 7Zip4Powershell)) {
    Write-Host "Installing 7Zip"
    Install-Module -name 7Zip4Powershell -Force -Scope CurrentUser
}

function Get-ICMFT ([String]$outpath = 'C:\windows\temp\mft.7z') {
    Write-Host "Getting MFT and exporting to $outpath"
    $temppath = "$env:temp\$([guid]::NewGuid()).csv"
    Write-Host "Exporting MFT to $temppath"
    Get-ForensicFileRecord | Export-Csv -NoTypeInformation -Encoding ASCII -Path $temppath -Force
    [System.GC]::Collect()
    Write-Host "Compressing MFT"
    Compress-7Zip -Path $temppath -ArchiveFileName $outpath
    Remove-item $temppath
    [System.GC]::Collect()
}

]==]

function run_powershell(initscript, cmd)
  -- Create powershell process and feed script to its stdin
  print("Initiatializing Powershell")
  pipe = io.popen("powershell.exe -noexit -nologo -nop -command -", "w")
  pipe:write(initscript)
  if cmd then
      print("Executing Command: " .. cmd)
      pipe:write(cmd)
  end
  return pipe:close()
end

----------------------------------------------------
-- SECTION 3: Collection / Inspection
----------------------------------------------------

host_info = hunt.env.host_info()
hunt.verbose("Starting Extention. Hostname: " .. host_info:hostname() .. ", Domain: " .. host_info:domain() .. ", OS: " .. host_info:os() .. ", Architecture: " .. host_info:arch())


if hunt.env.is_windows() and hunt.env.has_powershell() then
	-- Insert your Windows Code
    hunt.debug("Operating on Windows")
    outpath = [[c:\windows\temp\mft.7z]]
    -- Create powershell process and feed script/commands to its stdin
    cmd = 'Get-ICMFT -outpath ' .. outpath
    r = run_powershell(initscript, cmd)
    hunt.verbose("Powershell Returned: "..tostring(r))
    -- hash = hunt.hash.sha1(outpath)
end

----------------------------------------------------
-- SECTION 4: Results
--	Set threat status to aggregate and stack results in the Infocyte app:
--		Good, Low Risk, Unknown, Suspicious, or Bad
----------------------------------------------------

-- Recover evidence to S3
--recovery = hunt.recovery.s3(aws_key_id, s3_secret, s3_region, s3_bucket)
--s3path = host_info:hostname() .. '/mft.7z'
--recovery.upload_file(outpath, s3path)

-- hunt.log("MFT uploaded to S3: " .. hash)
hunt.good()
