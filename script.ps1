# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

$ErrorActionPreference = "Stop"
Write-Host "=== Bloatware app removal script by Quinsaiz v1.10 ===" -ForegroundColor Cyan

function Check-ADB {
    if (Test-Path "adb.exe") { $script:ADB = ".\adb.exe"; Write-Host "Using local ADB binary from script directory." -ForegroundColor Green }
    elseif (Get-Command "adb" -ErrorAction SilentlyContinue) { $script:ADB = "adb"; Write-Host "Using system-wide ADB." -ForegroundColor Green }
    else { Write-Host "ADB not found. Install it or place adb.exe in the script folder." -ForegroundColor Red; exit 1 }
}

function Check-Device {
    $retries = 3
    while ($retries -gt 0) {
        $devices = & $script:ADB devices | Where-Object { $_ -match "device$" }
        if ($devices) {
            $script:DeviceID = ($devices -split "\s+")[0]
            Write-Host "Device connected successfully! Device ID: $script:DeviceID" -ForegroundColor Green
            return
        } else {
            Write-Host "Device is not connected or USB debugging is not configured." -ForegroundColor Yellow
            Write-Host "Check:`n1. Developer mode and USB debugging enabled.`n2. Device connected via USB.`n3. ADB access allowed on device." -ForegroundColor Yellow
            Write-Host "Press Enter to retry ($retries attempts left)..." -NoNewline
            Read-Host | Out-Null
            $retries--
        }
    }
    Write-Host "Failed to detect device after multiple attempts. Exiting." -ForegroundColor Red
	Start-Sleep -Milliseconds 800
    exit 1
}

function Get-PackageStatus {
    param ([string[]]$Packages)
    $all = & $script:ADB shell "pm list packages -u" | Where-Object { $_ -match "^package:" }
    $enabled = & $script:ADB shell "pm list packages" | Where-Object { $_ -match "^package:" }
    $disabled = & $script:ADB shell "pm list packages -d" | Where-Object { $_ -match "^package:" }

    $installed = @(); $disabledArr = @(); $uninstalled = @(); $notInstalled = @()
    foreach ($pkg in $Packages) {
        $pkgStr = "package:$pkg"
        if ($all -contains $pkgStr) {
            if ($disabled -contains $pkgStr) { $disabledArr += $pkg }
            elseif ($enabled -contains $pkgStr) { $installed += $pkg }
            else { $uninstalled += $pkg }
        } else { $notInstalled += $pkg }
    }

    $status = @()
    if ($installed) { $status += "Installed ($($installed -join ', '))" }
    if ($disabledArr) { $status += "Disabled ($($disabledArr -join ', '))" }
    if ($uninstalled) { $status += "Uninstalled ($($uninstalled -join ', '))" }
    if ($notInstalled) { $status += "Not installed ($($notInstalled -join ', '))" }
    if (-not $status) { "Unknown status" } else { $status -join ", " }
}

function Write-ColoredStatus {
    param([string]$StatusString)
    $parts = $StatusString -split ", "
    $first = $true
    foreach ($part in $parts) {
        if (-not $first) { Write-Host ", " -NoNewline -ForegroundColor White }
        $first = $false

        if ($part -match "\((.*)\)$") {
            $pkgList = $Matches[1]
            $state = $part -replace "\s*\(.*\)$", ""
        } else { $pkgList = ""; $state = $part }

        switch -Regex ($state) {
            "^Installed$"     { Write-Host "Installed" -NoNewline -ForegroundColor Green }
            "^Disabled$"      { Write-Host "Disabled" -NoNewline -ForegroundColor Yellow }
            "^Uninstalled$"   { Write-Host "Uninstalled" -NoNewline -ForegroundColor Red }
            "^Not installed$" { Write-Host "Not installed" -NoNewline -ForegroundColor Gray }
            default           { Write-Host $state -NoNewline -ForegroundColor White }
        }
        if ($pkgList) { Write-Host " ($pkgList)" -NoNewline -ForegroundColor White }
    }
    Write-Host ""
}

