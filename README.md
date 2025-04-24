# SmartAdvocate Conversion Boilerplate
This repository serves as both the single source of truth for conversion scripts and a project boilerplate that includes all directories that sa-conversion-utils expects.
Scripts are documented in each system directory's respective Readme


## Methodology
This repo uses a "runlist" approach to decouple script ordering from filenaming convention, which allows source control because I am checking in and out the same files. why am I manually numbering 100 files?


## Workspace Directories
| Directory | Sub Directory | Purpose |
| -- | -- | -- |
_lib | |
||post-scripts|SQL scripts to be run after conversion scripts|
||python|python scripts to generate readme files|
||wipe-data|SQL scripts to wipe transactional data|
_trans | | General use transfer directory
_venv | | Python virtual environment
.github | | Github actions
backups | | Database backups
data | | Source data
logs | | Log files

## Source System Directories
litify
needles
