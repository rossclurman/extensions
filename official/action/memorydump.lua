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
OS = hunt.env.os() -- determine host OS
myinstance = hunt.net.api() -- "alpo1.infocyte.com"
computername = os.getenv("COMPUTERNAME")
workingfolder = os.getenv("TEMP")

destination = "S3"

----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------


----------------------------------------------------
-- SECTION 3: Actions
----------------------------------------------------

hunt.log("Memory Dump for "..OS.." Initiated")

-- TODO: Install pmem driver
agentinstalled = true
if string.find(OS, "windows") then
  -- Load driver
  result = os.execute("winpmem_1.3.exe -L")
  if not result then
    hunt.error("Winpmem driver failed to install. [Error: "..result.."]")
    exit()
  end
  -- Dump Memory to disk
  os.execute("winpmem.exe --output "..workingfolder.."\\physmem.map --format map")
  hunt.log("Memory dump started to local "..workingfolder.."\\physmem.map")
  -- Dump memory to S3 bucket
  os.execute("winpmem.exe --output - --format map | ")
  hunt.log("Memory dump started to S3 Bucket X")
  -- Dump memory to FTP server
  os.execute("winpmem.exe --output - --format map | ")
  hunt.log("Memory dump started to local FTP X")
  -- Dump memory to SMB share
  os.execute("winpmem.exe --output - --format map | ")
  hunt.log("Memory dump started to SMB share X")

elseif string.find(OS, "osx") or string.find(OS, "bsd") then
	-- TO DO:

else
	-- TO DO: Assume linux-type OS

end


----------------------------------------------------
-- SECTION 4: Output
----------------------------------------------------
log("Memory dump completed. Evidence uploaded to "..destination)