function Run-Action {
    param ([string]$Pkg, [string]$Cmd, [string]$Success, [string]$Already)
    $exists = & $script:ADB shell "pm list packages -u" | Select-String "^package:$Pkg$"
    if (-not $exists) { Write-Host "Skipped ${Pkg}: Not installed" -ForegroundColor Yellow; return }
	try {
		$out = & $script:ADB shell $Cmd 2>&1
		if ($out -match "(?i)success|enabled|disabled|installed" -or -not $out) {
			Write-Host "$Success ${Pkg}" -ForegroundColor Green
		} elseif ($out -match "(?i)already|warning") {
			Write-Host "$Already ${Pkg}: $out" -ForegroundColor Yellow
		} else {
			Write-Host "Command output for ${Pkg}: $out" -ForegroundColor DarkGray
		}
		Start-Sleep -Milliseconds 800
	}
	catch {
		Write-Host "Error while executing for ${Pkg}: $($_.Exception.Message)" -ForegroundColor Red
		Start-Sleep -Milliseconds 800
	}

}

function Uninstall-Pkg { param($p) Run-Action $p "pm uninstall --user 0 $p" "Successfully uninstalled" "Already uninstalled" }
function Disable-Pkg  { param($p) Run-Action $p "pm disable-user --user 0 $p" "Successfully disabled" "Already disabled" }
function Restore-Pkg  { param($p) Run-Action $p "pm install-existing --user 0 $p" "Successfully restored" "Already installed" }
function Enable-Pkg   { param($p) Run-Action $p "pm enable --user 0 $p" "Successfully enabled" "Already enabled" }

function Show-ActionMenu {
    param ([string]$Name, [string[]]$Pkgs)
    Clear-Host
    Write-Host "Action for $Name" -ForegroundColor Cyan
    $status = Get-PackageStatus $Pkgs
    Write-Host "Status: " -NoNewline -ForegroundColor White
    Write-ColoredStatus $status
    Write-Host "1) Uninstall`n2) Disable`n3) Restore`n4) Enable`n0) Return" -ForegroundColor White
    $a = Read-Host "Select an action"
    switch ($a) {
        "1" { $Pkgs | ForEach-Object { Uninstall-Pkg $_ } }
        "2" { $Pkgs | ForEach-Object { Disable-Pkg $_ } }
        "3" { $Pkgs | ForEach-Object { Restore-Pkg $_ } }
        "4" { $Pkgs | ForEach-Object { Enable-Pkg $_ } }
        "0" { return }
        default { 
			Write-Host "Invalid action selected." -ForegroundColor Red
			Start-Sleep -Milliseconds 800
		}
    }
    Write-Host "Press Enter to continue..." -NoNewline
    Read-Host | Out-Null
}

function Selective-Uninstall {
    param ([string[]]$Pkgs)
    Clear-Host
    Write-Host "=== Uninstall selectively ===" -ForegroundColor Cyan
    Write-Host "Enter program numbers separated by space (e.g., '1 5 6'). Range: 1-$($Pkgs.Count)" -ForegroundColor White
    $sel = Read-Host "Select programs"
    $sel -split "\s+" | ForEach-Object {
        $i = [int]$_ - 1
        if ($i -ge 0 -and $i -lt $Pkgs.Count) {
            ($Pkgs[$i] -split " ") | ForEach-Object { Uninstall-Pkg $_ }
        } else { Write-Host "Invalid number: $_" -ForegroundColor Red }
    }
    Write-Host "Press Enter to continue..." -NoNewline
    Read-Host | Out-Null
}

function Check-All-Status {
    param ([string[]]$Pkgs, [string[]]$Names)
    Clear-Host
    Write-Host "=== Check status of apps ===" -ForegroundColor Cyan
    for ($i = 0; $i -lt $Names.Count; $i++) {
        Write-Host "- $($Names[$i]): " -NoNewline -ForegroundColor White
        $status = Get-PackageStatus ($Pkgs[$i] -split " ")
        Write-ColoredStatus $status
    }
    Write-Host "-------------------------" -ForegroundColor White
    Write-Host "Press Enter to return..." -NoNewline
    Read-Host | Out-Null
}

