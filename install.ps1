<# Workflow:
- Verify profile exists (done)
    - Create profile and profile path if necessary
- Copy prompt.ps1 to profile path
    - Note: should check to see if it already exists and to prompt to overwrite
- Add a line at the end of the profile to dot-source the prompt
    - Note: should check to see if the invocation already exists first and warn if no changes were made
- Add error handling
#>

$profilePath = Split-Path -Path $profile

if (! (Test-Path -Path $profilePath))
{
    New-Item -ItemType Directory -Path $profilePath
}
if (! (Test-Path -Path $profile))
{
    New-Item -ItemType File -Path $profile
}
