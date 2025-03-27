@echo off
setlocal EnableDelayedExpansion

:check_adb
if exist "adb.exe" (
    set ADB=adb.exe
    echo Using local ADB binary from script directory.
) else (
    where adb >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        set ADB=adb
        echo Using system-wide ADB.
    ) else (
        echo ADB not found. Install it or place adb.exe in the script folder.
        exit /b 1
    )
)

:check_device
set retries=3
:check_device_loop
!ADB! devices | find "device" >nul
if !ERRORLEVEL! neq 0 (
    echo Device is not connected or USB debugging is not configured.
    echo Check:
    echo 1. Whether developer mode and USB debugging are enabled.
    echo 2. Whether the device is connected via USB.
    echo 3. ADB access is allowed on the device.
    set /p "=Press Enter to retry (!retries! attempts left)..." <nul
    set /p retry=
    set /a retries-=1
    if !retries! leq 0 (
        echo Failed to detect device after multiple attempts. Exiting.
        exit /b 1
    )
    goto check_device_loop
) else (
    echo Device connected successfully!
    for /f "tokens=1" %%i in ('!ADB! devices ^| find "device"') do set DEVICE_ID=%%i
    echo Device ID: !DEVICE_ID!
)

:main_menu
cls
echo === MIUI/HyperOS bloatware app removal script by Quinsaiz ===
echo 1) MIUI/HyperOS system apps
echo 2) System utility
echo 3) Google apps
echo 4) Third-party apps
echo 99) Restore Xiaomi Dialer ^& Messages
echo 0) Exit
echo -------------------------
set /p "choice=Select an option: "
if "!choice!"=="1" goto miui_menu
if "!choice!"=="2" goto utilities_menu
if "!choice!"=="3" goto google_menu
if "!choice!"=="4" goto third_party_menu
if "!choice!"=="99" goto restore_dialer_messages
if "!choice!"=="0" (!ADB! kill-server & echo Good luck! & exit /b 0)
echo Wrong choice.
timeout /t 1 >nul
goto main_menu

:miui_menu
cls
echo === MIUI/HyperOS system apps ===
echo 1) Cleaner (com.miui.cleaner)
echo 2) Compass (com.miui.compass)
echo 3) GetApps (com.xiaomi.mipicks)
echo 4) Mi Browser (com.mi.globalbrowser)
echo 5) Mi Home (com.xiaomi.smarthome)
echo 6) Mi Mover (com.miui.huanji)
echo 7) Mi Music (com.miui.player)
echo 8) Mi Video (com.miui.video com.miui.videoplayer)
echo 9) MinusScreen Widget (com.mi.globalminusscreen com.mi.android.globalminusscreen)
echo 10) POCO Store ^& Community (com.mi.global.pocostore com.mi.global.pocobbs)
echo 11) QR Scanner (com.xiaomi.scanner)
echo 12) ShareMe (com.xiaomi.midrop)
echo 13) Downloads (com.android.providers.downloads.ui)
echo 14) Themes (com.android.thememanager)
echo 15) Wallpaper Carousel (com.miui.android.fashiongallery)
echo 16) Xiaomi Games (com.xiaomi.glgm)
echo 98) Uninstall selectively
echo 99) Check status of apps
echo 0) Return to main menu
echo -------------------------
set /p "app_choice=Select an app: "
if "!app_choice!"=="1" call :action_menu "Cleaner" "com.miui.cleaner" "Uninstall" "miui_menu"
if "!app_choice!"=="2" call :action_menu "Compass" "com.miui.compass" "Uninstall" "miui_menu"
if "!app_choice!"=="3" call :action_menu "GetApps" "com.xiaomi.mipicks" "Uninstall" "miui_menu"
if "!app_choice!"=="4" call :action_menu "Mi Browser" "com.mi.globalbrowser" "Uninstall" "miui_menu"
if "!app_choice!"=="5" call :action_menu "Mi Home" "com.xiaomi.smarthome" "Uninstall" "miui_menu"
if "!app_choice!"=="6" call :action_menu "Mi Mover" "com.miui.huanji" "Uninstall" "miui_menu"
if "!app_choice!"=="7" call :action_menu "Mi Music" "com.miui.player" "Uninstall" "miui_menu"
if "!app_choice!"=="8" call :action_menu "Mi Video" "com.miui.video com.miui.videoplayer" "Uninstall" "miui_menu"
if "!app_choice!"=="9" call :action_menu "MinusScreen Widget" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "Uninstall" "miui_menu"
if "!app_choice!"=="10" call :action_menu "POCO Store & Community" "com.mi.global.pocostore com.mi.global.pocobbs" "Uninstall" "miui_menu"
if "!app_choice!"=="11" call :action_menu "QR Scanner" "com.xiaomi.scanner" "Uninstall" "miui_menu"
if "!app_choice!"=="12" call :action_menu "ShareMe" "com.xiaomi.midrop" "Uninstall" "miui_menu"
if "!app_choice!"=="13" call :action_menu "Downloads" "com.android.providers.downloads.ui" "Uninstall" "miui_menu"
if "!app_choice!"=="14" call :action_menu "Themes" "com.android.thememanager" "Uninstall" "miui_menu"
if "!app_choice!"=="15" call :action_menu "Wallpaper Carousel" "com.miui.android.fashiongallery" "Uninstall" "miui_menu"
if "!app_choice!"=="16" call :action_menu "Xiaomi Games" "com.xiaomi.glgm" "Uninstall" "miui_menu"
if "!app_choice!"=="98" call :selective_uninstall "miui_menu" "com.miui.cleaner" "com.miui.compass" "com.xiaomi.mipicks" "com.mi.globalbrowser" "com.xiaomi.smarthome" "com.miui.huanji" "com.miui.player" "com.miui.video com.miui.videoplayer" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "com.mi.global.pocostore com.mi.global.pocobbs" "com.xiaomi.scanner" "com.xiaomi.midrop" "com.android.providers.downloads.ui" "com.android.thememanager" "com.miui.android.fashiongallery" "com.xiaomi.glgm"
if "!app_choice!"=="99" call :check_all_status "miui_menu" "com.miui.cleaner" "com.miui.compass" "com.xiaomi.mipicks" "com.mi.globalbrowser" "com.xiaomi.smarthome" "com.miui.huanji" "com.miui.player" "com.miui.video com.miui.videoplayer" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "com.mi.global.pocostore com.mi.global.pocobbs" "com.xiaomi.scanner" "com.xiaomi.midrop" "com.android.providers.downloads.ui" "com.android.thememanager" "com.miui.android.fashiongallery" "com.xiaomi.glgm"
if "!app_choice!"=="0" goto main_menu
echo Wrong choice.
timeout /t 1 >nul
goto miui_menu

