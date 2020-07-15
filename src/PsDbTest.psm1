. .\Connections.ps1

$connections = @()

function Invoke-PsDbTest {
    [CmdLetBinding()]
    Param(

    )

    $connectionDetails

    $testSections = Import-TestSections

    $testSections | Format-List -Property connectionName,query

    #$connection = Get-Connection "master"
    #try {
    #    $connection.Connection.Open();
    #    
    #    $connection.Connection.Close();
    #}
    #finally {
    #    $connection.Connection.Dispose();
    #}
}

function Import-TestSections {
    Get-ChildItem ".\SQL" -Filter "*.sql" | Sort -Property BaseName | ForEach {
        
        $connectionName = $_.BaseName.Substring($_.BaseName.IndexOf("_")+1,$_.BaseName.Length - ($_.BaseName.IndexOf("_")+1))

        $query = Get-Content $_.FullName

        return New-Object PSObject -Property @{connectionName=$connectionName;query=$query}
    }
}

function Get-Connection {
    [CmdLetBinding()]
    Param(
        [Parameter()]
        [string]$Name
    )

    [object]$connection = $connections | Where -Property Name -EQ -Value $Name

    if (!$connection) {
        $connectionDetail = $connectionDetails | Where -Property Name -EQ -Value $Name

        $connectionObject = New-Object "System.Data.SqlClient.SqlConnection"
        $connectionObject.ConnectionString = $connectionDetail.ConnectionString

        $connections += $(New-Object PSObject -Property @{Name=$connectionDetail.Name;Connection=$connectionObject})

        $connection = $connections | Where -Property Name -EQ -Value $Name
    }

    return $connection
}