@echo off
chcp 65001 >nul
title MIUI/HyperOS видалення програм від Quinsaiz
setlocal enabledelayedexpansion

:check_adb
if not exist adb.exe (
    cls
    echo [RED]ADB не знайдено. Розпакуйте його в папку зі скриптом або встановіть глобально.[NC]
    pause
    goto check_adb
)

:check_device
cls
echo Перевірка підключення пристрою...
adb kill-server >nul 2>&1
adb start-server >nul 2>&1
for /f "tokens=1" %%a in ('adb devices ^| findstr /r /c:"[0-9A-Za-z].*device$"') do set "device=%%a"
if not defined device (
    cls
    echo [RED]Пристрій не підключено![NC]
    echo Перевірте:
    echo - Увімкніть режим розробника та USB-налагодження.
    echo - Підключіть пристрій через USB.
    echo - Дозвольте доступ до ADB на пристрої.
    pause
    goto check_device
) else (
    echo [GREEN]Пристрій підключено успішно![NC]
    echo ID: !device!
    echo MIUI/HyperOS видалення програм від Quinsaiz
)

:main_menu
cls
echo === MIUI/HyperOS видалення програм від Quinsaiz ===
echo 1) Системні програми MIUI/HyperOS
echo 2) Службові утиліти (критичні)
echo 3) Програми від Google
echo 4) Сторонні додатки
echo 0) Вихід
echo -------------------------
set /p choice="Виберіть опцію: "

if "!choice!"=="1" goto miui_menu
if "!choice!"=="2" goto utilities_menu
if "!choice!"=="3" goto google_menu
if "!choice!"=="4" goto third_party_menu
if "!choice!"=="0" goto exit
goto main_menu

:miui_menu
cls
echo === Системні програми MIUI/HyperOS ===
echo 1) GetApps (com.xiaomi.mipicks)
echo 2) Mi Browser (com.mi.globalbrowser)
echo 3) Mi Home (com.xiaomi.smarthome)
echo 4) Mi Mover (com.miui.huanji)
echo 5) Mi Music (com.miui.player)
echo 6) Mi Video (com.miui.video com.miui.videoplayer)
echo 7) POCO Community (com.mi.global.pocobbs)
echo 8) POCO Store (com.mi.global.pocostore)
echo 9) Ігри Xiaomi (com.xiaomi.glgm)
echo 10) Карусель шпалер (com.miui.android.fashiongallery)
echo 11) Стрічка віджетів MinusScreen (com.mi.globalminusscreen com.mi.android.globalminusscreen)
echo 12) ShareMe (com.xiaomi.midrop)
echo 13) Завантаження (com.android.providers.downloads.ui)
echo 14) Компас (com.miui.compass)
echo 15) Очищувач (com.miui.cleaner)
echo 16) Сканер QR (com.xiaomi.scanner)
echo 17) Теми (com.android.thememanager)
echo 98) Видалити вибірково
echo 99) Перевірити статус всіх програм
echo 0) Повернутися до головного меню
echo -------------------------
set /p app_choice="Виберіть програму: "
if "!app_choice!"=="1" call :action_menu "GetApps" "com.xiaomi.mipicks" "Видалити" "miui_menu"
if "!app_choice!"=="2" call :action_menu "Mi Browser" "com.mi.globalbrowser" "Видалити" "miui_menu"
if "!app_choice!"=="3" call :action_menu "Mi Home" "com.xiaomi.smarthome" "Видалити" "miui_menu"
if "!app_choice!"=="4" call :action_menu "Mi Mover" "com.miui.huanji" "Видалити" "miui_menu"
if "!app_choice!"=="5" call :action_menu "Mi Music" "com.miui.player" "Видалити" "miui_menu"
if "!app_choice!"=="6" call :action_menu "Mi Video" "com.miui.video com.miui.videoplayer" "Видалити" "miui_menu"
if "!app_choice!"=="7" call :action_menu "POCO Community" "com.mi.global.pocobbs" "Видалити" "miui_menu"
if "!app_choice!"=="8" call :action_menu "POCO Store" "com.mi.global.pocostore" "Видалити" "miui_menu"
if "!app_choice!"=="9" call :action_menu "Ігри Xiaomi" "com.xiaomi.glgm" "Видалити" "miui_menu"
if "!app_choice!"=="10" call :action_menu "Карусель шпалер" "com.miui.android.fashiongallery" "Видалити" "miui_menu"
if "!app_choice!"=="11" call :action_menu "Стрічка віджетів MinusScreen" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "Видалити" "miui_menu"
if "!app_choice!"=="12" call :action_menu "ShareMe" "com.xiaomi.midrop" "Видалити" "miui_menu"
if "!app_choice!"=="13" call :action_menu "Завантаження" "com.android.providers.downloads.ui" "Видалити" "miui_menu"
if "!app_choice!"=="14" call :action_menu "Компас" "com.miui.compass" "Видалити" "miui_menu"
if "!app_choice!"=="15" call :action_menu "Очищувач" "com.miui.cleaner" "Видалити" "miui_menu"
if "!app_choice!"=="16" call :action_menu "Сканер QR" "com.xiaomi.scanner" "Видалити" "miui_menu"
if "!app_choice!"=="17" call :action_menu "Теми" "com.android.thememanager" "Видалити" "miui_menu"
if "!app_choice!"=="98" call :selective_uninstall "miui_menu" "com.xiaomi.mipicks" "com.mi.globalbrowser" "com.xiaomi.smarthome" "com.miui.huanji" "com.miui.player" "com.miui.video com.miui.videoplayer" "com.mi.global.pocobbs" "com.mi.global.pocostore" "com.xiaomi.glgm" "com.miui.android.fashiongallery" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "com.xiaomi.midrop" "com.android.providers.downloads.ui" "com.miui.compass" "com.miui.cleaner" "com.xiaomi.scanner" "com.android.thememanager"
if "!app_choice!"=="99" call :check_all_status "miui_menu" "com.xiaomi.mipicks" "com.mi.globalbrowser" "com.xiaomi.smarthome" "com.miui.huanji" "com.miui.player" "com.miui.video com.miui.videoplayer" "com.mi.global.pocobbs" "com.mi.global.pocostore" "com.xiaomi.glgm" "com.miui.android.fashiongallery" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "com.xiaomi.midrop" "com.android.providers.downloads.ui" "com.miui.compass" "com.miui.cleaner" "com.xiaomi.scanner" "com.android.thememanager"
if "!app_choice!"=="0" goto main_menu
goto miui_menu

