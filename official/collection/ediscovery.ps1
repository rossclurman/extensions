$output   = "$($env:temp)\edisco.csv"

Function Get-StringMatch ($path, $String, $charactersAround = 30){
    $results = @()
    $application = New-Object -comobject word.application
    $application.visible = $False
    $files = Get-Childitem $path -Include *.docx,*.doc -Recurse | Where-Object { !($_.psiscontainer) }

    # Loop through all *.doc files in the $path directory
    Foreach ($file In $files)
    {
        $document = $application.documents.open($file.FullName,$false,$true)
        $range = $document.content

        If($range.Text -match ".{$($charactersAround)}$($String).{$($charactersAround)}"){
             $properties = @{
                File = $file.FullName
                Match = $String
                TextAround = $Matches[0]
             }
             $results += New-Object -TypeName PsCustomObject -Property $properties
        }
        $document.close()
    }

    $application.quit()
    If($results){
        $results | Export-Csv $output -NoTypeInformation
        return $results
    }
}
