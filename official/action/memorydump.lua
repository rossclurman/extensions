--[[
	Infocyte Extension
	Name: Memory Extraction
	Type: Collection
	Description: Uses winpmem or linpmem to dump full physical memory and
     stream it to an S3 bucket, ftp server, or smb share. If output path not
     specified, will dump to local temp folder.
	Author: Infocyte
	Created: 9-19-2019
	Updated: 9-19-2019 (Gerritz)

]]--

----------------------------------------------------
-- SECTION 1: Variables
----------------------------------------------------
infocyteips = hunt.net.() -- "3.209.70.118"
workingfolder = os.getenv("TEMP")
computername = os.getenv("COMPUTERNAME")
OS = hunt.env.os() -- determine host OS
myinstance = hunt.net.api() -- "alpo1.infocyte.com"
hunt.log("OS="..OS)

----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------


----------------------------------------------------
-- SECTION 3: Actions
----------------------------------------------------

-- TODO: Install pmem driver
agentinstalled = true
if string.find(OS, "windows") then
  -- Load driver
  result = os.execute("winpmem_1.3.exe -L")
  if not result then
    log("Winpmem driver failed to install. \[Error: "..result.."\]")
    exit()
  end
  -- Dump Memory to disk
  os.execute("winpmem.exe --output "..workingfolder.."\\physmem.map --format map")
  log("Memory dump started to local "..workingfolder.."\\physmem.map")
  -- Dump memory to S3 bucket
  os.execute("winpmem.exe --output - --format map | ")
  log("Memory dump started to S3 Bucket X")
  -- Dump memory to FTP server
  os.execute("winpmem.exe --output - --format map | ")
  log("Memory dump started to local FTP X")
  -- Dump memory to SMB share
  os.execute("winpmem.exe --output - --format map | ")
  log("Memory dump started to SMB share X")
  .
elseif string.find(OS, "osx") or string.find(OS, "bsd") then
	-- TO DO:
else
	-- TO DO: Assume linux-type OS
end

--[[
if string.find(OS, "xp") then
	-- TO DO: XP
elseif string.find(OS, "windows") then
  -- TO DO: Windows
elseif string.find(OS, "osx") or string.find(OS, "bsd") then
	-- TO DO: OS
else
	-- TO DO: Assume linux OS
end
]]--

----------------------------------------------------
-- SECTION 4: Output
----------------------------------------------------
log("Infocyte Agent has been installed")