:utilities_menu
cls
echo === Службові утиліти (критичні) ===
echo 1) Bluetooth MIDI (com.android.bluetoothmidiservice)
echo 2) Device Health Services (com.google.android.apps.turbo)
echo 3) MMS служба (com.android.mms.service)
echo 4) Qualcomm Miracast (com.qualcomm.atfwd)
echo 5) Qualcomm RCS повідомлення (com.qualcomm.qti.uceShimService)
echo 6) Quick Apps (com.miui.hybrid com.miui.hybrid.accessory)
echo 7) TalkBack (com.google.android.marvin.talkback)
echo 8) Китайські віртуальні картки (com.miui.vsimcore)
echo 9) Китайський варіант Wi-Fi (com.wapi.wapicertmanage)
echo 10) Аналітика MIUI (com.miui.analytics)
echo 11) Голосова активація (com.quicinc.voice.activation)
echo 12) Китайський оприділяч номера (com.miui.yellowpage)
echo 13) Звіти про помилки та зворотній зв'язок (com.miui.bugreport com.miui.miservice)
echo 14) Ініціалізація Google (com.google.android.onetimeinitializer com.google.android.partnersetup)
echo 15) Китайський Mi Pay (com.xiaomi.payment com.mipay.wallet.in)
echo 16) Китайський акційний сервіс (com.xiaomi.mirecycle)
echo 17) Китайський сервіс підтвердження платежів (com.tencent.soter.soterserver)
echo 18) Логи батареї Catchlog (com.bsp.catchlog)
echo 19) Меню SIM-карти (com.android.stk)
echo 20) Навігаційні жести (com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton)
echo 21) Оптимізація MIUI Daemon (com.miui.daemon)
echo 22) Оптимізація процесів (com.xiaomi.joyose)
echo 23) Очікування OK Google (com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle)
echo 24) Реклама MIUI (com.miui.msa.global)
echo 25) Рекламні закладки (com.android.bookmarkprovider com.android.providers.partnerbookmarks)
echo 26) Рекомендації друку Google (com.google.android.printservice.recommendation)
echo 27) Резервна копія у хмарі (com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase)
echo 28) Резервне копіювання шпалер (com.android.wallpaperbackup)
echo 29) Сенсорний помічник (com.miui.touchassistant)
echo 30) Служба друку (com.android.bips com.android.printspooler)
echo 31) Стрічка віджетів App vault (com.miui.personalassistant)
echo 32) Трасування системи (com.android.traceur)
echo 33) Шрифт Noto Serif (com.android.theme.font.notoserifsource)
echo 98) Видалити вибірково
echo 99) Перевірити статус всіх програм
echo 0) Повернутися до головного меню
echo -------------------------
set /p app_choice="Виберіть програму: "
if "!app_choice!"=="1" call :action_menu "Bluetooth MIDI" "com.android.bluetoothmidiservice" "Відключити" "utilities_menu"
if "!app_choice!"=="2" call :action_menu "Device Health Services" "com.google.android.apps.turbo" "Відключити" "utilities_menu"
if "!app_choice!"=="3" call :action_menu "MMS служба" "com.android.mms.service" "Відключити" "utilities_menu"
if "!app_choice!"=="4" call :action_menu "Qualcomm Miracast" "com.qualcomm.atfwd" "Відключити" "utilities_menu"
if "!app_choice!"=="5" call :action_menu "Qualcomm RCS повідомлення" "com.qualcomm.qti.uceShimService" "Відключити" "utilities_menu"
if "!app_choice!"=="6" call :action_menu "Quick Apps" "com.miui.hybrid com.miui.hybrid.accessory" "Відключити" "utilities_menu"
if "!app_choice!"=="7" call :action_menu "TalkBack" "com.google.android.marvin.talkback" "Відключити" "utilities_menu"
if "!app_choice!"=="8" call :action_menu "Китайські віртуальні картки" "com.miui.vsimcore" "Відключити" "utilities_menu"
if "!app_choice!"=="9" call :action_menu "Китайський варіант Wi-Fi" "com.wapi.wapicertmanage" "Відключити" "utilities_menu"
if "!app_choice!"=="10" call :action_menu "Аналітика MIUI" "com.miui.analytics" "Відключити" "utilities_menu"
if "!app_choice!"=="11" call :action_menu "Голосова активація" "com.quicinc.voice.activation" "Відключити" "utilities_menu"
if "!app_choice!"=="12" call :action_menu "Китайський оприділяч номера" "com.miui.yellowpage" "Відключити" "utilities_menu"
if "!app_choice!"=="13" call :action_menu "Звіти про помилки та зворотній зв'язок" "com.miui.bugreport com.miui.miservice" "Відключити" "utilities_menu"
if "!app_choice!"=="14" call :action_menu "Ініціалізація Google" "com.google.android.onetimeinitializer com.google.android.partnersetup" "Відключити" "utilities_menu"
if "!app_choice!"=="15" call :action_menu "Китайський Mi Pay" "com.xiaomi.payment com.mipay.wallet.in" "Відключити" "utilities_menu"
if "!app_choice!"=="16" call :action_menu "Китайський акційний сервіс" "com.xiaomi.mirecycle" "Відключити" "utilities_menu"
if "!app_choice!"=="17" call :action_menu "Китайський сервіс підтвердження платежів" "com.tencent.soter.soterserver" "Відключити" "utilities_menu"
if "!app_choice!"=="18" call :action_menu "Логи батареї Catchlog" "com.bsp.catchlog" "Відключити" "utilities_menu"
if "!app_choice!"=="19" call :action_menu "Меню SIM-карти" "com.android.stk" "Відключити" "utilities_menu"
if "!app_choice!"=="20" call :action_menu "Навігаційні жести" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "Відключити" "utilities_menu"
if "!app_choice!"=="21" call :action_menu "Оптимізація MIUI Daemon" "com.miui.daemon" "Відключити" "utilities_menu"
if "!app_choice!"=="22" call :action_menu "Оптимізація процесів" "com.xiaomi.joyose" "Відключити" "utilities_menu"
if "!app_choice!"=="23" call :action_menu "Очікування OK Google" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "Відключити" "utilities_menu"
if "!app_choice!"=="24" call :action_menu "Реклама MIUI" "com.miui.msa.global" "Відключити" "utilities_menu"
if "!app_choice!"=="25" call :action_menu "Рекламні закладки" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "Відключити" "utilities_menu"
if "!app_choice!"=="26" call :action_menu "Рекомендації друку Google" "com.google.android.printservice.recommendation" "Відключити" "utilities_menu"
if "!app_choice!"=="27" call :action_menu "Резервна копія у хмарі" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "Відключити" "utilities_menu"
if "!app_choice!"=="28" call :action_menu "Резервне копіювання шпалер" "com.android.wallpaperbackup" "Відключити" "utilities_menu"
if "!app_choice!"=="29" call :action_menu "Сенсорний помічник" "com.miui.touchassistant" "Відключити" "utilities_menu"
if "!app_choice!"=="30" call :action_menu "Служба друку" "com.android.bips com.android.printspooler" "Відключити" "utilities_menu"
if "!app_choice!"=="31" call :action_menu "Стрічка віджетів App vault" "com.miui.personalassistant" "Відключити" "utilities_menu"
if "!app_choice!"=="32" call :action_menu "Трасування системи" "com.android.traceur" "Відключити" "utilities_menu"
if "!app_choice!"=="33" call :action_menu "Шрифт Noto Serif" "com.android.theme.font.notoserifsource" "Відключити" "utilities_menu"
if "!app_choice!"=="98" call :selective_uninstall "utilities_menu" "com.android.bluetoothmidiservice" "com.google.android.apps.turbo" "com.android.mms.service" "com.qualcomm.atfwd" "com.qualcomm.qti.uceShimService" "com.miui.hybrid com.miui.hybrid.accessory" "com.google.android.marvin.talkback" "com.miui.vsimcore" "com.wapi.wapicertmanage" "com.miui.analytics" "com.quicinc.voice.activation" "com.miui.yellowpage" "com.miui.bugreport com.miui.miservice" "com.google.android.onetimeinitializer com.google.android.partnersetup" "com.xiaomi.payment com.mipay.wallet.in" "com.xiaomi.mirecycle" "com.tencent.soter.soterserver" "com.bsp.catchlog" "com.android.stk" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "com.miui.daemon" "com.xiaomi.joyose" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "com.miui.msa.global" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "com.google.android.printservice.recommendation" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "com.android.wallpaperbackup" "com.miui.touchassistant" "com.android.bips com.android.printspooler" "com.miui.personalassistant" "com.android.traceur" "com.android.theme.font.notoserifsource"
if "!app_choice!"=="99" call :check_all_status "utilities_menu" "com.android.bluetoothmidiservice" "com.google.android.apps.turbo" "com.android.mms.service" "com.qualcomm.atfwd" "com.qualcomm.qti.uceShimService" "com.miui.hybrid com.miui.hybrid.accessory" "com.google.android.marvin.talkback" "com.miui.vsimcore" "com.wapi.wapicertmanage" "com.miui.analytics" "com.quicinc.voice.activation" "com.miui.yellowpage" "com.miui.bugreport com.miui.miservice" "com.google.android.onetimeinitializer com.google.android.partnersetup" "com.xiaomi.payment com.mipay.wallet.in" "com.xiaomi.mirecycle" "com.tencent.soter.soterserver" "com.bsp.catchlog" "com.android.stk" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "com.miui.daemon" "com.xiaomi.joyose" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "com.miui.msa.global" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "com.google.android.printservice.recommendation" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "com.android.wallpaperbackup" "com.miui.touchassistant" "com.android.bips com.android.printspooler" "com.miui.personalassistant" "com.android.traceur" "com.android.theme.font.notoserifsource"
if "!app_choice!"=="0" goto main_menu
goto utilities_menu

