# Import the Umbrella exported report and split out the domains column in to a seperate file
# called DomainUnfiltered.csv
# 
$content = Import-Csv C:\temp\umbrella.csv -Delimiter "`t"
foreach ($line in $content) {
    $line.Domain |Out-File 'C:\temp\DomainUnfiltered.csv' -Append
    }
#
# Import the DomainUnfilted.csv file and export unique domains to DomainUnique.csv
$input = 'C:\temp\DomainUnfiltered.csv'
$inputCsv = Import-Csv $input | Select-Object * -Unique
$inputCsv | Export-Csv 'C:\temp\DomainUnique.csv' -NoTypeInformation
#
# Import DomainUnique.csv and check against the current list of domains in the Umbrella Global destination lists
# replaces any destinations found to match with 'In Global' 
$content = Import-Csv C:\temp\DomainUnique.csv
$KnownDomains = @('*.microsoft.com','*.outlook.com','*.onenote.com','*.icloud.com','*.windows.com')
ForEach ($line in $content) {
    $count = 0
    Do {
        if ($line -like $KnownDomains[$count]) {$line = 'deleted'}
        }
    Until ($count -eq $KnownDomains.length)
   } 
<# Import DomainUnique.csv and remove any matches to known good domains.
$content = Import-Csv C:\temp\DomainUnique.csv
ForEach ($Line in $content) {
    $linePrint -eq 1
    if ($line -like '*.windows.com') {$linePrint = 0}
    if ($line -like '*.microsoft.com') {$linePrint = 0}
    if ($line -like '*.outlook.com') {$linePrint = 0}
    if ($line -like '*.onenote.com') {$linePrint = 0}
    if ($linePrint -eq 1){
        Out-File c:\temp\finalRaw.csv -InputObject $line -NoClobber -Append
    }
}
#>
# Get the Raw file and filer out the rubish
$input = 'C:\temp\DomainUnique.csv'
$inputCsv = Import-Csv $input | Select-Object * -Unique
$inputCsv | Export-Csv 'C:\temp\FinalUnique.csv' -NoTypeInformation
#