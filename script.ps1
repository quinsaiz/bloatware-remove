# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
$ErrorActionPreference = "Continue"
Write-Host "=== Bloatware app removal script by Quinsaiz v1.02 ===" -ForegroundColor Cyan

function Check-ADB {
    if (Test-Path "adb.exe") {
        $script:ADB = ".\adb.exe"
        Write-Host "Using local ADB binary from script directory." -ForegroundColor Green
    } elseif (Get-Command "adb" -ErrorAction SilentlyContinue) {
        $script:ADB = "adb"
        Write-Host "Using system-wide ADB." -ForegroundColor Green
    } else {
        Write-Host "ADB not found. Install it or place adb.exe in the script folder." -ForegroundColor Red
        exit 1
    }
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
            Read-Host
            $retries--
        }
    }
    Write-Host "Failed to detect device after multiple attempts. Exiting." -ForegroundColor Red
    exit 1
}

function Get-PackageStatus {
    param ([string[]]$Packages)
    $installed = @()
    $disabled = @()
    $uninstalled = @()
    $notInstalled = @()

    foreach ($pkg in $Packages) {
        $exists = & $script:ADB shell pm list packages -u | Where-Object { $_ -eq "package:$pkg" }
        if ($exists) {
            $isDisabled = & $script:ADB shell pm list packages -d | Where-Object { $_ -eq "package:$pkg" }
            $isActive = & $script:ADB shell pm list packages | Where-Object { $_ -eq "package:$pkg" }
            if ($isDisabled) {
                $disabled += $pkg
            } elseif ($isActive) {
                $installed += $pkg
            } else {
                $uninstalled += $pkg
            }
        } else {
            $notInstalled += $pkg
        }
    }

    $status = @()
    if ($installed) { $status += "Installed ($($installed -join ', '))" }
    if ($disabled) { $status += "Disabled ($($disabled -join ', '))" }
    if ($uninstalled) { $status += "Uninstalled ($($uninstalled -join ', '))" }
    if ($notInstalled) { $status += "Not installed ($($notInstalled -join ', '))" }
    if (-not $status) { $status = "Unknown status" }
    return $status -join ", "
}

function Check-All-Status {
    param ([string]$ReturnMenu, [string[]]$Packages, [string[]]$Names)
    Clear-Host
    Write-Host "=== Check status of apps ===" -ForegroundColor Cyan
    for ($i = 0; $i -lt $Names.Length; $i++) {
        $status = Get-PackageStatus -Packages ($Packages[$i] -split " ")
        Write-Host "$($i + 1)) $($Names[$i]) | $status"
    }
    Write-Host "-------------------------" -ForegroundColor White
    Write-Host "Press Enter to return..." -NoNewline
    Read-Host
    & $ReturnMenu
}

function Uninstall-Package {
    param ([string]$Package)
    $exists = & $script:ADB shell pm list packages -u | Where-Object { $_ -eq "package:$Package" }
    if ($exists) {
        $isActive = & $script:ADB shell pm list packages | Where-Object { $_ -eq "package:$Package" }
        if ($isActive) {
            try {
                $output = & $script:ADB shell pm uninstall --user 0 $Package 2>&1
                if ($output -eq "Success") {
                    Write-Host "Successfully uninstalled: $Package" -ForegroundColor Green
                } else {
                    Write-Host "Failed to uninstall ${Package}: $output" -ForegroundColor Red
                }
            } catch {
                Write-Host "Error uninstalling ${Package}: $($_.Exception.Message)" -ForegroundColor Red
            }
        } else {
            Write-Host "Package ${Package} is already uninstalled." -ForegroundColor Yellow
        }
    } else {
        Write-Host "Skipped ${Package}: Not installed" -ForegroundColor Yellow
    }
}

