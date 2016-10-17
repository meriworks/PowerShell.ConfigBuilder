# Meriworks.PowerShell.ConfigBuilder
The config builder aims to make it easy to maintain multiple development environments for a project.
The config builder can  perform two different methods of build, merge and replace.

## Merge
You maintain a base configuration (like web.base.config) and several others (one for each development environment, build configuration etc.) and the ConfigBuilder will merge the base with the selected merge files procuce the actual configuration (like web.config) before building the project itself.

### Scanning
The config builder will scan all project folders for a file named **\*.base.config** and perform a merge if the source (base/merge) files are newer than the target config file.

### Merging
Merging is performed using XmlTransform using xdt merge files
<https://msdn.microsoft.com/en-us/library/dd465326(v=vs.110).aspx>

#### Merge files
Any file matching the base file path and name (before the .base. ($name)) and with a xdt extension will be a potential merge file. The follwing merge files will be processed.

 1. Step - custom xdt files named `$name.step.$stepname.xdt`. Will be merged in **alpabetical order**.
 2. Hostname - A xdt file named `$name.host.$hostname.xdt` where the $hostname must match the hostname of the current machine (Can be overridden (se below))

**Example**
* You are running a build on the machine **dev1**.
* You have the app.base.config file in your project along with the `app.step.initialStep.xdt`, `app.step.sequentialStep.xdt`, `app.host.dev1.xdt` and `app.host.dev2.xdt`.
* Merge will process `app.base.config` -> `app.step.initialStep.xdt` -> `app.step.sequentialStep.xdt` -> `app.host.dev1.xdt` -> `app.config`
   
  app.dev2.xdt will be ignored since it does not match the current hostname.

* Files that are missing will be ignored

### Merge if newer
Normally a merge is always performed when building the project, but if you would like to trigger merge and only build the configuration if the base or a merge file is newer than the target file, name the base file to **.base.mergeifnewer.config**.

### Expanding variables
After merge, the resulting file is scanned for variables and these are expanded inline.
A variable is defined by the following syntax

	$(name)

The following variables are supported

ProjectDir - The path to the project directory
SolutionDir - The path to the solution directory
ConfigBuilderHost - The current hostname (can be overridden, see below)

## Replace
The replace mode looks for files matching the **\*.base.replace.\*** pattern and will look for a file that matches the **\*.host.[hostname].\*** pattern and copy it to the **\*.\*** path.

Example:
You would like to check in different license.config files, one for each host. You set up the following files

* `license.base.replace.config` - an emtpy trigger file that will trigger the merge
* `license.host.productionServer.config` - a license file for the productionServer
* `license.host.dev1.config` - a license file for the dev1 host.

When building, the script will look for the current hostname (can be overridden, see below)), and if it exists, copy the matching hostfile to the `license.config` file.

If no matching hostfile is found, the base file is copied to the target location.

## Overriding

### ConfigBuilderHost
If you would like to change the build to simulate another host, you can set the msbuild property ConfigBuilderHost either by supplying it as a parameter to the msbuild.exe

	/p:ConfigBuilderHost=test

or setting it in the .csproj file

	<PropertyGroup>
		<ConfigBuilderHost>test</ConfigBuilderHost>
	</PropertyGroup>