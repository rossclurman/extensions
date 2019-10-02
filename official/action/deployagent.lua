--[[
	Infocyte Extension
	Name: Deploy Infocyte Agent
	Type: Action
	Description: Installs Infocyte agents on Windows, Linux, or OSX
	Author: Infocyte
	Created: 9-19-2019
	Updated: 9-19-2019 (Gerritz)

]]--

----------------------------------------------------
-- SECTION 1: Variables
----------------------------------------------------
infocyteips = get_infocyteips() -- "3.209.70.118"
workingfolder = os.getenv("TEMP")
computername = os.getenv("COMPUTERNAME")
OS = get_os()
myinstance = get_hunt_api() -- "alpo1.infocyte.com"


----------------------------------------------------
-- SECTION 2: Actions
----------------------------------------------------

-- TODO: Check for Agent (agent will be the only thing able to communicate out)
agentinstalled = true
if agentinstalled then
  log("Infocyte Agent is already installed")
  exit()
else
  -- Install Infocyte Agent
  if string.find(OS, "xp") then
  	-- TODO: XP Install

  elseif string.find(OS, "windows") then
    psagentdeploycmd = "& { \[System.Net.ServicePointManager\]::SecurityProtocol = \[System.Net.SecurityProtocolType\]::Tls12; (new-object Net.WebClient).DownloadString('https://raw.githubusercontent.com/Infocyte/PowershellTools/master/AgentDeployment/install_huntagent.ps1') | iex; installagent " .. myhuntinstance .." }"
  	result = os.execute("powershell.exe -nologo -win 1 -executionpolicy bypass -nop -command { "..psagentdeploycmd.." }")
  	if not result then
      log("Powershell agent install script failed to run. \[Error: "..result.."\]")
      exit()
    end
  elseif string.find(OS, "osx") or string.find(OS, "bsd") then
  	-- TODO:
  else
  	-- TODO: Assume linux-type OS
  end
end

--[[
if string.find(OS, "xp") then
	-- TODO: XP
elseif string.find(OS, "windows") then
  -- TODO: Windows
elseif string.find(OS, "osx") or string.find(OS, "bsd") then
	-- TODO: OS
else
	-- TODO: Assume linux OS
end
]]--

----------------------------------------------------
-- SECTION 3: Output
----------------------------------------------------
log("Infocyte Agent has been installed")
