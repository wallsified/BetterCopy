Add-Type -AssemblyName PresentationCore,PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

$ButtonType = [System.Windows.MessageBoxButton]::YesNo
$MessageIcon = [System.Windows.MessageBoxImage]::Question
$MessageBody = "Este script esta disenado para crear una copia espejo de una carpeta a otra. `n`
Advertencia: Al ser una copia espejo, todo lo que no pertenezca a la carpeta fuente sera borrado de la carpeta
destino en el proceso. Es sugerido crear una nueva carpeta para el proceso.`n`
Haz click en 'Si' para iniciar."
$MessageTitle = "BetterCopy v 1.0"
$SourceMessage = "Selecciona la carpeta a copiar"
$DestinationMessage = "Ahora selecciona a donde se va a copiar la informacion"
$LogMessage = "El script genera un archivo de registro para cotejar resultados. Indica en donde se almacenara"
$EndMessage = "Copia Finalizada"

Function GetFolder($initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Selecciona una carpeta"
    $foldername.rootfolder = "Desktop"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

Function SourceFolder(){
return [System.Windows.MessageBox]::Show($SourceMessage,$MessageTitle, $ButtonType, 'Information')
}

Function DestinationFolder(){
return [System.Windows.MessageBox]::Show($DestinationMessage,$MessageTitle, $ButtonType, 'Information')
}

Function LogFolder(){
return [System.Windows.MessageBox]::Show($LogMessage,$MessageTitle, $ButtonType, 'Information')
}

Function EndScreen() {
return [System.Windows.MessageBox]::Show($EndMessage,$MessageTitle, $ButtonType, 'Information')
}

Function ExecuteCopy {
    $Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
    if ($Result -eq "Yes"){
        SourceFolder
        $oldHome = GetFolder
        DestinationFolder
        $newHome = GetFolder
        LogFolder
        $log = GetFolder
        robocopy $oldHome $newHome /e /w:5 /r:2 /MIR /DCOPY:DAT /MT /LOG+:$log\BetterCopy.txt /TEE
        EndScreen
    }
}

ExecuteCopy



