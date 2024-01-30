<# Workflow:
- Verify profile exists (done)
    - Create profile and profile path if necessary
- Copy prompt.ps1 to profile path (done)
    - Note: should check to see if it already exists and to prompt to overwrite
- Add a line at the end of the profile to dot-source the prompt
    - Note: should check to see if the invocation already exists first and warn if no changes were made
- Add error handling
- Add parameters
    - Quiet (no feedback other than prompting)
    - Force (no prompting, just do it)
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

$promptFile = "$($PSScriptRoot)\prompt.ps1"
$promptFileExists = Test-Path -Path "$($profilePath)\prompt.ps1"

$forceCopy = $false
if ($promptFileExists)
{
    Write-Host 'Profile already exists, ' -NoNewline
    $validResponse = $false
    do
    {
        Write-Host 'overwrite? (y/n)'
        switch (Read-Host)
        {
            'y'
            {
                $forceCopy = $true
                $validResponse = $true
                break
            }
            'n'
            {
                $validResponse = $true
                break
            }
            default { Write-Warning -Message "'$($_)' is an invalid response" }
        }
    }
    until ($validResponse)
}
if ($forceCopy -or -not $promptFileExists)
{
    Copy-Item -Path $promptFile -Destination $profilePath
}