:utilities_menu
cls
echo === System utility ===
echo 1) Ad Bookmarks (com.android.bookmarkprovider com.android.providers.partnerbookmarks)
echo 2) Battery Logs Catchlog (com.bsp.catchlog)
echo 3) Bluetooth MIDI (com.android.bluetoothmidiservice)
echo 4) Cloud Backup (com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase)
echo 5) Google One Time Initialization (com.google.android.onetimeinitializer com.google.android.partnersetup)
echo 6) Google Print Recommendations (com.google.android.printservice.recommendation)
echo 7) MIUI Ads (com.miui.msa.global)
echo 8) MIUI Analytics (com.miui.analytics)
echo 9) MIUI Daemon (com.miui.daemon)
echo 10) MMS Service (com.android.mms.service)
echo 11) Navigation Gestures (com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton)
echo 12) Noto Serif Font (com.android.theme.font.notoserifsource)
echo 13) OK Google Detection (com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle)
echo 14) Print Service (com.android.bips com.android.printspooler)
echo 15) Quick Apps (com.miui.hybrid com.miui.hybrid.accessory)
echo 16) SIM Card Menu (com.android.stk)
echo 17) System Tracing (com.android.traceur)
echo 18) TalkBack (com.google.android.marvin.talkback)
echo 19) Touch Assistant (com.miui.touchassistant)
echo 20) Voice Activation (com.quicinc.voice.activation)
echo 21) Wallpaper Backup (com.android.wallpaperbackup)
echo 22) App Vault Widget (com.miui.personalassistant)
echo 23) Bug Reports ^& Feedback (com.miui.bugreport com.miui.miservice)
echo 24) Chinese Caller ID (com.miui.yellowpage)
echo 25) Chinese Mi Pay (com.xiaomi.payment com.mipay.wallet.in)
echo 26) Chinese Payment Verification Service (com.tencent.soter.soterserver)
echo 27) Chinese Promo Service (com.xiaomi.mirecycle)
echo 28) Chinese Virtual Cards (com.miui.vsimcore)
echo 29) Chinese Wi-Fi Variant (com.wapi.wapicertmanage)
echo 30) Device Health Services (com.google.android.apps.turbo)
echo 31) Interconnectivity ^& Services (com.milink.service com.xiaomi.mirror)
echo 32) Joyose (com.xiaomi.joyose)
echo 33) Qualcomm Miracast (com.qualcomm.atfwd)
echo 34) Qualcomm RCS (com.qualcomm.qti.uceShimService)
echo 98) Uninstall selectively
echo 99) Check status of apps
echo 0) Return to main menu
echo -------------------------
set /p "app_choice=Select an app: "
if "!app_choice!"=="1" call :action_menu "Ad Bookmarks" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "Disable" "utilities_menu"
if "!app_choice!"=="2" call :action_menu "Battery Logs Catchlog" "com.bsp.catchlog" "Disable" "utilities_menu"
if "!app_choice!"=="3" call :action_menu "Bluetooth MIDI" "com.android.bluetoothmidiservice" "Disable" "utilities_menu"
if "!app_choice!"=="4" call :action_menu "Cloud Backup" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "Disable" "utilities_menu"
if "!app_choice!"=="5" call :action_menu "Google One Time Initialization" "com.google.android.onetimeinitializer com.google.android.partnersetup" "Disable" "utilities_menu"
if "!app_choice!"=="6" call :action_menu "Google Print Recommendations" "com.google.android.printservice.recommendation" "Disable" "utilities_menu"
if "!app_choice!"=="7" call :action_menu "MIUI Ads" "com.miui.msa.global" "Disable" "utilities_menu"
if "!app_choice!"=="8" call :action_menu "MIUI Analytics" "com.miui.analytics" "Disable" "utilities_menu"
if "!app_choice!"=="9" call :action_menu "MIUI Daemon" "com.miui.daemon" "Disable" "utilities_menu"
if "!app_choice!"=="10" call :action_menu "MMS Service" "com.android.mms.service" "Disable" "utilities_menu"
if "!app_choice!"=="11" call :action_menu "Navigation Gestures" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "Disable" "utilities_menu"
if "!app_choice!"=="12" call :action_menu "Noto Serif Font" "com.android.theme.font.notoserifsource" "Disable" "utilities_menu"
if "!app_choice!"=="13" call :action_menu "OK Google Detection" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "Disable" "utilities_menu"
if "!app_choice!"=="14" call :action_menu "Print Service" "com.android.bips com.android.printspooler" "Disable" "utilities_menu"
if "!app_choice!"=="15" call :action_menu "Quick Apps" "com.miui.hybrid com.miui.hybrid.accessory" "Disable" "utilities_menu"
if "!app_choice!"=="16" call :action_menu "SIM Card Menu" "com.android.stk" "Disable" "utilities_menu"
if "!app_choice!"=="17" call :action_menu "System Tracing" "com.android.traceur" "Disable" "utilities_menu"
if "!app_choice!"=="18" call :action_menu "TalkBack" "com.google.android.marvin.talkback" "Disable" "utilities_menu"
if "!app_choice!"=="19" call :action_menu "Touch Assistant" "com.miui.touchassistant" "Disable" "utilities_menu"
if "!app_choice!"=="20" call :action_menu "Voice Activation" "com.quicinc.voice.activation" "Disable" "utilities_menu"
if "!app_choice!"=="21" call :action_menu "Wallpaper Backup" "com.android.wallpaperbackup" "Disable" "utilities_menu"
if "!app_choice!"=="22" call :action_menu "App Vault Widget" "com.miui.personalassistant" "Disable" "utilities_menu"
if "!app_choice!"=="23" call :action_menu "Bug Reports & Feedback" "com.miui.bugreport com.miui.miservice" "Disable" "utilities_menu"
if "!app_choice!"=="24" call :action_menu "Chinese Caller ID" "com.miui.yellowpage" "Disable" "utilities_menu"
if "!app_choice!"=="25" call :action_menu "Chinese Mi Pay" "com.xiaomi.payment com.mipay.wallet.in" "Disable" "utilities_menu"
if "!app_choice!"=="26" call :action_menu "Chinese Payment Verification Service" "com.tencent.soter.soterserver" "Disable" "utilities_menu"
if "!app_choice!"=="27" call :action_menu "Chinese Promo Service" "com.xiaomi.mirecycle" "Disable" "utilities_menu"
if "!app_choice!"=="28" call :action_menu "Chinese Virtual Cards" "com.miui.vsimcore" "Disable" "utilities_menu"
if "!app_choice!"=="29" call :action_menu "Chinese Wi-Fi Variant" "com.wapi.wapicertmanage" "Disable" "utilities_menu"
if "!app_choice!"=="30" call :action_menu "Device Health Services" "com.google.android.apps.turbo" "Disable" "utilities_menu"
if "!app_choice!"=="31" call :action_menu "Interconnectivity & Services" "com.milink.service com.xiaomi.mirror" "Disable" "utilities_menu"
if "!app_choice!"=="32" call :action_menu "Joyose" "com.xiaomi.joyose" "Disable" "utilities_menu"
if "!app_choice!"=="33" call :action_menu "Qualcomm Miracast" "com.qualcomm.atfwd" "Disable" "utilities_menu"
if "!app_choice!"=="34" call :action_menu "Qualcomm RCS" "com.qualcomm.qti.uceShimService" "Disable" "utilities_menu"
if "!app_choice!"=="98" call :selective_uninstall "utilities_menu" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "com.bsp.catchlog" "com.android.bluetoothmidiservice" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "com.google.android.onetimeinitializer com.google.android.partnersetup" "com.google.android.printservice.recommendation" "com.miui.msa.global" "com.miui.analytics" "com.miui.daemon" "com.android.mms.service" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "com.android.theme.font.notoserifsource" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "com.android.bips com.android.printspooler" "com.miui.hybrid com.miui.hybrid.accessory" "com.android.stk" "com.android.traceur" "com.google.android.marvin.talkback" "com.miui.touchassistant" "com.quicinc.voice.activation" "com.android.wallpaperbackup" "com.miui.personalassistant" "com.miui.bugreport com.miui.miservice" "com.miui.yellowpage" "com.xiaomi.payment com.mipay.wallet.in" "com.tencent.soter.soterserver" "com.xiaomi.mirecycle" "com.miui.vsimcore" "com.wapi.wapicertmanage" "com.google.android.apps.turbo" "com.milink.service com.xiaomi.mirror" "com.xiaomi.joyose" "com.qualcomm.atfwd" "com.qualcomm.qti.uceShimService"
if "!app_choice!"=="99" call :check_all_status "utilities_menu" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "com.bsp.catchlog" "com.android.bluetoothmidiservice" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "com.google.android.onetimeinitializer com.google.android.partnersetup" "com.google.android.printservice.recommendation" "com.miui.msa.global" "com.miui.analytics" "com.miui.daemon" "com.android.mms.service" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "com.android.theme.font.notoserifsource" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "com.android.bips com.android.printspooler" "com.miui.hybrid com.miui.hybrid.accessory" "com.android.stk" "com.android.traceur" "com.google.android.marvin.talkback" "com.miui.touchassistant" "com.quicinc.voice.activation" "com.android.wallpaperbackup" "com.miui.personalassistant" "com.miui.bugreport com.miui.miservice" "com.miui.yellowpage" "com.xiaomi.payment com.mipay.wallet.in" "com.tencent.soter.soterserver" "com.xiaomi.mirecycle" "com.miui.vsimcore" "com.wapi.wapicertmanage" "com.google.android.apps.turbo" "com.milink.service com.xiaomi.mirror" "com.xiaomi.joyose" "com.qualcomm.atfwd" "com.qualcomm.qti.uceShimService"
if "!app_choice!"=="0" goto main_menu
echo Wrong choice.
timeout /t 1 >nul
goto utilities_menu