:google_menu
cls
echo === Програми від Google ===
echo 1) Android Auto (com.google.android.projection.gearhead)
echo 2) Chrome (com.android.chrome)
echo 3) Gmail (com.google.android.gm)
echo 4) Google Assistant (com.google.android.apps.googleassistant)
echo 5) Google Duo (com.google.android.apps.tachyon)
echo 6) Google Files (com.google.android.apps.nbu.files)
echo 7) Google Maps (com.google.android.apps.maps)
echo 8) Google Music (com.google.android.music)
echo 9) Google One (com.google.android.apps.subscriptions.red)
echo 10) Google Drive (com.google.android.apps.docs)
echo 11) Google Search (com.google.android.googlequicksearchbox)
echo 12) Google Videos (com.google.android.videos)
echo 13) Health Connect (com.google.android.apps.healthdata)
echo 14) Safety Hub (com.google.android.apps.safetyhub)
echo 15) YouTube (com.google.android.youtube)
echo 16) YouTube Music (com.google.android.apps.youtube.music)
echo 17) Цифрове благополуччя (com.google.android.apps.wellbeing)
echo 98) Видалити вибірково
echo 99) Перевірити статус всіх програм
echo 0) Повернутися до головного меню
echo -------------------------
set /p app_choice="Виберіть програму: "
if "!app_choice!"=="1" call :action_menu "Android Auto" "com.google.android.projection.gearhead" "Видалити" "google_menu"
if "!app_choice!"=="2" call :action_menu "Chrome" "com.android.chrome" "Видалити" "google_menu"
if "!app_choice!"=="3" call :action_menu "Gmail" "com.google.android.gm" "Видалити" "google_menu"
if "!app_choice!"=="4" call :action_menu "Google Assistant" "com.google.android.apps.googleassistant" "Видалити" "google_menu"
if "!app_choice!"=="5" call :action_menu "Google Duo" "com.google.android.apps.tachyon" "Видалити" "google_menu"
if "!app_choice!"=="6" call :action_menu "Google Files" "com.google.android.apps.nbu.files" "Видалити" "google_menu"
if "!app_choice!"=="7" call :action_menu "Google Maps" "com.google.android.apps.maps" "Видалити" "google_menu"
if "!app_choice!"=="8" call :action_menu "Google Music" "com.google.android.music" "Видалити" "google_menu"
if "!app_choice!"=="9" call :action_menu "Google One" "com.google.android.apps.subscriptions.red" "Видалити" "google_menu"
if "!app_choice!"=="10" call :action_menu "Google Drive" "com.google.android.apps.docs" "Видалити" "google_menu"
if "!app_choice!"=="11" call :action_menu "Google Search" "com.google.android.googlequicksearchbox" "Видалити" "google_menu"
if "!app_choice!"=="12" call :action_menu "Google Videos" "com.google.android.videos" "Видалити" "google_menu"
if "!app_choice!"=="13" call :action_menu "Health Connect" "com.google.android.apps.healthdata" "Видалити" "google_menu"
if "!app_choice!"=="14" call :action_menu "Safety Hub" "com.google.android.apps.safetyhub" "Видалити" "google_menu"
if "!app_choice!"=="15" call :action_menu "YouTube" "com.google.android.youtube" "Видалити" "google_menu"
if "!app_choice!"=="16" call :action_menu "YouTube Music" "com.google.android.apps.youtube.music" "Видалити" "google_menu"
if "!app_choice!"=="17" call :action_menu "Цифрове благополуччя" "com.google.android.apps.wellbeing" "Видалити" "google_menu"
if "!app_choice!"=="98" call :selective_uninstall "google_menu" "com.google.android.projection.gearhead" "com.android.chrome" "com.google.android.gm" "com.google.android.apps.googleassistant" "com.google.android.apps.tachyon" "com.google.android.apps.nbu.files" "com.google.android.apps.maps" "com.google.android.music" "com.google.android.apps.subscriptions.red" "com.google.android.apps.docs" "com.google.android.googlequicksearchbox" "com.google.android.videos" "com.google.android.apps.healthdata" "com.google.android.apps.safetyhub" "com.google.android.youtube" "com.google.android.apps.youtube.music" "com.google.android.apps.wellbeing"
if "!app_choice!"=="99" call :check_all_status "google_menu" "com.google.android.projection.gearhead" "com.android.chrome" "com.google.android.gm" "com.google.android.apps.googleassistant" "com.google.android.apps.tachyon" "com.google.android.apps.nbu.files" "com.google.android.apps.maps" "com.google.android.music" "com.google.android.apps.subscriptions.red" "com.google.android.apps.docs" "com.google.android.googlequicksearchbox" "com.google.android.videos" "com.google.android.apps.healthdata" "com.google.android.apps.safetyhub" "com.google.android.youtube" "com.google.android.apps.youtube.music" "com.google.android.apps.wellbeing"
if "!app_choice!"=="0" goto main_menu
goto google_menu

