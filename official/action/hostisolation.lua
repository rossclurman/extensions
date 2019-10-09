--[[
	Infocyte Extension
	Name: Host Isolation
	Type: Action
	Description: Performs a local network isolation of a Windows, Linux, or OSX
	 system using windows firewall, iptables, ipfw, or pf
	Author: Infocyte
	Created: 9-16-2019
	Updated: 9-16-2019 (Gerritz)

]]--

----------------------------------------------------
-- SECTION 1: Variables
----------------------------------------------------
OS = hunt.env.os() -- determine host OS
myinstance = hunt.net.api() -- "alpo1.infocyte.com"
infocyteips = hunt.net.api_ipv4()
workingfolder = os.getenv("TEMP")
computername = os.getenv("COMPUTERNAME")


----------------------------------------------------
-- SECTION 2: Functions
----------------------------------------------------


----------------------------------------------------
-- SECTION 3: Actions
----------------------------------------------------

-- TO DO: Check for Agent and install if not present
-- agent will be the only thing able to communicate out
agentinstalled = true
if agentinstalled then
	-- Continue
else
	-- Install Infocyte Agent
	if string.find(OS, "xp") then
		-- TO DO: XP
	elseif string.find(OS, "windows") then
		psagentdeploycmd = [[
		& { [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
		(new-object Net.WebClient).DownloadString('https://raw.githubusercontent.com/Infocyte/PowershellTools/master/AgentDeployment/install_huntagent.ps1') |
			iex; installagent ]] .. myhuntinstance .." }"

		result = os.execute("C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -nologo -win 1 -executionpolicy bypass -nop -command { "..psagentdeploycmd.." }")
		if not result then
			hunt.log("Powershell agent install script failed to run. [Error: "..result.."]")
			exit()
		end
	elseif string.find(OS, "osx") or string.find(OS, "bsd") then
		-- TO DO: OS
	else
		-- TO DO: Assume linux OS
	end
end

if string.find(OS, "windows xp") then
	-- TO DO: XP's netsh
elseif string.find(OS, "windows") then
	os.execute("mkdir " .. workingfolder)
	os.execute("netsh advfirewall export " .. workingfolder .. "\\fwbackup.wfw")
	os.execute("netsh advfirewall firewall set rule all NEW enable=no")
	os.execute("netsh advfirewall firewall add rule name='Infocyte Host Isolation' dir=in action=allow protocol=ANY remoteip=" .. infocyteips)
	os.execute("netsh advfirewall reset")
elseif string.find(OS, "linux") then
	-- TO DO: IPTables
elseif string.find(OS, "osx") or string.find(OS, "bsd") then
	-- TO DO: ipfw (old) or pf (10.6+)
else
	-- Assume linux-type OS and iptables
	-- TO DO: IPTables
end


----------------------------------------------------
-- SECTION 4: Output
----------------------------------------------------
log("Host has been isolated to " .. infocyteips)