function Menu-Loop {
    param ([string]$Title, [string[]]$Apps, [string[]]$Names)
    while ($true) {
        Clear-Host
        Write-Host "=== $Title ===" -ForegroundColor Cyan
        for ($i=0; $i -lt $Names.Count; $i++) {
            Write-Host "$($i+1)) $($Names[$i]) ($($Apps[$i]))" -ForegroundColor White
        }
        Write-Host "98) Selective uninstall" -ForegroundColor Gray
        Write-Host "99) Check all status" -ForegroundColor Gray
        Write-Host "0) Return to main menu" -ForegroundColor White
        $c = Read-Host "Select an app"
        switch ($c) {
            "0" { return }
            "98" { Selective-Uninstall $Apps; continue }
            "99" { Check-All-Status $Apps $Names; continue }
            default {
                $i = [int]$c - 1
                if ($i -ge 0 -and $i -lt $Names.Count) {
                    Show-ActionMenu $Names[$i] ($Apps[$i] -split " ")
                } else {
                    Write-Host "Invalid choice." -ForegroundColor Red
                    Start-Sleep -Milliseconds 800
                }
            }
        }
    }
}

function MIUI-Menu { Menu-Loop "MIUI/HyperOS system apps" @(
    "com.miui.cleaner", "com.miui.compass", "com.xiaomi.mipicks", "com.mi.globalbrowser",
    "com.xiaomi.smarthome", "com.miui.huanji", "com.miui.player", "com.miui.video com.miui.videoplayer",
    "com.mi.globalminusscreen com.mi.android.globalminusscreen", "com.mi.global.pocostore com.mi.global.pocobbs",
    "com.xiaomi.scanner", "com.miui.midrop", "com.android.providers.downloads.ui",
    "com.android.thememanager", "com.miui.android.fashiongallery", "com.xiaomi.glgm"
) @(
    "Cleaner", "Compass", "GetApps", "Mi Browser", "Mi Home", "Mi Mover", "Mi Music", "Mi Video",
    "MinusScreen Widget", "POCO Store and Community", "QR Scanner", "ShareMe", "Downloads",
    "Themes", "Wallpaper Carousel", "Xiaomi Games"
) }

function Utilities-Menu { Menu-Loop "System utility" @(
    "com.android.bookmarkprovider com.android.providers.partnerbookmarks", "com.bsp.catchlog",
    "com.android.bluetoothmidiservice", "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase",
    "com.google.android.onetimeinitializer com.google.android.partnersetup", "com.google.android.printservice.recommendation",
    "com.miui.msa.global", "com.miui.analytics", "com.miui.daemon", "com.android.mms.service",
    "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton",
    "com.android.theme.font.notoserifsource", "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle",
    "com.android.bips com.android.printspooler", "com.miui.hybrid com.miui.hybrid.accessory",
    "com.android.stk", "com.android.traceur", "com.google.android.marvin.talkback",
    "com.miui.touchassistant", "com.quicinc.voice.activation", "com.android.wallpaperbackup",
    "com.miui.personalassistant", "com.miui.bugreport com.miui.miservice", "com.miui.yellowpage",
    "com.xiaomi.payment com.mipay.wallet.in", "com.tencent.soter.soterserver", "com.xiaomi.mirecycle",
    "com.miui.vsimcore", "com.wapi.wapicertmanage", "com.google.android.apps.turbo",
    "com.milink.service com.xiaomi.mirror", "com.xiaomi.joyose", "com.qualcomm.atfwd",
    "com.qualcomm.qti.uceShimService"
) @(
    "Ad Bookmarks", "Battery Logs Catchlog", "Bluetooth MIDI", "Cloud Backup",
    "Google One Time Initialization", "Google Print Recommendations", "MIUI Ads",
    "MIUI Analytics", "MIUI Daemon", "MMS Service", "Navigation Gestures",
    "Noto Serif Font", "OK Google Detection", "Print Service", "Quick Apps",
    "SIM Card Menu", "System Tracing", "TalkBack", "Touch Assistant",
    "Voice Activation", "Wallpaper Backup", "App Vault Widget", "Bug Reports and Feedback",
    "Chinese Caller ID", "Chinese Mi Pay", "Chinese Payment Verification Service",
    "Chinese Promo Service", "Chinese Virtual Cards", "Chinese Wi-Fi Variant",
    "Device Health Services", "Interconnectivity and Services", "Joyose",
    "Qualcomm Miracast", "Qualcomm RCS"
) }

