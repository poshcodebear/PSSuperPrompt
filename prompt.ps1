function Global:prompt
{
    $wd = (Get-Location).Path
    $user = (whoami).Split('\')[-1]
    $hostname = hostname
    $ver = ([string]$PSVersionTable.PSVersion).Split('.')[0..1] -join '.'
    $jobs = Get-Job

    $admin = $false
    if ($IsLinux -and $user -eq 'root')
    {
        $admin = $true
    }
    elseif (!$IsLinux)
    {
        $admin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    }
    
    $gitStatus = (Get-Module -Name oh-my-posh -ListAvailable) -and (Get-VCSStatus)

    if ($wd -eq $HOME)
    {
        $wd = '~'
    }
    elseif ($wd.Split('\')[-1] -ne '' -and !$gitStatus)
    {
        $wd = $wd.Split('\')[-1]
    }
    
    # History count:
    Write-Host "$((Get-History).Count + 1) " -NoNewline
    # PS Version:
    Write-Host "($ver) " -ForegroundColor Magenta -NoNewline
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
        Write-VcsStatus
        Write-Host ''
    }
    Write-Host "$($sym)" -ForegroundColor Cyan -NoNewLine
    return ' '
}

Invoke-Expression "function Reset-Prompt { . $($MyInvocation.MyCommand.Path) }"
New-Alias -Name 'rsp' -Value 'Reset-Prompt' -Force
