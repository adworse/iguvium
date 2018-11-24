# Changelog

## [Unreleased]

## [0.8.4] - 2018-11-24
### Changed
- Render phrases before cell assembly option of Iguvium::Table#to_a method is now true by default. 
Please set this option to `false` explicitly if you don't expect any merged cells in your table.



## [0.8.3] - 2018-11-23
### Added
- An option to render phrases before cell assembly is added to `Iguvium::Table#to_a` method. 
This fixes most of merged cells issues, but sometimes glues cells that should be separate.