function Google-Menu { Menu-Loop "Google apps" @(
    "com.google.android.projection.gearhead", "com.android.chrome", "com.google.android.contacts",
    "com.google.android.dialer", "com.google.android.apps.wellbeing", "com.google.android.apps.docs",
    "com.google.android.apps.nbu.files", "com.google.android.gm", "com.google.android.apps.googleassistant",
    "com.google.android.apps.tachyon", "com.google.android.music", "com.google.android.apps.subscriptions.red",
    "com.google.android.googlequicksearchbox", "com.google.android.videos", "com.google.android.apps.healthdata",
    "com.google.android.apps.maps", "com.google.android.apps.messaging", "com.google.android.apps.safetyhub",
    "com.google.android.youtube", "com.google.android.apps.youtube.music"
) @(
    "Android Auto", "Chrome", "Contacts", "Dialer", "Digital Wellbeing", "Drive",
    "Files", "Gmail", "Google Assistant", "Google Duo", "Google Music", "Google One",
    "Google Search", "Google Videos", "Health Connect", "Maps", "Messages",
    "Safety Hub", "YouTube", "YouTube Music"
) }

function ThirdParty-Menu { Menu-Loop "Third-party apps" @(
    "com.amazon.mShop.android.shopping com.amazon.appmanager", "com.block.juggle",
    "com.booking", "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana",
    "com.netflix.mediaclient com.netflix.partner.activation", "com.microsoft.skydrive",
    "com.opera.browser com.opera.preinstall", "com.spotify.music", "com.einnovation.temu",
    "cn.wps.moffice_eng"
) @(
    "Amazon", "Block Juggle", "Booking", "Facebook", "Netflix", "OneDrive",
    "Opera", "Spotify", "Temu", "WPS Office"
) }

function Manual-PackageAction {
    Clear-Host
    Write-Host "=== Manual Package Management ===" -ForegroundColor Cyan
    Write-Host "Enter package names separated by space (e.g., 'com.example.app com.test.app'):" -ForegroundColor White
    $input = Read-Host "Packages"
    $packages = $input -split "\s+" | Where-Object { $_ }
    if (-not $packages) { Write-Host "No packages entered." -ForegroundColor Red; Write-Host "Press Enter to return..." -NoNewline; Read-Host | Out-Null; return }
    $status = Get-PackageStatus -Packages $packages
    Write-Host "Status: " -NoNewline -ForegroundColor White
    Write-ColoredStatus $status
    Write-Host "1) Uninstall`n2) Disable`n3) Restore`n4) Enable`n0) Return" -ForegroundColor White
    $action = Read-Host "Select an action"
    switch ($action) {
        "1" { foreach ($pkg in $packages) { Uninstall-Pkg $pkg } }
        "2" { foreach ($pkg in $packages) { Disable-Pkg $pkg } }
        "3" { foreach ($pkg in $packages) { Restore-Pkg $pkg } }
        "4" { foreach ($pkg in $packages) { Enable-Pkg $pkg } }
        "0" { return }
        default { 
			Write-Host "Invalid action selected." -ForegroundColor Red 
			Start-Sleep -Milliseconds 800
		}
    }
    Write-Host "Press Enter to continue..." -NoNewline
    Read-Host | Out-Null
}

function Main-Menu {
    while ($true) {
        Clear-Host
        Write-Host "=== Bloatware app removal script by Quinsaiz v1.10 ===" -ForegroundColor Cyan
        Write-Host "1) MIUI/HyperOS system apps`n2) System utility`n3) Google apps`n4) Third-party apps`n99) Manual package management`n0) Exit" -ForegroundColor White
        $choice = Read-Host "Select an option"
        if (-not $choice) { continue }
        switch ($choice) {
            "1" { MIUI-Menu }
            "2" { Utilities-Menu }
            "3" { Google-Menu }
            "4" { ThirdParty-Menu }
            "99" { Manual-PackageAction }
            "0" { 
				& $script:ADB kill-server; Write-Host "Good luck!" -ForegroundColor Green;
				Start-Sleep -Milliseconds 800				
				exit 0 
			}
            default { Write-Host "Invalid option." -ForegroundColor Red; Start-Sleep -Milliseconds 800 }
        }
    }
}

Check-ADB
Check-Device
Main-Menu