:third_party_menu
cls
echo === Сторонні додатки ===
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
echo 98) Видалити вибірково
echo 99) Перевірити статус всіх програм
echo 0) Повернутися до головного меню
echo -------------------------
set /p app_choice="Виберіть програму: "
if "!app_choice!"=="1" call :action_menu "Amazon" "com.amazon.mShop.android.shopping com.amazon.appmanager" "Видалити" "third_party_menu"
if "!app_choice!"=="2" call :action_menu "Block Juggle" "com.block.juggle" "Видалити" "third_party_menu"
if "!app_choice!"=="3" call :action_menu "Booking" "com.booking" "Видалити" "third_party_menu"
if "!app_choice!"=="4" call :action_menu "Facebook" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "Видалити" "third_party_menu"
if "!app_choice!"=="5" call :action_menu "Netflix" "com.netflix.mediaclient com.netflix.partner.activation" "Видалити" "third_party_menu"
if "!app_choice!"=="6" call :action_menu "OneDrive" "com.microsoft.skydrive" "Видалити" "third_party_menu"
if "!app_choice!"=="7" call :action_menu "Opera" "com.opera.browser com.opera.preinstall" "Видалити" "third_party_menu"
if "!app_choice!"=="8" call :action_menu "Spotify" "com.spotify.music" "Видалити" "third_party_menu"
if "!app_choice!"=="9" call :action_menu "Temu" "com.einnovation.temu" "Видалити" "third_party_menu"
if "!app_choice!"=="10" call :action_menu "WPS Office" "cn.wps.moffice_eng" "Видалити" "third_party_menu"
if "!app_choice!"=="98" call :selective_uninstall "third_party_menu" "com.amazon.mShop.android.shopping com.amazon.appmanager" "com.block.juggle" "com.booking" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "com.netflix.mediaclient com.netflix.partner.activation" "com.microsoft.skydrive" "com.opera.browser com.opera.preinstall" "com.spotify.music" "com.einnovation.temu" "cn.wps.moffice_eng"
if "!app_choice!"=="99" call :check_all_status "third_party_menu" "com.amazon.mShop.android.shopping com.amazon.appmanager" "com.block.juggle" "com.booking" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "com.netflix.mediaclient com.netflix.partner.activation" "com.microsoft.skydrive" "com.opera.browser com.opera.preinstall" "com.spotify.music" "com.einnovation.temu" "cn.wps.moffice_eng"
if "%app_choice%"=="0" goto main_menu
goto third_party_menu