:google_menu
cls
echo === Google apps ===
echo 1) Android Auto (com.google.android.projection.gearhead)
echo 2) Chrome (com.android.chrome)
echo 3) Contacts (com.google.android.contacts)
echo 4) Dialer (com.google.android.dialer)
echo 5) Digital Wellbeing (com.google.android.apps.wellbeing)
echo 6) Drive (com.google.android.apps.docs)
echo 7) Files (com.google.android.apps.nbu.files)
echo 8) Gmail (com.google.android.gm)
echo 9) Google Assistant (com.google.android.apps.googleassistant)
echo 10) Google Duo (com.google.android.apps.tachyon)
echo 11) Google Music (com.google.android.music)
echo 12) Google One (com.google.android.apps.subscriptions.red)
echo 13) Google Search (com.google.android.googlequicksearchbox)
echo 14) Google Videos (com.google.android.videos)
echo 15) Health Connect (com.google.android.apps.healthdata)
echo 16) Maps (com.google.android.apps.maps)
echo 17) Messages (google.android.apps.messaging)
echo 18) Safety Hub (com.google.android.apps.safetyhub)
echo 19) YouTube (com.google.android.youtube)
echo 20) YouTube Music (com.google.android.apps.youtube.music)
echo 98) Uninstall selectively
echo 99) Check status of apps
echo 0) Return to main menu
echo -------------------------
set /p "app_choice=Select an app: "
if "!app_choice!"=="1" call :action_menu "Android Auto" "com.google.android.projection.gearhead" "Uninstall" "google_menu"
if "!app_choice!"=="2" call :action_menu "Chrome" "com.android.chrome" "Uninstall" "google_menu"
if "!app_choice!"=="3" call :action_menu "Contacts" "com.google.android.contacts" "Uninstall" "google_menu"
if "!app_choice!"=="4" call :action_menu "Dialer" "com.google.android.dialer" "Uninstall" "google_menu"
if "!app_choice!"=="5" call :action_menu "Digital Wellbeing" "com.google.android.apps.wellbeing" "Uninstall" "google_menu"
if "!app_choice!"=="6" call :action_menu "Drive" "com.google.android.apps.docs" "Uninstall" "google_menu"
if "!app_choice!"=="7" call :action_menu "Files" "com.google.android.apps.nbu.files" "Uninstall" "google_menu"
if "!app_choice!"=="8" call :action_menu "Gmail" "com.google.android.gm" "Uninstall" "google_menu"
if "!app_choice!"=="9" call :action_menu "Google Assistant" "com.google.android.apps.googleassistant" "Uninstall" "google_menu"
if "!app_choice!"=="10" call :action_menu "Google Duo" "com.google.android.apps.tachyon" "Uninstall" "google_menu"
if "!app_choice!"=="11" call :action_menu "Google Music" "com.google.android.music" "Uninstall" "google_menu"
if "!app_choice!"=="12" call :action_menu "Google One" "com.google.android.apps.subscriptions.red" "Uninstall" "google_menu"
if "!app_choice!"=="13" call :action_menu "Google Search" "com.google.android.googlequicksearchbox" "Uninstall" "google_menu"
if "!app_choice!"=="14" call :action_menu "Google Videos" "com.google.android.videos" "Uninstall" "google_menu"
if "!app_choice!"=="15" call :action_menu "Health Connect" "com.google.android.apps.healthdata" "Uninstall" "google_menu"
if "!app_choice!"=="16" call :action_menu "Maps" "com.google.android.apps.maps" "Uninstall" "google_menu"
if "!app_choice!"=="17" call :action_menu "Messages" "google.android.apps.messaging" "Uninstall" "google_menu"
if "!app_choice!"=="18" call :action_menu "Safety Hub" "com.google.android.apps.safetyhub" "Uninstall" "google_menu"
if "!app_choice!"=="19" call :action_menu "YouTube" "com.google.android.youtube" "Uninstall" "google_menu"
if "!app_choice!"=="20" call :action_menu "YouTube Music" "com.google.android.apps.youtube.music" "Uninstall" "google_menu"
if "!app_choice!"=="98" call :selective_uninstall "google_menu" "com.google.android.projection.gearhead" "com.android.chrome" "com.google.android.contacts" "com.google.android.dialer" "com.google.android.apps.wellbeing" "com.google.android.apps.docs" "com.google.android.apps.nbu.files" "com.google.android.gm" "com.google.android.apps.googleassistant" "com.google.android.apps.tachyon" "com.google.android.music" "com.google.android.apps.subscriptions.red" "com.google.android.googlequicksearchbox" "com.google.android.videos" "com.google.android.apps.healthdata" "com.google.android.apps.maps" "google.android.apps.messaging" "com.google.android.apps.safetyhub" "com.google.android.youtube" "com.google.android.apps.youtube.music"
if "!app_choice!"=="99" call :check_all_status "google_menu" "com.google.android.projection.gearhead" "com.android.chrome" "com.google.android.contacts" "com.google.android.dialer" "com.google.android.apps.wellbeing" "com.google.android.apps.docs" "com.google.android.apps.nbu.files" "com.google.android.gm" "com.google.android.apps.googleassistant" "com.google.android.apps.tachyon" "com.google.android.music" "com.google.android.apps.subscriptions.red" "com.google.android.googlequicksearchbox" "com.google.android.videos" "com.google.android.apps.healthdata" "com.google.android.apps.maps" "google.android.apps.messaging" "com.google.android.apps.safetyhub" "com.google.android.youtube" "com.google.android.apps.youtube.music"
if "!app_choice!"=="0" goto main_menu
echo Wrong choice.
timeout /t 1 >nul
goto google_menu

