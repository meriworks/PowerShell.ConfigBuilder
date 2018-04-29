# Meriworks.PowerShell.ConfigBuilder

This nuget package adds a convention to Visual Studio projects to allow
building .config files depending on environment. For example, if developers
has different databases configured in web.config, this package can support
each developer with a unique web.config.

* [Documentation](#documentation)
* [License](#license)
* [Author](#author)
* [Changelog](#changelog)
<a name="documentation"></a>
## Documentation
The config builder aims to make it easy to maintain multiple development environments for a project.
The config builder can  perform two different methods of build, merge and replace.

### Merge
You maintain a base configuration (like web.config) and several others (one for each development environment, build configuration etc.) and the ConfigBuilder will merge the base with the selected merge files produce the actual configuration before building the project itself.
It's much like the normal publish handling with the difference that it occurs when you build the project instead.

#### XDT files
To create a merge file, you create an xdt file for the file you would like to modify according to the following syntax.

	filename.extension.merge.keyword.value.xdt

where

 * _filename.extension_ - same filename and extension as the file to modify
 * _keyword_ - optional keyword that triggers when and if a merge is performed
 * _value_ - is an argument used to control the _keyword_ 
 
##### Keywords
The following keywords are supported and are executed in this order.

* _pre_ - will trigger a merge _before_ any other merges are performed.
* _step_ - will always trigger a merge in the alphabetical order of the _vaule_.
* _host_ - This keyword will trigger a merge if the hostname of the computer that the project is compiled on matches the _value_ argument.

	**Example:** `web.config.merge.host.mycomputer.xdt` will trigger a merge if the hostname of the compiling machine is `mycomputer`.
* _configuration_ - will trigger a merge if the current build configuration matches the _value_ argument.

	**Example:** `web.config.merge.configuration.debug.xdt` will trigger a merge if the project is building the `debug` configuration.
* _post_ - will trigger a merge _after_ all other merges have been performed.

##### Example
A folder contains the following files

* web.config
* web.config.merge.configuration.debug.xdt
* web.config.merge.configuration.release.xdt
* web.config.merge.host.devmachine1.xdt
* web.config.merge.host.devmachine2.xdt
* web.config.merge.post.xdt
* web.config.merge.pre.xdt
* web.config.merge.xdt

When project is compiled on the `devmachine1` computer, using the debug configuration, merge files will be applied in the following order:

* web.config
* web.config.merge.pre.xdt
* web.config.merge.xdt
* web.config.merge.host.devmachine1.xdt
* web.config.merge.configuration.debug.xdt
* web.config.merge.post.xdt

#### Merging
Merging is performed using XmlTransform using xdt merge files
<https://msdn.microsoft.com/en-us/library/dd465326(v=vs.110).aspx>


#### Expanding variables
Before merging a xdt file, the merge file is scanned for variables and these are expanded inline.
A variable is defined by the following syntax

	$(name)

The following variables are supported

* ProjectDir - The path to the project directory
* SolutionDir - The path to the solution directory
* Configuration - The current configuration of the project
* ConfigBuilderHost - The current hostname (can be overridden, see below)

##### Example

If you have an **app.config** file in your project (located at **c:\proj\myProject\myproject.cproj**) with the following contents

	<?xml version="1.0" encoding="utf-8"?>
	<configuration>
	  <appSettings>
	    <add key="path" value="c:\temp\some.file"/>
	  </appSettings>
	</configuration>

and add a merge file named **app.config.merge.xdt** with the following contents
	
	<?xml version="1.0" encoding="utf-8"?>
	<configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
	  <appSettings>		
	    <add key="path" value="$(ProjectDir)MyFolder\some.file" xdt:Locator="Match(key)" xdt:Tranform="SetAttributes" > 
	  </appSettings>
	</configuration>

The resulting app.content after compilation will look like below

	<?xml version="1.0" encoding="utf-8"?>
	<configuration>
	  <appSettings>
	    <add key="path" value="c:\proj\myProject\MyFolder\some.file"/>
	  </appSettings>
	</configuration>


### Replace
The replace mode looks for files matching the `filename.replace.keyword.value.extension` pattern where

 * _filename.extension_ - same filename and extension as the file to modify
 * _keyword_ - keyword that triggers if a replace is performed
 * _value_ - is an optional argument (see keywords below) used to control the _keyword_ 

It will replace the `filename.extension` file with the replace one that matches the keyword. 

#### Keywords

* _host_ - This keyword will trigger a replace if the hostname of the computer that the project is compiled on matches the _value_ argument.

	**Example:** `web.replace.host.mycomputer.config` will trigger a replace if the hostname of the compiling machine is `mycomputer`.
* _default_ - will indicate the default replacement file that will be used if no other matching keyword is active. **Note: This file must exists to trigger the replace function**

**Example:**
You would like to check in different license.config files, one for each host. You set up the following files

* `license.replace.default.config` - an default license file that will be used if no other file deems suitable.

* `license.replace.host.productionServer.config` - a license file for the productionServer
* `license.replace.host.dev1.config` - a license file for the dev1 host.

When building, the script will look for the current hostname (can be overridden, see below)), and if it exists, copy the matching hostfile to the `license.config` file.

If no matching hostfile is found, the default file is copied to the target location.

### Overriding

#### ConfigBuilderHost
If you would like to change the build to simulate another host, you can set the msbuild property ConfigBuilderHost either by supplying it as a parameter to the msbuild.exe

	/p:ConfigBuilderHost=test

or setting it in the .csproj file

	<PropertyGroup>
		<ConfigBuilderHost>test</ConfigBuilderHost>
	</PropertyGroup>

### Legacy
Meriworks.PowerShell.ConfigBuilder had a previous convention including a .base. notation in the filename. This is still supported, and documentation regarding that can be [found at github](https://github.com/meriworks/PowerShell.ConfigBuilder/blob/b6c8584ea626558b9068f7f91f7bfbb835013f6b/Meriworks.PowerShell.ConfigBuilder/nuspec/content/_msbuild/Meriworks.PowerShell.ConfigBuilder/readme.md).

<a name="license"></a>
## License
Project is licensed using the [MIT License](LICENSE.md).

<a name="author"></a>
## Author
Package is developed by [Dan Händevik](mailto:dan@meriworks.se), [Meriworks](http://www.meriworks.se).

<a name="changelog"></a>
## Changelog

## v5.1.5 - 2018-04-29
* Fixed issue where merge didn't trigger if .merge.xdt is the only mergefile

## v5.1.4 - 2017-11-21
* Fixed support for Visual Studio 2017 [#1](https://github.com/meriworks/PowerShell.ConfigBuilder/issues/1)

### v5.1.3 - 2016-10-21
* Removed unused dll from nupkg file

### v5.1.2 - 2016-10-20
* Fixed error with nuget install script

### v5.1.1 - 2016-10-20
* Removed scripts and readme from project

### v5.1 - 2016-10-20
* Added a new default convention that modifies the original file. Just add xdt files for automatic merge on build. The old convention is still supported.

### v5.0.1 - 2016-10-17
* Minor changes in nuspec, license and documentation

### v5.0.0 - 2016-10-17
* Initial release