:check_status
set "installed=0"
set "disabled=0"
set "uninstalled=0"
set "total=0"
set "system_exists=0"

for %%p in (%1) do (
    set /a total+=1
    for /f %%i in ('adb shell pm list packages ^| findstr "%%p"') do set /a installed+=1
    if !installed! equ 0 for /f %%i in ('adb shell pm list packages -d ^| findstr "%%p"') do set /a disabled+=1
    if !installed! equ 0 if !disabled! equ 0 for /f %%i in ('adb shell pm list packages -u ^| findstr "%%p"') do (
        set /a uninstalled+=1
        set "system_exists=1"
    )
    if !installed! equ 0 if !disabled! equ 0 if !uninstalled! equ 0 set /a uninstalled+=1
)

if !total! equ !installed! set "%2=[GREEN]Встановлено[NC]"
if !total! equ !disabled! set "%2=[YELLOW]Відключено[NC]"
if !total! equ !uninstalled! if !system_exists! equ 1 set "%2=[RED]Видалено[NC]"
if !total! equ !uninstalled! if !system_exists! equ 0 set "%2=[BLUE]Не встановлено[NC]"
if !installed! gtr 0 if !total! neq !installed! set "%2=[CYAN]Встановлено частково[NC]"

goto :eof

:disable_package
set "is_disabled="
for /f %%i in ('adb shell pm list packages -d ^| findstr "%1"') do set "is_disabled=1"
if defined is_disabled (
    echo [YELLOW]Пакет %1 вже відключено.[NC]
) else (
    for /f "delims=" %%i in ('adb shell pm disable-user --user 0 %1 2^>^&1') do set "output=%%i"
    echo !output! | findstr "disabled-user" >nul
    if !errorlevel! equ 0 (
        echo [GREEN]Успішно відключено: %1[NC]
    ) else (
        echo [RED]Помилка при відключенні %1: !output![NC]
    )
)
goto :eof

