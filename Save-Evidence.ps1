# =====================================================================
#  Save-Evidence.ps1   (v3 - Scan-QAtesting folder + text index)
#
#  Renames your newest screenshots into the QA naming convention and
#  files them into THIS folder, then appends one line per file to
#  EVIDENCE-INDEX.csv in the same place.
#
#  Send Claude the CSV, not the pictures. A whole day of testing costs
#  a few hundred tokens instead of tens of thousands.
#
#  HOW TO USE
#   1. Take screenshots. PREFER Windows + Shift + S and drag a SMALL box
#      around just the error or the changed field - a cropped shot costs
#      about 8x less than a full screen.
#      (Snipping Tool > ... > Settings > "Automatically save original
#       screenshots" must be ON so they land in Pictures\Screenshots.)
#   2. Right-click this file -> "Run with PowerShell"
#   3. Answer the questions. Done.
# =====================================================================

$Source = "$env:USERPROFILE\Pictures\Screenshots"

# Evidence is stored in the SAME folder this script sits in.
$Dest  = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $Dest) { $Dest = "$env:USERPROFILE\Desktop\Scan-QAtesting-17-08-2026" }
$Index = Join-Path $Dest "EVIDENCE-INDEX.csv"

if (-not (Test-Path $Dest)) { New-Item -ItemType Directory -Path $Dest -Force | Out-Null }
if (-not (Test-Path $Index)) {
    "Date,TestID,Category,Description,Result,Filename,Note" |
        Out-File -FilePath $Index -Encoding UTF8
    Write-Host "Created EVIDENCE-INDEX.csv" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "=== QA Evidence Saver ===" -ForegroundColor Cyan
Write-Host "Saving into: $Dest" -ForegroundColor DarkGray
Write-Host ""

$recent = Get-ChildItem $Source -Filter *.png |
          Sort-Object LastWriteTime -Descending | Select-Object -First 12
if (-not $recent) { Write-Host "No screenshots found in $Source" -ForegroundColor Red; Pause; exit }

Write-Host "Your most recent screenshots (newest first):" -ForegroundColor Yellow
$i = 1
foreach ($f in $recent) {
    $dim = "?"; $approx = "?"
    try {
        Add-Type -AssemblyName System.Drawing -ErrorAction SilentlyContinue
        $img = [System.Drawing.Image]::FromFile($f.FullName)
        $dim = "{0}x{1}" -f $img.Width, $img.Height
        $approx = [math]::Round(($img.Width * $img.Height) / 750)
        $img.Dispose()
    } catch { }
    "{0,2}. {1}  [{2}]  {3}  ~{4} tokens" -f $i, $f.Name, $f.LastWriteTime.ToString("HH:mm:ss"), $dim, $approx | Write-Host
    $i++
}
Write-Host ""
Write-Host "TIP: anything over ~1000 tokens is probably a full screen - crop it next time." -ForegroundColor DarkGray
Write-Host ""

$count = Read-Host "How many of the newest ones belong to this test? (e.g. 3)"
if (-not ($count -as [int]) -or [int]$count -lt 1) { Write-Host "Not a number. Stopping." -ForegroundColor Red; Pause; exit }

Write-Host ""
Write-Host "Test ID - use the Azure ID or defect ID being retested" -ForegroundColor Yellow
Write-Host "  e.g. 39890, 40017, TICK-027, APPEALS-SQL, SCAN-001" -ForegroundColor DarkGray
$testId = Read-Host "Test ID"
$testId = $testId -replace '\s+','-' -replace '[^A-Za-z0-9\-\.]',''

Write-Host ""
Write-Host "Category:  FIXED | REPRODUCES | CHANGED | BLOCKED | PASS | FAIL | OBSERVATION | SETUP" -ForegroundColor Yellow
$category = (Read-Host "Category").ToUpper()
$valid = @("FIXED","REPRODUCES","CHANGED","BLOCKED","PASS","FAIL","OBSERVATION","SETUP")
if ($valid -notcontains $category) { Write-Host "Not a valid category. Stopping." -ForegroundColor Red; Pause; exit }

$desc = Read-Host "Short description (e.g. No-popup-real-receipt)"
$descClean = $desc -replace '\s+','-' -replace '[^A-Za-z0-9\-\.]',''

Write-Host ""
Write-Host "One line for Claude - what actually happened. This is what he reads" -ForegroundColor Yellow
Write-Host "instead of opening the picture. Include any AMOUNTS you saw." -ForegroundColor Yellow
$note = Read-Host "Note"
$note = $note -replace '"','' -replace ',',';'

$batch = $recent | Select-Object -First ([int]$count) | Sort-Object LastWriteTime

Write-Host ""
$n = 1
$saved = @()
foreach ($f in $batch) {
    if ([int]$count -eq 1) { $name = "{0}_{1}_{2}.png" -f $testId, $category, $descClean }
    else                   { $name = "{0}_{1}_{2}-{3}.png" -f $testId, $category, $descClean, $n }
    $target = Join-Path $Dest $name
    $k = 1
    while (Test-Path $target) {
        $target = Join-Path $Dest ("{0}_v{1}.png" -f $name.Replace(".png",""), $k); $k++
    }
    Copy-Item $f.FullName $target
    $leaf = Split-Path $target -Leaf
    $saved += $leaf
    Write-Host ("  saved -> " + $leaf) -ForegroundColor Green
    $n++
}

$stamp = Get-Date -Format "yyyy-MM-dd"
foreach ($leaf in $saved) {
    '{0},{1},{2},{3},{4},{5},"{6}"' -f $stamp, $testId, $category, $desc, $category, $leaf, $note |
        Out-File -FilePath $Index -Encoding UTF8 -Append
}

Write-Host ""
Write-Host "Index updated: EVIDENCE-INDEX.csv" -ForegroundColor Cyan
Write-Host ""
Write-Host "WHEN YOU FINISH TESTING:" -ForegroundColor Yellow
Write-Host "  Send Claude EVIDENCE-INDEX.csv only - not the pictures." -ForegroundColor Yellow
Write-Host "  Flag which rows you want him to actually look at." -ForegroundColor Yellow
Write-Host "  $Index" -ForegroundColor DarkGray
Write-Host ""
Pause