:third_party_menu
cls
echo === Third-party apps ===
echo 1) Amazon (com.amazon.mShop.android.shopping com.amazon.appmanager)
echo 2) Block Juggle (com.block.juggle)
echo 3) Booking (com.booking)
echo 4) Facebook (com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana)
echo 5) Netflix (com.netflix.mediaclient com.netflix.partner.activation)
echo 6) OneDrive (com.microsoft.skydrive)
echo 7) Opera (com.opera.browser com.opera.preinstall)
echo 8) Spotify (com.spotify.music)
echo 9) Temu (com.einnovation.temu)
echo 10) WPS Office (cn.wps.moffice_eng)
echo 98) Uninstall selectively
echo 99) Check status of apps
echo 0) Return to main menu
echo -------------------------
set /p "app_choice=Select an app: "
if "!app_choice!"=="1" call :action_menu "Amazon" "com.amazon.mShop.android.shopping com.amazon.appmanager" "Uninstall" "third_party_menu"
if "!app_choice!"=="2" call :action_menu "Block Juggle" "com.block.juggle" "Uninstall" "third_party_menu"
if "!app_choice!"=="3" call :action_menu "Booking" "com.booking" "Uninstall" "third_party_menu"
if "!app_choice!"=="4" call :action_menu "Facebook" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "Uninstall" "third_party_menu"
if "!app_choice!"=="5" call :action_menu "Netflix" "com.netflix.mediaclient com.netflix.partner.activation" "Uninstall" "third_party_menu"
if "!app_choice!"=="6" call :action_menu "OneDrive" "com.microsoft.skydrive" "Uninstall" "third_party_menu"
if "!app_choice!"=="7" call :action_menu "Opera" "com.opera.browser com.opera.preinstall" "Uninstall" "third_party_menu"
if "!app_choice!"=="8" call :action_menu "Spotify" "com.spotify.music" "Uninstall" "third_party_menu"
if "!app_choice!"=="9" call :action_menu "Temu" "com.einnovation.temu" "Uninstall" "third_party_menu"
if "!app_choice!"=="10" call :action_menu "WPS Office" "cn.wps.moffice_eng" "Uninstall" "third_party_menu"
if "!app_choice!"=="98" call :selective_uninstall "third_party_menu" "com.amazon.mShop.android.shopping com.amazon.appmanager" "com.block.juggle" "com.booking" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "com.netflix.mediaclient com.netflix.partner.activation" "com.microsoft.skydrive" "com.opera.browser com.opera.preinstall" "com.spotify.music" "com.einnovation.temu" "cn.wps.moffice_eng"
if "!app_choice!"=="99" call :check_all_status "third_party_menu" "com.amazon.mShop.android.shopping com.amazon.appmanager" "com.block.juggle" "com.booking" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "com.netflix.mediaclient com.netflix.partner.activation" "com.microsoft.skydrive" "com.opera.browser com.opera.preinstall" "com.spotify.music" "com.einnovation.temu" "cn.wps.moffice_eng"
if "!app_choice!"=="0" goto main_menu
echo Wrong choice.
timeout /t 1 >nul
goto third_party_menu

