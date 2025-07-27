Function Find-WindowsSearchFiles {
    param(
        [parameter(Mandatory)]
        [string]$SearchString,

        [parameter(Mandatory)]
        [string]$Path,

        $SearchProperty = "System.FileName",
        $SearchOperator = "=",
        [Array]$Properties = @("System.ItemName", "System.DateCreated", "System.DateModified", "System.Size", "System.ItemType", "System.Search.AutoSummary")

    )

    $Columns = $Properties -Join ","

    $Query = "
        SELECT $Columns  FROM SYSTEMINDEX
        WHERE  CONTAINS(System.Search.Contents, '$SearchString') AND SCOPE = '$Path'
    "

    $ConnectionString = "provider=search.collatordso;extended properties=’application=windows’;" 
    $OleDBAdapter = [System.Data.OleDb.OleDbDataAdapter]::New($Query, $ConnectionString)
    $Dataset = [System.Data.DataSet]::New()

    if ($OleDBAdapter.fill($Dataset)) {
        $Dataset.tables[0]
    }

}

Function Open-CamasFile([string]$filename){
    # return [IO.Path]::Combine(@('C:\Users\tonymet\Local Documents\', "RFD Camas Washougal Project 2025", "Camas City Council 2025", $filename))
    return "C:\Users\tonymet\Local Documents\RFD Camas Washougal Project 2025\Camas City Council 2025\" + $filename
}