:enable_package
set "is_enabled="
for /f %%i in ('adb shell pm list packages ^| findstr "%1"') do (
    for /f %%j in ('adb shell pm list packages -d ^| findstr "%1"') do (set "is_disabled=1") else (set "is_enabled=1")
)
if defined is_enabled (
    echo [YELLOW]Пакет %1 вже увімкнено.[NC]
) else (
    for /f "delims=" %%i in ('adb shell pm enable --user 0 %1 2^>^&1') do set "output=%%i"
    echo !output! | findstr "enabled" >nul
    if !errorlevel! equ 0 (
        echo [GREEN]Успішно увімкнено: %1[NC]
    ) else (
        echo [RED]Помилка при увімкненні %1: !output![NC]
    )
)
goto :eof

:uninstall_package
set "is_uninstalled="
for /f %%i in ('adb shell pm list packages -u ^| findstr "%1"') do (
    for /f %%j in ('adb shell pm list packages ^| findstr "%1"') do (set "is_installed=1") else (set "is_uninstalled=1")
)
if defined is_uninstalled (
    echo [YELLOW]Пакет %1 вже видалено.[NC]
) else (
    for /f "delims=" %%i in ('adb shell pm uninstall --user 0 %1 2^>^&1') do set "output=%%i"
    if "!output!"=="Success" (
        echo [GREEN]Успішно видалено: %1[NC]
    ) else (
        echo [RED]Помилка при видаленні %1: !output![NC]
    )
)
goto :eof

:install_package
set "is_installed="
for /f %%i in ('adb shell pm list packages ^| findstr "%1"') do (
    for /f %%j in ('adb shell pm list packages -d ^| findstr "%1"') do (set "is_disabled=1") else (set "is_installed=1")
)
if defined is_installed (
    echo [YELLOW]Пакет %1 вже встановлено.[NC]
) else (
    for /f "delims=" %%i in ('adb shell pm install-existing --user 0 %1 2^>^&1') do set "output=%%i"
    if "!output!"=="" (
        echo [GREEN]Успішно відновлено: %1[NC]
    ) else if "!output!"=="Failure [INSTALL_FAILED_INVALID_URI]" (
        echo [YELLOW]Пакет %1 не знайдено в системі для відновлення.[NC]
    ) else (
        echo [RED]Помилка при відновленні %1: !output![NC]
    )
)
goto :eof

