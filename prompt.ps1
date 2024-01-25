$Global:__poshGitInstalled = [bool](Get-Module -Name posh-git -ListAvailable -Verbose:$false)

function Global:prompt
{
    $wd = (Get-Location).Path
    $user = (whoami).Split('\')[-1]
    $hostname = hostname
    $ver = ([string]$PSVersionTable.PSVersion).Split('.')[0..1] -join '.'
    $jobs = Get-Job

    # Extra versiony goodness:
    if ($null -ne $PSVersionTable.PSVersion.Patch)
    {
        $ver += ".$($PSVersionTable.PSVersion.Patch)"
    }
    
    $admin = $false
    if ($IsLinux -and $user -eq 'root')
    {
        $admin = $true
    }
    elseif (!$IsLinux)
    {
        $admin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    }
    
    $gitStatus = $Global:__poshGitInstalled -and (Get-GitStatus)
    
    if ($wd -eq $HOME)
    {
        $wd = '~'
    }
    elseif ($wd.Split('\')[-1] -ne '' -and !$gitStatus)
    {
        $wd = $wd.Split('\')[-1]
    }
    elseif ($gitStatus -and $wd -like '*::*')
    {
        $wd = $wd.Split(':')[-1]
    }
    
    # History count:
    Write-Host "$(((Get-History).Count + 1).ToString().PadLeft(3, '0')) " -NoNewline
    # PS Version:
    if ($PSVersionTable.PSVersion.PreReleaseLabel)
    {
        Write-Host "($($ver)-$($PSVersionTable.PSVersion.PreReleaseLabel)) " -ForegroundColor Red -NoNewline
    }
    else
    {
        Write-Host "($ver) " -ForegroundColor Magenta -NoNewline
    }
    # Timestamp:
    Write-Host "[$(([string](Get-Date)).Split()[1])] " -ForegroundColor Yellow -NoNewline
    
    # Job control:
    if ($jobs)
    {
        $r = $jobs.where({$_.State -eq 'Running'}).count
        $d = $jobs.where({$_.State -eq 'Completed' -and $_.HasMoreData}).count
        $c = $jobs.where({$_.State -eq 'Completed' -and -not $_.HasMoreData}).count
        
        $jobCounter = "jobs($($c)/$($jobs.Count))"
        
        Write-Host '[' -NoNewline -ForegroundColor Yellow
        if ($d) {Write-Host $jobCounter -NoNewline -ForegroundColor Red}
        elseif ($c -eq $jobs.Count)
                {Write-Host $jobCounter -NoNewline -ForegroundColor Green}
        else    {Write-Host $jobCounter -NoNewline -ForegroundColor Cyan}
        Write-Host ' : ' -NoNewline -ForegroundColor Gray
        # Running
        Write-Host ">$r " -NoNewline -ForegroundColor Cyan
        # HasData
        Write-Host "!$d " -NoNewline -ForegroundColor Red
        # Complete
        Write-Host "`$$c" -NoNewline -ForegroundColor Green
        
        Write-Host '] ' -NoNewline -ForegroundColor Yellow
    }
    
    if ($gitStatus)
    {
        Write-Host '[GIT] ' -ForegroundColor Green -NoNewline
    }
    else
    {
        
        if ($admin)
        {
            Write-Host "$($user)" -ForegroundColor Red -NoNewLine
        }
        else
        {
            Write-Host "$($user)" -ForegroundColor Green -NoNewLine
        }
        Write-Host " @ " -ForegroundColor Yellow -NoNewLine
        Write-Host "$($hostname) " -ForegroundColor Magenta -NoNewLine
    }
    if ($admin)
    {
        $sym = '#'
    }
    else
    {
        $sym = '$'
    }
    Write-Host "$($wd) " -ForegroundColor Cyan -NoNewLine
    if ($gitStatus)
    {
        Write-Host "`b" -NoNewline
        Write-Host (Write-VcsStatus) -NoNewline
    }
    #>
    Write-Host ''
    Write-Host "$($sym)" -ForegroundColor Cyan -NoNewLine
    return ' '
}

Invoke-Expression "function Reset-Prompt { . $($MyInvocation.MyCommand.Path) }"
New-Alias -Name 'rsp' -Value 'Reset-Prompt' -Force
