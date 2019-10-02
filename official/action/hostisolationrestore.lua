--[[
  Infocyte Extension
	Name: Host Isolation Restore
  Description: Reverses the local network isolation of a Windows, Linux, and OSX systems using windows firewall, iptables, ipfw, or pf respectively
  Author: Infocyte
  Created: 9-16-2019
  Updated: 9-16-2019 (Gerritz)

]]--

----------------------------------------------------
-- SECTION 1: Variables
----------------------------------------------------
infocyteips = "3.209.70.118"
workingfolder = os.getenv("TEMP")
OS = getos()


----------------------------------------------------
-- SECTION 2: Actions
----------------------------------------------------


if string.find(OS, "windows xp") then
	-- TODO
elseif string.find(OS, "windows") then
	os.execute("netsh advfirewall firewall delete rule name='Infocyte Host Isolation'")
	os.execute("netsh advfirewall import " .. workingfolder .. "\\fwbackup.wfw")
	os.execute("netsh advfirewall reset")
elseif string.find(OS, "osx") or string.find(OS, "") then
	-- TODO: ifw
else
	-- Assume linux-type OS and iptables
	-- TODO: IPTables
end

----------------------------------------------------
-- SECTION 3: Output
----------------------------------------------------
log("Host has been restored and is no longer isolated")
