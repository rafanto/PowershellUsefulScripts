# Funzione per decomprimere i file ZIP in una cartella
function Expand-ZipFiles {
    param (
        [string]$folderPath
    )
    
    $zipFiles = Get-ChildItem -Path $folderPath -Filter "*.zip" -File
    
    foreach ($zipFile in $zipFiles) {
        $destinationPath = Join-Path -Path $folderPath -ChildPath ($zipFile.BaseName)
        Expand-Archive -Path $zipFile.FullName -DestinationPath $destinationPath -Force
    }
}

# Specifica il percorso della directory di partenza
$directoryPath = "H:\MAME"

# Ottieni l'elenco di tutte le cartelle presenti nella directory
$folders = Get-ChildItem -Path $directoryPath -Directory -Recurse

# Numero di cartelle da elaborare contemporaneamente
$batchSize = 5

# Dividi l'elenco delle cartelle in batch di dimensioni definite
$folderBatches = $folders | Group-Object -Property { $_.PSObject.Properties["PSChildName"].Value } | ForEach-Object { $_.Group } | ForEach-Object -Begin { $index = 0 } -Process {
    $index++
    $_ | Add-Member -NotePropertyMembers @{ BatchIndex = $index }
} | Group-Object -Property BatchIndex | ForEach-Object { $_.Group }

# Avvia i processi in parallelo per ciascun batch di cartelle
$completedJobs = @()
foreach ($batch in $folderBatches) {
    $jobs = @()
    
    foreach ($folder in $batch) {
        $job = Start-Job -ScriptBlock {
            param ($folderPath)
            Expand-ZipFiles -folderPath $folderPath
        } -ArgumentList $folder.FullName
        $jobs += $job
    }
    
    # Attendi il completamento di tutti i processi del batch
    $null = $jobs | Wait-Job

    # Memorizza i job completati
    $completedJobs += $jobs

    # Rimuovi i processi completati
    $jobs | Remove-Job
}

# Al termine dell'operazione, emetti un avviso o un messaggio
Write-Host "Operazione completata. Tutti i file ZIP sono stati decompressi."

# Per ottenere ulteriori informazioni sui job completati, puoi utilizzare $completedJobs
# ad esempio, per visualizzare il risultato di ogni job, puoi fare qualcosa come:
# $completedJobs | ForEach-Object { Receive-Job $_ }