:action_menu
cls
set "name=%~1"
set "packages=%~2"
set "recommendation=%~3"
set "return_menu=%~4"
echo Action for %name%

set "installed_pkgs="
set "disabled_pkgs="
set "uninstalled_pkgs="
set "not_installed_pkgs="
set "status_output="

for %%p in (%packages%) do (
    !ADB! shell pm list packages -u | find "%%p" >nul
    if !ERRORLEVEL! equ 0 (
        !ADB! shell pm list packages -d | find "%%p" >nul
        if !ERRORLEVEL! equ 0 (
            set "disabled_pkgs=!disabled_pkgs! %%p"
        ) else (
            !ADB! shell pm list packages | find "%%p" >nul
            if !ERRORLEVEL! equ 0 (
                set "installed_pkgs=!installed_pkgs! %%p"
            ) else (
                set "uninstalled_pkgs=!uninstalled_pkgs! %%p"
            )
        )
    ) else (
        set "not_installed_pkgs=!not_installed_pkgs! %%p"
    )
)

if defined installed_pkgs set "status_output=Installed (!installed_pkgs:~1!)"
if defined disabled_pkgs set "status_output=!status_output!, Disabled (!disabled_pkgs:~1!)"
if defined uninstalled_pkgs set "status_output=!status_output!, Uninstalled (!uninstalled_pkgs:~1!)"
if defined not_installed_pkgs set "status_output=!status_output!, Not installed (!not_installed_pkgs:~1!)"

