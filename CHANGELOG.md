# Changelog

## v1.1.0 (2024-01-24)

- Fixed a delay with every prompt redraw to check for the git modules
- Removed dependency on `oh-my-posh`
    - The cmdlet from `oh-my-posh` is not in newer versions, and there's a cmdlet in `posh-git` that does the exact same thing
- Added last execution time for PowerShell v7 and higher
- Added patch number to the version element for versions of PowerShell that include a Patch element on `$PSVersionTable.PSVersion`
- Added pre-release label for pre-release (beta) versions of PowerShell
- Fixed an issue with displaying the git status element when on a network share
- Added padding to the command counter to 3 digits to help reduce prompt data shifting around
