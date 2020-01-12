# ==
# Helper functions. Not exported
# ==
 
function Get-ConanVirtualEnv {
    param ([Parameter(Mandatory=$true, Position=0)] [string] $Name)

    return Join-Path -Path "$HOME" -ChildPath ".virtualenvs" | 
        Join-Path -ChildPath "conan-$Name"
}

function Get-ConanExecutable {
    param ([Parameter(Mandatory=$true, Position=0)] [string] $Name)

    return Get-ConanVirtualEnv $Name | 
        Join-Path -ChildPath "Scripts" | 
        Join-Path -ChildPath "conan.exe"
}

function Get-ConanUserHome {
    param ([Parameter(Mandatory=$true, Position=0)] [string] $Name)
    return Join-Path -Path "$HOME" -ChildPath ".conan-$Name"
}

# ==
# Interface (exported functions)
# ==

# Run a conan instance from a virtual env, with its own home space
function Invoke-ConanInstance {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [ArgumentCompleter({
            param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
            Get-ConanInstances -Prefix $WordToComplete
        })]
        [string] $Name,
        [Parameter(Mandatory=$false, Position=1, 
        ValueFromRemainingArguments=$true)]
        [String[]] $ConanArgs
    )

    $conan_exe = Get-ConanExecutable $Name

    $conan_home_temp = $env:CONAN_USER_HOME
    $env:CONAN_USER_HOME = Get-ConanUserHome $Name
    
    try {
        if( Test-Path $conan_exe ) {
            & $conan_exe $ConanArgs 
        }
        else {
            Write-Error "Conan doesn't exist at '$conan_exe'"
        }
    }
    finally {
        $env:CONAN_USER_HOME = $conan_home_temp
    }
}

# Update the conan version for a given instance
function Update-ConanInstanceVersion {
    param (
        [Parameter(Mandatory=$true, Position=0)] 
        [ArgumentCompleter({
            param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
            Get-ConanInstances -Prefix $WordToComplete
        })]
        [string] $Name,
        [Parameter(Mandatory=$false, Position=1)] [string] $TargetVersion
    )

    $pip = Get-ConanVirtualEnv $Name | Join-Path -ChildPath "Scripts" | Join-Path -ChildPath "pip.exe"

    $pip_install_args = if ($TargetVersion) { "conan==$TargetVersion" } else { "conan" }

    & $pip uninstall conan -y
    & $pip install -U $pip_install_args
}

# Create a new instance. Can target a particular conan version and python 2
function New-ConanInstance {
    param (
        [Parameter(Mandatory=$true, Position=0)] [string] $Name,
        [Parameter(Mandatory=$false, Position=1)] [string] $TargetVersion,
        [switch] $Python2 = $false
    )
    
    $venv = Get-ConanVirtualEnv $Name
    $python_args = if ($Python2) { "-2", "-m", "virtualenv" } else { "-3", "-m", "venv" }

    if( Test-Path $venv ) {
        Write-Error "Conan instance $Name already exists"
    }
    else {
        & py $python_args $venv 
        if($?) {
            Update-ConanInstanceVersion -Name $Name -TargetVersion $TargetVersion
        }
        else {
            Write-Error "Unable to create virtualenv"
        }
    }
}

# List available instances (also useful for tab-completion)
function Get-ConanInstances {
    param ( [Parameter(Mandatory=$false, Position=0)] [string] $Prefix )
    $virtualenv_dir = Join-Path -Path $HOME -ChildPath ".virtualenvs" 
    $conan_prefix = "conan-"
    return Get-ChildItem -Directory $virtualenv_dir -Filter "${conan_prefix}${Prefix}*" | 
        Select-Object -ExpandProperty Name | 
        % {$_.SubString($conan_prefix.length)}
}

# Remove an instance
function Remove-ConanInstance {
    param (
        [ArgumentCompleter({
            param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
            Get-ConanInstances -Prefix $WordToComplete
        })]
        [string] $Name, 
        [switch] $Yes = $false)
    $venv = Get-ConanVirtualEnv $Name
    $conan_home = Get-ConanUserHome $Name

    if( Test-Path $venv ) {
        if( $Yes ) {
            Remove-Item -Path $venv -Force -Recurse 
            Write-Host "Removed virtual env at $venv"
        }
        else {
            Remove-Item -Path $venv -Force -Recurse -Confirm
        }
    }
    else {
        Write-Host "No virtual env found for $Name"
    }

    if( Test-Path $conan_home ) {
        if( $Yes ) {
            Remove-Item -Path $conan_home -Force -Recurse
        }
        else {
            Remove-Item -Path $conan_home -Force -Recurse -Confirm
            Write-Host "Removed conan home at $venv"
        }
    }
    else {
        Write-Host "No home found for $Name"
    }
}

# ==
# Plumbing
# ==

Export-ModuleMember -Function Invoke-ConanInstance, Update-ConanInstanceVersion, New-ConanInstance, Get-ConanInstances, Remove-ConanInstance