echo Status: !status_output!
echo Recommendation: %recommendation%
echo 1) Uninstall
echo 2) Disable
echo 3) Restore
echo 4) Enable
echo 0) Return
echo -------------------------
set /p "action=Select an action: "
if "!action!"=="1" (
    for %%p in (%packages%) do call :uninstall_package "%%p"
)
if "!action!"=="2" (
    for %%p in (%packages%) do call :disable_package "%%p"
)
if "!action!"=="3" (
    for %%p in (%packages%) do call :install_package "%%p"
)
if "!action!"=="4" (
    for %%p in (%packages%) do call :enable_package "%%p"
)
if "!action!"=="0" goto :%return_menu%
echo Wrong action.
set /p "=Press Enter to continue..." <nul
set /p continue=
goto :%return_menu%

:uninstall_package
set "package=%~1"
!ADB! shell pm list packages -u | find "%package%" >nul
if !ERRORLEVEL! equ 0 (
    !ADB! shell pm list packages | find "%package%" >nul
    if !ERRORLEVEL! neq 0 (
        echo The package %package% has already been removed.
    ) else (
        for /f %%i in ('!ADB! shell pm uninstall --user 0 %package%') do set "output=%%i"
        if "!output!"=="Success" (
            echo Successfully uninstalled: %package%
        ) else (
            echo Failed to remove %package%: !output!
        )
    )
)
goto :eof

:disable_package
set "package=%~1"
!ADB! shell pm list packages -d | find "%package%" >nul
if !ERRORLEVEL! equ 0 (
    echo Package %package% is already disabled.
) else (
    for /f "delims=" %%i in ('!ADB! shell pm disable-user --user 0 %package%') do set "output=%%i"
    echo !output! | find "disabled-user" >nul
    if !ERRORLEVEL! equ 0 (
        echo Successfully disabled: %package%
    ) else (
        echo Failed to disable %package%: !output!
    )
)
goto :eof

:install_package
set "package=%~1"
!ADB! shell pm list packages | find "%package%" >nul
if !ERRORLEVEL! equ 0 (
    !ADB! shell pm list packages -d | find "%package%" >nul
    if !ERRORLEVEL! neq 0 (
        echo The package %package% is already installed.
    ) else (
        goto install_existing
    )
) else (
    :install_existing
    for /f "delims=" %%i in ('!ADB! shell pm install-existing --user 0 %package% 2^>^&1') do set "output=%%i"
    echo !output! | find "installed" >nul
    if !ERRORLEVEL! equ 0 (
        echo Successfully restored: %package%
    ) else if "!output!"=="" (
        echo Successfully restored: %package%
    ) else (
        echo !output! | find "doesn't exist" >nul
        if !ERRORLEVEL! equ 0 (
            echo Package %package% was not found on the system to restore.
        ) else (
            echo Error restoring %package%: !output!
        )
    )
)
goto :eof

:enable_package
set "package=%~1"
!ADB! shell pm list packages | find "%package%" >nul
if !ERRORLEVEL! equ 0 (
    !ADB! shell pm list packages -d | find "%package%" >nul
    if !ERRORLEVEL! neq 0 (
        echo Package %package% is already enabled.
    ) else (
        for /f %%i in ('!ADB! shell pm enable --user 0 %package%') do set "output=%%i"
        echo !output! | find "enabled" >nul
        if !ERRORLEVEL! equ 0 (
            echo Successfully enabled: %package%
        ) else (
            echo Failed to enable %package%: !output!
        )
    )
)
goto :eof

:selective_uninstall
set "return_menu=%~1"
shift
set "index=0"
REM Зберігаємо всі пакети в змінні pkg_0, pkg_1, ...
:store_packages
if "%~1"=="" goto store_done
set "pkg_!index!=%~1"
set /a index+=1
shift
goto store_packages
:store_done
set "max_index=!index!"
set /a max_index-=1