:action_menu
cls
echo [GREEN]Дія для %1 ("%2")[NC]

set "installed_pkgs="
set "disabled_pkgs="
set "uninstalled_pkgs="
set "not_installed_pkgs="
set "status_output="

for %%p in (%2) do (
    set "pkg_status="
    for /f %%i in ('adb shell pm list packages ^| findstr "%%p"') do set "pkg_status=installed"
    if not defined pkg_status for /f %%i in ('adb shell pm list packages -d ^| findstr "%%p"') do set "pkg_status=disabled"
    if not defined pkg_status for /f %%i in ('adb shell pm list packages -u ^| findstr "%%p"') do (
        for /f %%j in ('adb shell pm list packages ^| findstr "%%p"') do () else (set "pkg_status=uninstalled")
    )
    if not defined pkg_status set "pkg_status=not_installed"
    if "!pkg_status!"=="installed" set "installed_pkgs=!installed_pkgs! %%p"
    if "!pkg_status!"=="disabled" set "disabled_pkgs=!disabled_pkgs! %%p"
    if "!pkg_status!"=="uninstalled" set "uninstalled_pkgs=!uninstalled_pkgs! %%p"
    if "!pkg_status!"=="not_installed" set "not_installed_pkgs=!not_installed_pkgs! %%p"
)

if defined installed_pkgs (
    set "status_output=[GREEN]Встановлено[NC] (!installed_pkgs:~1!)"
)
if defined disabled_pkgs (
    if defined status_output set "status_output=!status_output!, "
    set "status_output=!status_output![YELLOW]Відключено[NC] (!disabled_pkgs:~1!)"
)
if defined uninstalled_pkgs (
    if defined status_output set "status_output=!status_output!, "
    set "status_output=!status_output![RED]Видалено[NC] (!uninstalled_pkgs:~1!)"
)
if defined not_installed_pkgs (
    if defined status_output set "status_output=!status_output!, "
    set "status_output=!status_output![BLUE]Не встановлено[NC] (!not_installed_pkgs:~1!)"
)

echo Статус: !status_output!
echo Рекомендація: %3
echo 1) Видалити
echo 2) Відключити
echo 3) Відновити
echo 4) Увімкнути
echo 0) Повернутися
echo -------------------------
set /p action="Виберіть дію: "

if "!action!"=="1" for %%p in (%2) do call :uninstall_package %%p
if "!action!"=="2" for %%p in (%2) do call :disable_package %%p
if "!action!"=="3" for %%p in (%2) do call :install_package %%p
if "!action!"=="4" for %%p in (%2) do call :enable_package %%p
if "!action!"=="0" goto :%4

pause
goto :%4

:selective_uninstall
cls
echo [GREEN]=== Вибіркове видалення ===[NC]
echo Введіть номери програм через пробіл (наприклад, '1 5 6').
echo Діапазон: 1–%argc%
echo -------------------------
set /p selection="Виберіть програми: "
set "argc=0"
for %%i in (%*) do set /a argc+=1
set "argc=!argc!"
set "index=0"
for %%p in (%*) do (
    set /a index+=1
    if !index! gtr 1 (
        set "pkg[!index!-1]=%%p"
    )
)

for %%n in (!selection!) do (
    set "valid=1"
    if %%n lss 1 set "valid=0"
    if %%n gtr !argc! set "valid=0"
    if !valid! equ 1 (
        for %%p in (!pkg[%%n]!) do call :uninstall_package %%p
    ) else (
        echo [RED]Невірний номер: %%n[NC]
    )
)

pause
goto :%1

