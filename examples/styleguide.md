# Infocyte Extensions Style guide

## Extension Meta

### Filenames
Extension filenames should be `<Name>.lua`

### Preamble
All extensions should have a comment block on top using the below format.
In the future, we may introduce a filetype that includes metadata like this.

>>
--[[
	Infocyte Extension
	Name: Template
	Type: Action
	Description: Example script show format, style, and options for committing an action against a host.
	Author: Infocyte
	Created: 20190919
	Updated: 20190919 (Gerritz)
]]--

### Extension Types
There may be some ambiguity between an extension's actual type: is it a collection or action extension? When in doubt, anytime the extension performs changes to the system, it should probably be labelled an **Action** extension. Although these types are not going to be initially enforced, the near future workflow for using **Action** extensions will be separated from **Collection** extensions using a Response workflow in the Infocyte application which is independent of scanning.


## Infocyte's Survey (Hunt.\*) API
Infocyte exposes the functionality of its' Survey and Agent to Lua via the `hunt.\*` library of functions. Where possible, use these functions over shell commands as they are cross-platform, safer, and implemented at a lower level on each operating system.

## Formatting results

### Threat status
Threat Status provides aggregation for display in the Infocyte app. Use this feature to highlight interesting results.d

You must use one of the built-in statuses below:
- Blacklist (will set host as compromised)
- Bad (will set host as compromised)
- Suspicious
- Low Risk
- Unknown
- Good
- Whitelist


### Logs/messages
`hunt.log()` is the function to send data to Infocyte as part of the survey results. Use this for any textual data. It can be viewed in raw form in the app or extracted via the API.

**Max Size of Log Messages:** 1MB
**Max Number of Log Messages:** 1000

### Binary or Large Evidence Data
If your extension recovers Binary data or other types of large evidence (i.e. memory dump, files, .evt or .dat files), you should send it to a 3rd party bucket that users provide.

The following functions are built in and available to send data if the variables are provided:
- S3 Bucket
- sFTP site
- Local SMB share on the target network