cls
echo === Uninstall selectively ===
echo Enter the program numbers separated by a space (for example, '1 5 6').
echo Range: 1-!max_index!
echo -------------------------
set /p "selection=Select programs: "

for %%n in (!selection!) do (
    set "valid=0"
    if %%n geq 1 if %%n leq !max_index! (
        set "valid=1"
        set /a "idx=%%n-1"
        call set "package=%%pkg_!idx!%%"
        for %%p in (!package!) do call :uninstall_package "%%p"
    )
    if !valid! equ 0 (
        echo Wrong number: %%n
    )
)

set /p "=Press Enter to continue..." <nul
set /p continue=
goto :%return_menu%

:check_all_status
set "return_menu=%~1"
shift
cls
echo === Check status of apps ===
set "index=0"
for %%p in (%*) do (
    set /a index+=1
    set "pkg_group=%%p"
    call :check_package_status "!pkg_group!" status
    if "!return_menu!"=="miui_menu" (
        if !index! equ 1 echo !index!) Cleaner ^| !status!
        if !index! equ 2 echo !index!) Compass ^| !status!
        if !index! equ 3 echo !index!) GetApps ^| !status!
        if !index! equ 4 echo !index!) Mi Browser ^| !status!
        if !index! equ 5 echo !index!) Mi Home ^| !status!
        if !index! equ 6 echo !index!) Mi Mover ^| !status!
        if !index! equ 7 echo !index!) Mi Music ^| !status!
        if !index! equ 8 echo !index!) Mi Video ^| !status!
        if !index! equ 9 echo !index!) MinusScreen Widget ^| !status!
        if !index! equ 10 echo !index!) POCO Store ^& Community ^| !status!
        if !index! equ 11 echo !index!) QR Scanner ^| !status!
        if !index! equ 12 echo !index!) ShareMe ^| !status!
        if !index! equ 13 echo !index!) Downloads ^| !status!
        if !index! equ 14 echo !index!) Themes ^| !status!
        if !index! equ 15 echo !index!) Wallpaper Carousel ^| !status!
        if !index! equ 16 echo !index!) Xiaomi Games ^| !status!
    ) else if "!return_menu!"=="utilities_menu" (
        if !index! equ 1 echo !index!) Ad Bookmarks ^| !status!
        if !index! equ 2 echo !index!) Battery Logs Catchlog ^| !status!
        if !index! equ 3 echo !index!) Bluetooth MIDI ^| !status!
        if !index! equ 4 echo !index!) Cloud Backup ^| !status!
        if !index! equ 5 echo !index!) Google One Time Initialization ^| !status!
        if !index! equ 6 echo !index!) Google Print Recommendations ^| !status!
        if !index! equ 7 echo !index!) MIUI Ads ^| !status!
        if !index! equ 8 echo !index!) MIUI Analytics ^| !status!
        if !index! equ 9 echo !index!) MIUI Daemon ^| !status!
        if !index! equ 10 echo !index!) MMS Service ^| !status!
        if !index! equ 11 echo !index!) Navigation Gestures ^| !status!
        if !index! equ 12 echo !index!) Noto Serif Font ^| !status!
        if !index! equ 13 echo !index!) OK Google Detection ^| !status!
        if !index! equ 14 echo !index!) Print Service ^| !status!
        if !index! equ 15 echo !index!) Quick Apps ^| !status!
        if !index! equ 16 echo !index!) SIM Card Menu ^| !status!
        if !index! equ 17 echo !index!) System Tracing ^| !status!
        if !index! equ 18 echo !index!) TalkBack ^| !status!
        if !index! equ 19 echo !index!) Touch Assistant ^| !status!
        if !index! equ 20 echo !index!) Voice Activation ^| !status!
        if !index! equ 21 echo !index!) Wallpaper Backup ^| !status!
        if !index! equ 22 echo !index!) App Vault Widget ^| !status!
        if !index! equ 23 echo !index!) Bug Reports ^& Feedback ^| !status!
        if !index! equ 24 echo !index!) Chinese Caller ID ^| !status!
        if !index! equ 25 echo !index!) Chinese Mi Pay ^| !status!
        if !index! equ 26 echo !index!) Chinese Payment Verification Service ^| !status!
        if !index! equ 27 echo !index!) Chinese Promo Service ^| !status!
        if !index! equ 28 echo !index!) Chinese Virtual Cards ^| !status!
        if !index! equ 29 echo !index!) Chinese Wi-Fi Variant ^| !status!
        if !index! equ 30 echo !index!) Device Health Services ^| !status!
        if !index! equ 31 echo !index!) Interconnectivity ^& Services ^| !status!
        if !index! equ 32 echo !index!) Joyose ^| !status!
        if !index! equ 33 echo !index!) Qualcomm Miracast ^| !status!
        if !index! equ 34 echo !index!) Qualcomm RCS ^| !status!
    ) else if "!return_menu!"=="google_menu" (
        if !index! equ 1 echo !index!) Android Auto ^| !status!
        if !index! equ 2 echo !index!) Chrome ^| !status!
        if !index! equ 3 echo !index!) Contacts ^| !status!
        if !index! equ 4 echo !index!) Dialer ^| !status!
        if !index! equ 5 echo !index!) Digital Wellbeing ^| !status!
        if !index! equ 6 echo !index!) Drive ^| !status!
        if !index! equ 7 echo !index!) Files ^| !status!
        if !index! equ 8 echo !index!) Gmail ^| !status!
        if !index! equ 9 echo !index!) Google Assistant ^| !status!
        if !index! equ 10 echo !index!) Google Duo ^| !status!
        if !index! equ 11 echo !index!) Google Music ^| !status!
        if !index! equ 12 echo !index!) Google One ^| !status!
        if !index! equ 13 echo !index!) Google Search ^| !status!
        if !index! equ 14 echo !index!) Google Videos ^| !status!
        if !index! equ 15 echo !index!) Health Connect ^| !status!
        if !index! equ 16 echo !index!) Maps ^| !status!
        if !index! equ 17 echo !index!) Messages ^| !status!
        if !index! equ 18 echo !index!) Safety Hub ^| !status!
        if !index! equ 19 echo !index!) YouTube ^| !status!
        if !index! equ 20 echo !index!) YouTube Music ^| !status!
    ) else if "!return_menu!"=="third_party_menu" (
        if !index! equ 1 echo !index!) Amazon ^| !status!
        if !index! equ 2 echo !index!) Block Juggle ^| !status!
        if !index! equ 3 echo !index!) Booking ^| !status!
        if !index! equ 4 echo !index!) Facebook ^| !status!
        if !index! equ 5 echo !index!) Netflix ^| !status!
        if !index! equ 6 echo !index!) OneDrive ^| !status!
        if !index! equ 7 echo !index!) Opera ^| !status!
        if !index! equ 8 echo !index!) Spotify ^| !status!
        if !index! equ 9 echo !index!) Temu ^| !status!
        if !index! equ 10 echo !index!) WPS Office ^| !status!
    )
)
echo -------------------------
set /p "=Press Enter to continue..." <nul
set /p continue=
goto :%return_menu%