:check_all_status
cls
echo [GREEN]=== Перевірка статусу всіх програм ===[NC]
set "index=0"
set "argc=0"
for %%i in (%*) do set /a argc+=1
set "argc=!argc!"
for %%p in (%*) do (
    set /a index+=1
    if !index! gtr 1 (
        set "pkg[!index!-1]=%%p"
        set "name="
        if "%1"=="miui_menu" (
            if !index! equ 2 set "name=GetApps"
            if !index! equ 3 set "name=Mi Browser"
            if !index! equ 4 set "name=Mi Home"
            if !index! equ 5 set "name=Mi Mover"
            if !index! equ 6 set "name=Mi Music"
            if !index! equ 7 set "name=Mi Video"
            if !index! equ 8 set "name=POCO Community"
            if !index! equ 9 set "name=POCO Store"
            if !index! equ 10 set "name=Ігри Xiaomi"
            if !index! equ 11 set "name=Карусель шпалер"
            if !index! equ 12 set "name=Стрічка віджетів MinusScreen"
            if !index! equ 13 set "name=ShareMe"
            if !index! equ 14 set "name=Завантаження"
            if !index! equ 15 set "name=Компас"
            if !index! equ 16 set "name=Очищувач"
            if !index! equ 17 set "name=Сканер QR"
            if !index! equ 18 set "name=Теми"
        )
        if "%1"=="utilities_menu" (
            if !index! equ 2 set "name=Bluetooth MIDI"
            if !index! equ 3 set "name=Device Health Services"
            if !index! equ 4 set "name=MMS служба"
            if !index! equ 5 set "name=Qualcomm Miracast"
            if !index! equ 6 set "name=Qualcomm RCS повідомлення"
            if !index! equ 7 set "name=Quick Apps"
            if !index! equ 8 set "name=TalkBack"
            if !index! equ 9 set "name=Китайські віртуальні картки"
            if !index! equ 10 set "name=Китайський варіант Wi-Fi"
            if !index! equ 11 set "name=Аналітика MIUI"
            if !index! equ 12 set "name=Голосова активація"
            if !index! equ 13 set "name=Китайський оприділяч номера"
            if !index! equ 14 set "name=Звіти про помилки та зворотній зв'язок"
            if !index! equ 15 set "name=Ініціалізація Google"
            if !index! equ 16 set "name=Китайський Mi Pay"
            if !index! equ 17 set "name=Китайський акційний сервіс"
            if !index! equ 18 set "name=Китайський сервіс підтвердження платежів"
            if !index! equ 19 set "name=Логи батареї Catchlog"
            if !index! equ 20 set "name=Меню SIM-карти"
            if !index! equ 21 set "name=Навігаційні жести"
            if !index! equ 22 set "name=Оптимізація MIUI Daemon"
            if !index! equ 23 set "name=Оптимізація процесів"
            if !index! equ 24 set "name=Очікування OK Google"
            if !index! equ 25 set "name=Реклама MIUI"
            if !index! equ 26 set "name=Рекламні закладки"
            if !index! equ 27 set "name=Рекомендації друку Google"
            if !index! equ 28 set "name=Резервна копія у хмарі"
            if !index! equ 29 set "name=Резервне копіювання шпалер"
            if !index! equ 30 set "name=Сенсорний помічник"
            if !index! equ 31 set "name=Служба друку"
            if !index! equ 32 set "name=Стрічка віджетів App vault"
            if !index! equ 33 set "name=Трасування системи"
            if !index! equ 34 set "name=Шрифт Noto Serif"
        )
        if "%1"=="google_menu" (
            if !index! equ 2 set "name=Android Auto"
            if !index! equ 3 set "name=Chrome"
            if !index! equ 4 set "name=Gmail"
            if !index! equ 5 set "name=Google Assistant"
            if !index! equ 6 set "name=Google Duo"
            if !index! equ 7 set "name=Google Files"
            if !index! equ 8 set "name=Google Maps"
            if !index! equ 9 set "name=Google Music"
            if !index! equ 10 set "name=Google One"
            if !index! equ 11 set "name=Google Drive"
            if !index! equ 12 set "name=Google Search"
            if !index! equ 13 set "name=Google Videos"
            if !index! equ 14 set "name=Health Connect"
            if !index! equ 15 set "name=Safety Hub"
            if !index! equ 16 set "name=YouTube"
            if !index! equ 17 set "name=YouTube Music"
            if !index! equ 18 set "name=Цифрове благополуччя"
        )
        if "%1"=="third_party_menu" (
            if !index! equ 2 set "name=Amazon"
            if !index! equ 3 set "name=Block Juggle"
            if !index! equ 4 set "name=Booking"
            if !index! equ 5 set "name=Facebook"
            if !index! equ 6 set "name=Netflix"
            if !index! equ 7 set "name=OneDrive"
            if !index! equ 8 set "name=Opera"
            if !index! equ 9 set "name=Spotify"
            if !index! equ 10 set "name=Temu"
            if !index! equ 11 set "name=WPS Office"
        )
        set "status="
        call :check_status "%%p" status
        echo !index!-1^) !name! ^| Статус: !status!
    )
)
echo -------------------------
pause
goto :%1

:exit
adb kill-server >nul 2>&1
echo [GREEN]До зустрічі![NC]
exit