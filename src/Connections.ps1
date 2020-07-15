[object[]]$connectionDetails = @(
    @{Name="master";connectionString="server=localhost;Initial Catalog=master"},
    @{Name="msdb";connectionString="server=localhost;Initial Catalog=msdb"}
) | ForEach {New-Object PSObject -Property $_}

