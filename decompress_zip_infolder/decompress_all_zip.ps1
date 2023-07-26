# Specifica il percorso della directory di partenza
$directoryPath = "H:\NEOGEO"

# Ottieni l'elenco di tutte le cartelle presenti nella directory
$folders = Get-ChildItem -Path $directoryPath -Directory -Recurse

foreach ($folder in $folders) {
    # Ottieni l'elenco dei file ZIP nella cartella corrente
    $zipFiles = Get-ChildItem -Path $folder.FullName -Filter "*.zip" -File

    foreach ($zipFile in $zipFiles) {
        # Crea il percorso completo in cui decomprimere il file ZIP
        $destinationPath = Join-Path -Path $folder.FullName -ChildPath ($zipFile.BaseName)

        # Decomprimi il file ZIP nella cartella corrente
        Expand-Archive -Path $zipFile.FullName -DestinationPath $destinationPath -Force
    }
}
