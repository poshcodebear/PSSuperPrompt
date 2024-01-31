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

try
{
    if (! (Test-Path -Path $profilePath))
    {
        New-Item -ItemType Directory -Path $profilePath -ErrorAction Stop
    }
    if (! (Test-Path -Path $profile))
    {
        New-Item -ItemType File -Path $profile -ErrorAction Stop
        Write-Warning -Message "New profile created at: '$($profile)'"
    }
}
catch {throw "No profile found and unable to create one; exception: $($_.Exception.Message)"}

$promptFile = "$($PSScriptRoot)\prompt.ps1"
$promptFileExists = Test-Path -Path "$($profilePath)\prompt.ps1"

$forceCopy = $false
if ($promptFileExists)
{
    $forceCopy = Get-ValidResponse -Message 'Prompt script already exists, overwrite?' -ValidResponsesTable $validResponses
}
if ($forceCopy -or -not $promptFileExists)
{
    try   {Copy-Item -Path $promptFile -Destination $profilePath -ErrorAction Stop}
    catch {throw "Unable to copy prompt script to '$($profilePath)'; exception: $($_.Exception.Message)"}
}

$promptLine = "`n# PSSuperPrompt`n. '$($promptFile)'"
$promptRegEx = '# PSSuperPrompt\n\. ''(?<PromptFile>[^'']+)'''
try   {$profileContent = Get-Content -Path $profile -Raw}
catch {throw "Unable to read from profile; exception: $($_.Exception.Message)"}
try
{
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
                $outFileSplat = @{
                    FilePath    = $profile
                    NoNewline   = $true
                    ErrorAction = 'Stop'
                }

                $profileContent -replace $promptRegEx, $promptLine.TrimStart() | Out-File @outFileSplat
            }
        }
    }
    else
    {
        $promptLine | Out-File -FilePath $profile -Append -ErrorAction Stop
    }
}
catch {throw "Unable to add prompt to profile; exception: $($_.Exception.Message)"}
