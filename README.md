# Meriworks.PowerShell.ConfigBuilder

This nuget package adds a convention to Visual Studio projects to allow
building .config files depending on environment. For example, if developers
has different databases configured in web.config, this package can support
each developer with a unique web.config.

## Documentation
Documentation is included in the nuget package and can also be read in
[the readme.md file](Meriworks.PowerShell.ConfigBuilder/nuspec/content/_msbuild/Meriworks.PowerShell.ConfigBuilder/readme.md).

## License
Project is licensed using the [MIT License](LICENSE.md).

## Author
Package is developed by [Dan Händevik](mailto:dan@meriworks.se), [Meriworks](http://www.meriworks.se).

## Changelog

### v5.1
* Added a new default convention that modifies the original file. Just add xdt files for automatic merge on build. The old convention is still supported.

### v5.0.1 - 2016-10-17
* Minor changes in nuspec, license and documentation

### v5.0.0 - 2016-10-17
* Initial release