:check_package_status
set "packages=%~1"
set "installed=0"
set "disabled=0"
set "uninstalled=0"
set "total=0"
set "system_exists=0"

for %%p in (%packages%) do (
    set /a total+=1
    !ADB! shell pm list packages -u | find "%%p" >nul
    if !ERRORLEVEL! equ 0 (
        set system_exists=1
        !ADB! shell pm list packages -d | find "%%p" >nul
        if !ERRORLEVEL! equ 0 (
            set /a disabled+=1
        ) else (
            !ADB! shell pm list packages | find "%%p" >nul
            if !ERRORLEVEL! equ 0 (
                set /a installed+=1
            ) else (
                set /a uninstalled+=1
            )
        )
    ) else (
        set /a uninstalled+=1
    )
)

if !total! equ !installed! set "%2=Installed"
if !total! equ !disabled! set "%2=Disabled"
if !total! equ !uninstalled! if !system_exists! equ 1 set "%2=Uninstalled"
if !total! equ !uninstalled! if !system_exists! equ 0 set "%2=Not installed"
if !installed! gtr 0 if !total! neq !installed! set "%2=Partially installed"
goto :eof

:restore_dialer_messages
cls
echo === Restoring Xiaomi Dialer ^& Messages ===
echo Checking Xiaomi Dialer (com.android.contacts) in system...
for /f "delims=" %%i in ('!ADB! shell pm install-existing --user 0 com.android.contacts 2^>^&1') do set "dialer_output=%%i"
echo !dialer_output! | find "installed" >nul
if !ERRORLEVEL! equ 0 (
    echo Xiaomi Dialer restored successfully from system!
) else if "!dialer_output!"=="" (
    echo Xiaomi Dialer restored successfully from system!
) else (
    echo !dialer_output! | find "doesn't exist" >nul
    if !ERRORLEVEL! equ 0 (
        echo Xiaomi Dialer not found in system.
    ) else (
        echo Error restoring Xiaomi Dialer from system: !dialer_output!
    )
)

echo Checking Xiaomi Messages (com.android.mms) in system...
for /f "delims=" %%i in ('!ADB! shell pm install-existing --user 0 com.android.mms 2^>^&1') do set "messages_output=%%i"
echo !messages_output! | find "installed" >nul
if !ERRORLEVEL! equ 0 (
    echo Xiaomi Messages restored successfully from system!
) else if "!messages_output!"=="" (
    echo Xiaomi Messages restored successfully from system!
) else (
    echo !messages_output! | find "doesn't exist" >nul
    if !ERRORLEVEL! equ 0 (
        echo Xiaomi Messages not found in system.
    ) else (
        echo Error restoring Xiaomi Messages from system: !messages_output!
    )
)
set /p "=Press Enter to continue..." <nul
set /p continue=
goto main_menu

call :check_adb
!ADB! kill-server >nul 2>&1
!ADB! start-server >nul 2>&1 || (echo Failed to start ADB server. & exit /b 1)
call :check_device 3
echo MIUI/HyperOS bloatware app removal script by Quinsaiz
goto main_menu