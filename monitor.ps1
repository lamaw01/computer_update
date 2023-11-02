function Get-MonitorInfo {
    [CmdletBinding(DefaultParameterSetName = 'ComputerName')]
    Param(
        [parameter(ParameterSetName = 'ComputerName', ValueFromPipeline)]
        [String[]]$ComputerName,

        [parameter(ParameterSetName = 'CimSession')]
        [cimsession]$CimSession,

        [parameter()]
        [switch]$Active
    )

    begin {
        $cimParam = @{
            ClassName = 'WmiMonitorID'
            Namespace = 'root\wmi'
        }
        if ($Active.IsPresent) {
            $cimParam['Filter'] = 'active = 1'
        }

        function ConvertCharToString ($charArray) {
            [char[]]$charArray -join $null -replace '\s+$'
        }

    }

    process {

        if ($ComputerName) {
            $cimParam['Computername'] = $ComputerName
        }
        if ($CimSession) {
            $cimParam['CimSession'] = $CimSession
        }
        $monitor = Get-CimInstance @cimParam | Format-Table -Property @(
            @{Name = 'Manufacturer'; Expression = {[string]::new([char[]]($_.Manufacturername)).Trim("`0") }; Alignment="left";}
            @{Name = 'Model'; Expression = { [string]::new([char[]]($_.UserFriendlyName)).Trim("`0")  };  Alignment="center";}
            @{Name = 'Serial'; Expression = { [string]::new([char[]]($_.SerialNumberID)).Trim("`0")  };  Alignment="center";}
        ) | Out-Host
        Write-Host $monitor
    }
}
