<#
.SYNOPSIS
Este script está diseñado para ocupar "robocopy" de una forma más directa.

.DESCRIPTION
"Robocopy" copia archivos de una manera más eficiente, ya que ocupa más poder de procesamiento.
Al crear unos botones seleccionables, su uso se puede automatizar parcialmente.

.NOTES
Este script viene sin garantía. Es simplemente un experimento de un par de horas. 
#>

#Types de funcionamiento
Add-Type -AssemblyName PresentationCore, PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

#Tipo de Botón Predeterminado
$ButtonType = [System.Windows.MessageBoxButton]::YesNo

#Ícono predeterminado para las ventanas
$MessageIcon = [System.Windows.MessageBoxImage]::Question

#Cuerpo del Mensaje de Incio
$MessageBody = "Este script esta disenado para crear una copia espejo de una carpeta a otra. `n`
Advertencia: Al ser una copia espejo, todo lo que no pertenezca a la carpeta fuente sera borrado de la carpeta
destino en el proceso. Es sugerido crear una nueva carpeta para el proceso.`n`
Haz click en 'Si' para iniciar."

#Titulo de las Ventanas
$MessageTitle = "BetterCopy v 1.0"

<#
.SYNOPSIS
Función principal del proceso.
#>
Function ExecuteCopy {
    $Result = [System.Windows.MessageBox]::Show($MessageBody, $MessageTitle, $ButtonType, $MessageIcon)
    if ($Result -eq "Yes") {
        $source = SourceFolder
        $endpoint = DestinationFolder
        $log = LogFolder
        <#
        .LINK
        Para más información consulte 
        https://learn.microsoft.com/es-es/windows-server/administration/windows-commands/robocopy
        #>
        robocopy $source $endpoint /e /w:5 /r:2 /MIR /DCOPY:DAT /MT /LOG+:$log\BetterCopy.txt /TEE
        EndScreen
    }
}

<#
.DESCRIPTION
Función para obtener la carpeta fuente del proceso.
#>
Function SourceFolder() {
    $SourceMessage = "Selecciona la carpeta a copiar"
    $source
    [System.Windows.MessageBox]::Show($SourceMessage, $MessageTitle, $ButtonType, 'Information')
    return $source = GetFolder
}

<#
.DESCRIPTION
Función para obtener la carpeta destino del proceso.
#>
Function DestinationFolder() {
    $DestinationMessage = "Ahora selecciona a donde se va a copiar la informacion"
    $destination
    [System.Windows.MessageBox]::Show($DestinationMessage, $MessageTitle, $ButtonType, 'Information')
    return $destination = GetFolder
}

<#
.DESCRIPTION
Función para obtener la carpeta donde se almacenará el registro del proceso.
#>
Function LogFolder() {
    $LogMessage = "El script genera un archivo de registro para cotejar resultados. Indica en donde se almacenara"
    $log
    [System.Windows.MessageBox]::Show($LogMessage, $MessageTitle, $ButtonType, 'Information')
    return $log = GetFolder
}

<#
.DESCRIPTION
Pantalla de fin de ejecución
#>
Function EndScreen() {
    $EndMessage = "Copia Finalizada"
    return [System.Windows.MessageBox]::Show($EndMessage, $MessageTitle, "OK", 'Information')
}

<#
.SYNOPSIS
Obtener una carpeta del sistema.

.DESCRIPTION
La función le pide al usuario seleccionar una carpeta del sistema para poder ocuparla posteriormente. 
#>
Function GetFolder($initialDirectory = "") {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Selecciona una carpeta"
    $foldername.rootfolder = "Desktop"
    $foldername.SelectedPath = $initialDirectory

    if ($foldername.ShowDialog() -eq "OK") {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

<#
Inicio de la Ejecución
#>
ExecuteCopy