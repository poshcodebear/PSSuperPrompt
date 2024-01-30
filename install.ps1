<# Workflow:
- Verify profile exists (done)
    - Create profile and profile path if necessary
- Copy prompt.ps1 to profile path (done)
    - Note: should check to see if it already exists and to prompt to overwrite
- Add a line at the end of the profile to dot-source the prompt (done)
    - Note: should check to see if the invocation already exists first and warn if no changes were made
- Add error handling
- Add parameters
    - Quiet (no feedback other than prompting)
    - Force (no prompting, just do it)
#>

function Get-ValidResponse
{
    param
    (
        [string]$Message,
        [hashtable]$ValidResponsesTable
    )
    
    while ($true)
    {
        Write-Host $Message -NoNewline
        Write-Host " (Select: <$($ValidResponsesTable.Keys -join '/')>)"
        
        $response = Read-Host
        
        if ($response -in $ValidResponsesTable.Keys)
        {
            return $ValidResponsesTable[$response]
        }
        Write-Warning "'$($response)' in an invalid response, please try again"
    }
}
$validResponses = [ordered]@{
    'y' = $true
    'n' = $false
}

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
    $forceCopy = Get-ValidResponse -Message 'Prompt script already exists, overwrite?' -ValidResponsesTable $validResponses
}
if ($forceCopy -or -not $promptFileExists)
{
    Copy-Item -Path $promptFile -Destination $profilePath
}

$promptLine = "`n# PSSuperPrompt`n. '$($promptFile)'"
$promptRegEx = '# PSSuperPrompt\n\. ''(?<PromptFile>[^'']+)'''
$profileContent = Get-Content -Path $profile -Raw
if ($profileContent -match $promptRegEx)
{
    
    if ($matches.PromptFile -eq $promptFile)
    {
        Write-Warning -Message 'Prompt already installed in profile, no changes needed'
    }
    else
    {
        Write-Warning -Message "Prompt already installed in profile with a different path"
        Write-Warning -Message "Existing: $($matches.PromptFile)"
        Write-Warning -Message "New:      $($promptFile)"
        
        $updatePrompt = Get-ValidResponse -Message 'Update?' -ValidResponsesTable $validResponses
        if ($updatePrompt)
        {
            $profileContent -replace $promptRegEx, $promptLine.TrimStart() | Out-File -FilePath $profile -NoNewline
        }
    }
}
else
{
    $promptLine | Out-File -FilePath $profile -Append
}