function Disable-Package {
    param ([string]$Package)
    $exists = & $script:ADB shell pm list packages -u | Where-Object { $_ -eq "package:$Package" }
    if ($exists) {
        $isDisabled = & $script:ADB shell pm list packages -d | Where-Object { $_ -eq "package:$Package" }
        if ($isDisabled) {
            Write-Host "Package ${Package} is already disabled." -ForegroundColor Yellow
        } else {
            try {
                $output = & $script:ADB shell pm disable-user --user 0 $Package 2>&1
                if ($output -match "disabled-user") {
                    Write-Host "Successfully disabled: $Package" -ForegroundColor Green
                } else {
                    Write-Host "Failed to disable ${Package}: $output" -ForegroundColor Red
                }
            } catch {
                Write-Host "Error disabling ${Package}: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Package ${Package} was never installed on this device." -ForegroundColor Yellow
    }
}

function Restore-Package {
    param ([string]$Package)
    $exists = & $script:ADB shell pm list packages -u | Where-Object { $_ -eq "package:$Package" }
    if ($exists) {
        $isActive = & $script:ADB shell pm list packages | Where-Object { $_ -eq "package:$Package" }
        if ($isActive) {
            Write-Host "Package ${Package} is already installed and enabled." -ForegroundColor Yellow
        } else {
            $output = & $script:ADB shell pm install-existing --user 0 $Package 2>&1
            if ($output -match "installed" -or $output -eq "") {
                Write-Host "Successfully restored: $Package" -ForegroundColor Green
            } else {
                Write-Host "Failed to restore ${Package}: $output" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Package ${Package} was never installed on this device and cannot be restored." -ForegroundColor Yellow
    }
}

function Enable-Package {
    param ([string]$Package)
    $exists = & $script:ADB shell pm list packages -u | Where-Object { $_ -eq "package:$Package" }
    if ($exists) {
        $isActive = & $script:ADB shell pm list packages | Where-Object { $_ -eq "package:$Package" }
        if ($isActive) {
            $isDisabled = & $script:ADB shell pm list packages -d | Where-Object { $_ -eq "package:$Package" }
            if (-not $isDisabled) {
                Write-Host "Package ${Package} is already enabled." -ForegroundColor Yellow
            } else {
                $output = & $script:ADB shell pm enable --user 0 $Package 2>&1
                if ($output -match "enabled") {
                    Write-Host "Successfully enabled: $Package" -ForegroundColor Green
                } else {
                    Write-Host "Failed to enable ${Package}: $output" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "Package ${Package} is uninstalled, cannot enable." -ForegroundColor Yellow
        }
    } else {
        Write-Host "Package ${Package} was never installed on this device." -ForegroundColor Yellow
    }
}

function Show-ActionMenu {
    param ([string]$Name, [string[]]$Packages, [string]$ReturnMenu)
    Clear-Host
    Write-Host "Action for $Name" -ForegroundColor Cyan
    $status = Get-PackageStatus -Packages $Packages
    Write-Host "Status: $status" -ForegroundColor Yellow
    Write-Host "1) Uninstall`n2) Disable`n3) Restore`n4) Enable`n0) Return" -ForegroundColor White
    $action = Read-Host "Select an action"
    
	if ([string]::IsNullOrEmpty($action)) { & $ReturnMenu }
	
    switch ($action) {
        "1" { foreach ($pkg in $Packages) { Uninstall-Package -Package $pkg } }
        "2" { foreach ($pkg in $Packages) { Disable-Package -Package $pkg } }
        "3" { foreach ($pkg in $Packages) { Restore-Package -Package $pkg } }
        "4" { foreach ($pkg in $Packages) { Enable-Package -Package $pkg } }
        "0" { & $ReturnMenu }
        default { Write-Host "Invalid action selected." -ForegroundColor Red }
    }
    Write-Host "Press Enter to continue..." -NoNewline
    Read-Host
    & $ReturnMenu
}

function Selective-Uninstall {
    param ([string]$ReturnMenu, [string[]]$Packages)
    Clear-Host
    Write-Host "=== Uninstall selectively ===" -ForegroundColor Cyan
    Write-Host "Enter program numbers separated by space (e.g., '1 5 6'). Range: 1-$($Packages.Length)" -ForegroundColor White
    $selection = Read-Host "Select programs"
    
    foreach ($num in $selection -split "\s+") {
        $index = [int]$num - 1
        if ($index -ge 0 -and $index -lt $Packages.Length) {
            foreach ($pkg in ($Packages[$index] -split " ")) {
                Uninstall-Package -Package $pkg
            }
        } else {
            Write-Host "Invalid number: $num" -ForegroundColor Red
        }
    }
    Write-Host "Press Enter to continue..." -NoNewline
    Read-Host
    & $ReturnMenu
}

function MIUI-Menu {
    $apps = @(
        "com.miui.cleaner", "com.miui.compass", "com.xiaomi.mipicks", "com.mi.globalbrowser",
        "com.xiaomi.smarthome", "com.miui.huanji", "com.miui.player", "com.miui.video com.miui.videoplayer",
        "com.mi.globalminusscreen com.mi.android.globalminusscreen", "com.mi.global.pocostore com.mi.global.pocobbs",
        "com.xiaomi.scanner", "com.xiaomi.midrop", "com.android.providers.downloads.ui",
        "com.android.thememanager", "com.miui.android.fashiongallery", "com.xiaomi.glgm"
    )
    $names = @(
        "Cleaner", "Compass", "GetApps", "Mi Browser", "Mi Home", "Mi Mover", "Mi Music", "Mi Video",
        "MinusScreen Widget", "POCO Store and Community", "QR Scanner", "ShareMe", "Downloads",
        "Themes", "Wallpaper Carousel", "Xiaomi Games"
    )
    
    Clear-Host
    Write-Host "=== MIUI/HyperOS system apps ===" -ForegroundColor Cyan
    for ($i = 0; $i -lt $names.Length; $i++) {
        Write-Host "$($i + 1)) $($names[$i]) ($($apps[$i]))"
    }
    Write-Host "98) Selective uninstall`n99) Check all status`n0) Return to main menu" -ForegroundColor White
    $choice = Read-Host "Select an app"
    
	if ([string]::IsNullOrEmpty($choice)) { Main-Menu }
	
    if ($choice -eq "0") { Main-Menu }
    elseif ($choice -eq "98") { Selective-Uninstall -ReturnMenu "MIUI-Menu" -Packages $apps }
    elseif ($choice -eq "99") { Check-All-Status -ReturnMenu "MIUI-Menu" -Packages $apps -Names $names }
    elseif ([int]$choice -ge 1 -and [int]$choice -le $names.Length) {
        $index = [int]$choice - 1
        Show-ActionMenu -Name $names[$index] -Packages ($apps[$index] -split " ") -ReturnMenu "MIUI-Menu"
    } else {
        Write-Host "Invalid choice." -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
    MIUI-Menu
}

function Utilities-Menu {
    $apps = @(
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
    )
    $names = @(
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
    )
    
    Clear-Host
    Write-Host "=== System utility ===" -ForegroundColor Cyan
    for ($i = 0; $i -lt $names.Length; $i++) {
        Write-Host "$($i + 1)) $($names[$i]) ($($apps[$i]))"
    }
    Write-Host "98) Selective uninstall`n99) Check all status`n0) Return to main menu" -ForegroundColor White
    $choice = Read-Host "Select an app"
    
	if ([string]::IsNullOrEmpty($choice)) { Main-Menu }
	
    if ($choice -eq "0") { Main-Menu }
    elseif ($choice -eq "98") { Selective-Uninstall -ReturnMenu "Utilities-Menu" -Packages $apps }
    elseif ($choice -eq "99") { Check-All-Status -ReturnMenu "Utilities-Menu" -Packages $apps -Names $names }
    elseif ([int]$choice -ge 1 -and [int]$choice -le $names.Length) {
        $index = [int]$choice - 1
        Show-ActionMenu -Name $names[$index] -Packages ($apps[$index] -split " ") -ReturnMenu "Utilities-Menu"
    } else {
        Write-Host "Invalid choice." -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
    Utilities-Menu
}

function Google-Menu {
    $apps = @(
        "com.google.android.projection.gearhead", "com.android.chrome", "com.google.android.contacts",
        "com.google.android.dialer", "com.google.android.apps.wellbeing", "com.google.android.apps.docs",
        "com.google.android.apps.nbu.files", "com.google.android.gm", "com.google.android.apps.googleassistant",
        "com.google.android.apps.tachyon", "com.google.android.music", "com.google.android.apps.subscriptions.red",
        "com.google.android.googlequicksearchbox", "com.google.android.videos", "com.google.android.apps.healthdata",
        "com.google.android.apps.maps", "com.google.android.apps.messaging", "com.google.android.apps.safetyhub",
        "com.google.android.youtube", "com.google.android.apps.youtube.music"
    )
    $names = @(
        "Android Auto", "Chrome", "Contacts", "Dialer", "Digital Wellbeing", "Drive",
        "Files", "Gmail", "Google Assistant", "Google Duo", "Google Music", "Google One",
        "Google Search", "Google Videos", "Health Connect", "Maps", "Messages",
        "Safety Hub", "YouTube", "YouTube Music"
    )
    
    Clear-Host
    Write-Host "=== Google apps ===" -ForegroundColor Cyan
    for ($i = 0; $i -lt $names.Length; $i++) {
        Write-Host "$($i + 1)) $($names[$i]) ($($apps[$i]))"
    }
    Write-Host "98) Selective uninstall`n99) Check all status`n0) Return to main menu" -ForegroundColor White
    $choice = Read-Host "Select an app"
    
	if ([string]::IsNullOrEmpty($choice)) { Main-Menu }
	
    if ($choice -eq "0") { Main-Menu }
    elseif ($choice -eq "98") { Selective-Uninstall -ReturnMenu "Google-Menu" -Packages $apps }
    elseif ($choice -eq "99") { Check-All-Status -ReturnMenu "Google-Menu" -Packages $apps -Names $names }
    elseif ([int]$choice -ge 1 -and [int]$choice -le $names.Length) {
        $index = [int]$choice - 1
        Show-ActionMenu -Name $names[$index] -Packages ($apps[$index] -split " ") -ReturnMenu "Google-Menu"
    } else {
        Write-Host "Invalid choice." -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
    Google-Menu
}

function ThirdParty-Menu {
    $apps = @(
        "com.amazon.mShop.android.shopping com.amazon.appmanager", "com.block.juggle",
        "com.booking", "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana",
        "com.netflix.mediaclient com.netflix.partner.activation", "com.microsoft.skydrive",
        "com.opera.browser com.opera.preinstall", "com.spotify.music", "com.einnovation.temu",
        "cn.wps.moffice_eng"
    )
    $names = @(
        "Amazon", "Block Juggle", "Booking", "Facebook", "Netflix", "OneDrive",
        "Opera", "Spotify", "Temu", "WPS Office"
    )
    
    Clear-Host
    Write-Host "=== Third-party apps ===" -ForegroundColor Cyan
    for ($i = 0; $i -lt $names.Length; $i++) {
        Write-Host "$($i + 1)) $($names[$i]) ($($apps[$i]))"
    }
    Write-Host "98) Selective uninstall`n99) Check all status`n0) Return to main menu" -ForegroundColor White
    $choice = Read-Host "Select an app"
    
	if ([string]::IsNullOrEmpty($choice)) { Main-Menu }
	
    if ($choice -eq "0") { Main-Menu }
    elseif ($choice -eq "98") { Selective-Uninstall -ReturnMenu "ThirdParty-Menu" -Packages $apps }
    elseif ($choice -eq "99") { Check-All-Status -ReturnMenu "ThirdParty-Menu" -Packages $apps -Names $names }
    elseif ([int]$choice -ge 1 -and [int]$choice -le $names.Length) {
        $index = [int]$choice - 1
        Show-ActionMenu -Name $names[$index] -Packages ($apps[$index] -split " ") -ReturnMenu "ThirdParty-Menu"
    } else {
        Write-Host "Invalid choice." -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
    ThirdParty-Menu
}

function Restore-DialerMessages {
    Clear-Host
    Write-Host "=== Restoring Xiaomi Dialer and Messages ===" -ForegroundColor Cyan
    
    Write-Host "Checking Xiaomi Dialer (com.android.contacts)..." -ForegroundColor White
    $output = & $script:ADB shell pm install-existing --user 0 com.android.contacts 2>&1
    if ($output -match "installed" -or $output -eq "") {
        Write-Host "Xiaomi Dialer restored successfully!" -ForegroundColor Green
    } else {
        Write-Host "Failed to restore Xiaomi Dialer: $output" -ForegroundColor Red
    }
    
    Write-Host "Checking Xiaomi Messages (com.android.mms)..." -ForegroundColor White
    $output = & $script:ADB shell pm install-existing --user 0 com.android.mms 2>&1
    if ($output -match "installed" -or $output -eq "") {
        Write-Host "Xiaomi Messages restored successfully!" -ForegroundColor Green
    } else {
        Write-Host "Failed to restore Xiaomi Messages: $output" -ForegroundColor Red
    }
    
    Write-Host "Press Enter to return..." -NoNewline
    Read-Host
    Main-Menu
}

function Manual-PackageAction {
    Clear-Host
    Write-Host "=== Manual Package Management ===" -ForegroundColor Cyan
    Write-Host "Enter package names separated by space (e.g., 'com.example.app com.test.app'):" -ForegroundColor White
    $input = Read-Host "Packages"
    $packages = $input -split "\s+"
    
    if (-not $packages) {
        Write-Host "No packages entered." -ForegroundColor Red
        Write-Host "Press Enter to return..." -NoNewline
        Read-Host
        Main-Menu
    }
    
    $status = Get-PackageStatus -Packages $packages
    Write-Host "Status: $status" -ForegroundColor Yellow
    Write-Host "1) Uninstall`n2) Disable`n3) Restore`n4) Enable`n0) Return" -ForegroundColor White
    $action = Read-Host "Select an action"
	if ([string]::IsNullOrEmpty($action)) { Main-Menu }
    
    switch ($action) {
        "1" { 
            foreach ($pkg in $packages) { 
                $exists = & $script:ADB shell pm list packages -u | Where-Object { $_ -eq "package:$pkg" }
                if ($exists) {
                    $isActive = & $script:ADB shell pm list packages | Where-Object { $_ -eq "package:$pkg" }
                    if ($isActive) {
                        Uninstall-Package -Package $pkg
                    } else {
                        Write-Host "Package ${pkg} is already uninstalled." -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "Skipped ${pkg}: Not installed" -ForegroundColor Yellow
                }
            }
        }
        "2" { 
            foreach ($pkg in $packages) { 
                $exists = & $script:ADB shell pm list packages -u | Where-Object { $_ -eq "package:$pkg" }
                if ($exists) {
                    Disable-Package -Package $pkg
                } else {
                    Write-Host "Skipped ${pkg}: Not installed" -ForegroundColor Yellow
                }
            }
        }
        "3" { 
            foreach ($pkg in $packages) { 
                $exists = & $script:ADB shell pm list packages -u | Where-Object { $_ -eq "package:$pkg" }
                if ($exists) {
                    Restore-Package -Package $pkg
                } else {
                    Write-Host "Skipped ${pkg}: Not installed, cannot restore" -ForegroundColor Yellow
                }
            }
        }
        "4" { 
            foreach ($pkg in $packages) { 
                $exists = & $script:ADB shell pm list packages -u | Where-Object { $_ -eq "package:$pkg" }
                if ($exists) {
                    Enable-Package -Package $pkg
                } else {
                    Write-Host "Skipped ${pkg}: Not installed" -ForegroundColor Yellow
                }
            }
        }
        "0" { Main-Menu }
        default { Write-Host "Invalid action selected." -ForegroundColor Red }
    }
    Write-Host "Press Enter to continue..." -NoNewline
    Read-Host
    Main-Menu
}

function Main-Menu {
    Clear-Host
    Write-Host "=== Bloatware app removal script by Quinsaiz v1.02 ===" -ForegroundColor Cyan
    Write-Host "1) MIUI/HyperOS system apps`n2) System utility`n3) Google apps`n4) Third-party apps`n98) Restore Xiaomi Dialer and Messages`n99) Manual package management`n0) Exit" -ForegroundColor White
    $choice = Read-Host "Select an option"
    
	if ([string]::IsNullOrEmpty($choice)) { Main-Menu }
	
    switch ($choice) {
        "1" { MIUI-Menu }
        "2" { Utilities-Menu }
        "3" { Google-Menu }
        "4" { ThirdParty-Menu }
        "98" { Restore-DialerMessages }
        "99" { Manual-PackageAction }
        "0" { 
            & $script:ADB kill-server
            Write-Host "Good luck!" -ForegroundColor Green
            exit 0
        }
        default { 
            Write-Host "Invalid option." -ForegroundColor Red
            Start-Sleep -Seconds 1
            Main-Menu
        }
    }
}

Check-ADB
Check-Device
Main-Menu