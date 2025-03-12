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
for /f "tokens=1" %%a in ('adb devices') do set device=%%a
if "%device%"=="List" (
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
    echo ID: %device%
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

if "%choice%"=="1" goto miui_menu
if "%choice%"=="2" goto utilities_menu
if "%choice%"=="3" goto google_menu
if "%choice%"=="4" goto third_party_menu
if "%choice%"=="0" goto exit
goto main_menu

:miui_menu
cls
echo === Системні програми MIUI/HyperOS ===
call :check_status "com.xiaomi.mipicks" mipicks_status
call :check_status "com.mi.globalbrowser" browser_status
call :check_status "com.xiaomi.smarthome" smarthome_status
call :check_status "com.miui.huanji" huanji_status
call :check_status "com.miui.player" player_status
call :check_status "com.miui.video com.miui.videoplayer" video_status
call :check_status "com.mi.global.pocobbs" pocobbs_status
call :check_status "com.mi.global.pocostore" pocostore_status
call :check_status "com.xiaomi.glgm" glgm_status
call :check_status "com.miui.android.fashiongallery" fashiongallery_status
call :check_status "com.mi.globalminusscreen com.mi.android.globalminusscreen" minusscreen_status
echo 1) GetApps (com.xiaomi.mipicks) - Статус: %mipicks_status%
echo 2) Mi Browser (com.mi.globalbrowser) - Статус: %browser_status%
echo 3) Mi Home (com.xiaomi.smarthome) - Статус: %smarthome_status%
echo 4) Mi Mover (com.miui.huanji) - Статус: %huanji_status%
echo 5) Mi Music (com.miui.player) - Статус: %player_status%
echo 6) Mi Video (com.miui.video com.miui.videoplayer) - Статус: %video_status%
echo 7) POCO Community (com.mi.global.pocobbs) - Статус: %pocobbs_status%
echo 8) POCO Store (com.mi.global.pocostore) - Статус: %pocostore_status%
echo 9) Ігри Xiaomi (com.xiaomi.glgm) - Статус: %glgm_status%
echo 10) Карусель шпалер (com.miui.android.fashiongallery) - Статус: %fashiongallery_status%
echo 11) Стрічка віджетів MinusScreen (com.mi.globalminusscreen com.mi.android.globalminusscreen) - Статус: %minusscreen_status%
echo 0) Повернутися до головного меню
echo -------------------------
set /p app_choice="Виберіть програму: "
if "%app_choice%"=="1" call :action_menu "GetApps" "com.xiaomi.mipicks" "Видалити" "miui_menu"
if "%app_choice%"=="2" call :action_menu "Mi Browser" "com.mi.globalbrowser" "Видалити" "miui_menu"
if "%app_choice%"=="3" call :action_menu "Mi Home" "com.xiaomi.smarthome" "Видалити" "miui_menu"
if "%app_choice%"=="4" call :action_menu "Mi Mover" "com.miui.huanji" "Видалити" "miui_menu"
if "%app_choice%"=="5" call :action_menu "Mi Music" "com.miui.player" "Видалити" "miui_menu"
if "%app_choice%"=="6" call :action_menu "Mi Video" "com.miui.video com.miui.videoplayer" "Видалити" "miui_menu"
if "%app_choice%"=="7" call :action_menu "POCO Community" "com.mi.global.pocobbs" "Видалити" "miui_menu"
if "%app_choice%"=="8" call :action_menu "POCO Store" "com.mi.global.pocostore" "Видалити" "miui_menu"
if "%app_choice%"=="9" call :action_menu "Ігри Xiaomi" "com.xiaomi.glgm" "Видалити" "miui_menu"
if "%app_choice%"=="10" call :action_menu "Карусель шпалер" "com.miui.android.fashiongallery" "Видалити" "miui_menu"
if "%app_choice%"=="11" call :action_menu "Стрічка віджетів MinusScreen" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "Видалити" "miui_menu"
if "%app_choice%"=="0" goto main_menu
goto miui_menu

:utilities_menu
cls
echo === Службові утиліти (критичні) ===
call :check_status "com.android.bluetoothmidiservice" bluetoothmidi_status
call :check_status "com.google.android.apps.turbo" turbo_status
call :check_status "com.android.mms.service" mms_status
call :check_status "com.qualcomm.atfwd" atfwd_status
call :check_status "com.qualcomm.qti.uceShimService" uce_status
call :check_status "com.miui.hybrid com.miui.hybrid.accessory" hybrid_status
call :check_status "com.google.android.marvin.talkback" talkback_status
call :check_status "com.miui.vsimcore" vsimcore_status
call :check_status "com.wapi.wapicertmanage" wapi_status
call :check_status "com.miui.analytics" analytics_status
call :check_status "com.quicinc.voice.activation" voice_status
call :check_status "com.miui.yellowpage" yellowpage_status
call :check_status "com.miui.bugreport com.miui.miservice" bugreport_status
call :check_status "com.google.android.onetimeinitializer com.google.android.partnersetup" onetime_status
call :check_status "com.xiaomi.payment com.mipay.wallet.in" payment_status
call :check_status "com.xiaomi.mirecycle" mirecycle_status
call :check_status "com.tencent.soter.soterserver" soter_status
call :check_status "com.bsp.catchlog" catchlog_status
call :check_status "com.android.stk" stk_status
call :check_status "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" navbar_status
call :check_status "com.miui.daemon" daemon_status
call :check_status "com.xiaomi.joyose" joyose_status
call :check_status "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" hotword_status
call :check_status "com.miui.msa.global" msa_status
call :check_status "com.android.bookmarkprovider com.android.providers.partnerbookmarks" bookmark_status
call :check_status "com.google.android.printservice.recommendation" printservice_status
call :check_status "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" cloud_status
call :check_status "com.android.wallpaperbackup" wallpaperbackup_status
call :check_status "com.miui.touchassistant" touchassistant_status
call :check_status "com.android.bips com.android.printspooler" printspooler_status
call :check_status "com.miui.personalassistant" personalassistant_status
call :check_status "com.android.traceur" traceur_status
call :check_status "com.android.theme.font.notoserifsource" notoserif_status
echo 1) Bluetooth MIDI (com.android.bluetoothmidiservice) - Статус: %bluetoothmidi_status%
echo 2) Device Health Services (com.google.android.apps.turbo) - Статус: %turbo_status%
echo 3) MMS служба (com.android.mms.service) - Статус: %mms_status%
echo 4) Qualcomm Miracast (com.qualcomm.atfwd) - Статус: %atfwd_status%
echo 5) Qualcomm RCS повідомлення (com.qualcomm.qti.uceShimService) - Статус: %uce_status%
echo 6) Quick Apps (com.miui.hybrid com.miui.hybrid.accessory) - Статус: %hybrid_status%
echo 7) TalkBack (com.google.android.marvin.talkback) - Статус: %talkback_status%
echo 8) Китайські віртуальні картки (com.miui.vsimcore) - Статус: %vsimcore_status%
echo 9) Китайський варіант Wi-Fi (com.wapi.wapicertmanage) - Статус: %wapi_status%
echo 10) Аналітика MIUI (com.miui.analytics) - Статус: %analytics_status%
echo 11) Голосова активація (com.quicinc.voice.activation) - Статус: %voice_status%
echo 12) Китайський оприділяч номера (com.miui.yellowpage) - Статус: %yellowpage_status%
echo 13) Звіти про помилки та зворотній зв'язок (com.miui.bugreport com.miui.miservice) - Статус: %bugreport_status%
echo 14) Ініціалізація Google (com.google.android.onetimeinitializer com.google.android.partnersetup) - Статус: %onetime_status%
echo 15) Китайський Mi Pay (com.xiaomi.payment com.mipay.wallet.in) - Статус: %payment_status%
echo 16) Китайський акційний сервіс (com.xiaomi.mirecycle) - Статус: %mirecycle_status%
echo 17) Китайський сервіс підтвердження платежів (com.tencent.soter.soterserver) - Статус: %soter_status%
echo 18) Логи батареї Catchlog (com.bsp.catchlog) - Статус: %catchlog_status%
echo 19) Меню SIM-карти (com.android.stk) - Статус: %stk_status%
echo 20) Навігаційні жести (com.android.internal.systemui.navbar.gestural ...) - Статус: %navbar_status%
echo 21) Оптимізація MIUI Daemon (com.miui.daemon) - Статус: %daemon_status%
echo 22) Оптимізація процесів (com.xiaomi.joyose) - Статус: %joyose_status%
echo 23) Очікування OK Google (com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle) - Статус: %hotword_status%
echo 24) Реклама MIUI (com.miui.msa.global) - Статус: %msa_status%
echo 25) Рекламні закладки (com.android.bookmarkprovider com.android.providers.partnerbookmarks) - Статус: %bookmark_status%
echo 26) Рекомендації друку Google (com.google.android.printservice.recommendation) - Статус: %printservice_status%
echo 27) Резервна копія у хмарі (com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase) - Статус: %cloud_status%
echo 28) Резервне копіювання шпалер (com.android.wallpaperbackup) - Статус: %wallpaperbackup_status%
echo 29) Сенсорний помічник (com.miui.touchassistant) - Статус: %touchassistant_status%
echo 30) Служба друку (com.android.bips com.android.printspooler) - Статус: %printspooler_status%
echo 31) Стрічка віджетів App vault (com.miui.personalassistant) - Статус: %personalassistant_status%
echo 32) Трасування системи (com.android.traceur) - Статус: %traceur_status%
echo 33) Шрифт Noto Serif (com.android.theme.font.notoserifsource) - Статус: %notoserif_status%
echo 0) Повернутися до головного меню
echo -------------------------
set /p app_choice="Виберіть програму: "
if "%app_choice%"=="1" call :action_menu "Bluetooth MIDI" "com.android.bluetoothmidiservice" "Відключити" "utilities_menu"
if "%app_choice%"=="2" call :action_menu "Device Health Services" "com.google.android.apps.turbo" "Відключити" "utilities_menu"
if "%app_choice%"=="3" call :action_menu "MMS служба" "com.android.mms.service" "Відключити" "utilities_menu"
if "%app_choice%"=="4" call :action_menu "Qualcomm Miracast" "com.qualcomm.atfwd" "Відключити" "utilities_menu"
if "%app_choice%"=="5" call :action_menu "Qualcomm RCS повідомлення" "com.qualcomm.qti.uceShimService" "Відключити" "utilities_menu"
if "%app_choice%"=="6" call :action_menu "Quick Apps" "com.miui.hybrid com.miui.hybrid.accessory" "Відключити" "utilities_menu"
if "%app_choice%"=="7" call :action_menu "TalkBack" "com.google.android.marvin.talkback" "Відключити" "utilities_menu"
if "%app_choice%"=="8" call :action_menu "Китайські віртуальні картки" "com.miui.vsimcore" "Відключити" "utilities_menu"
if "%app_choice%"=="9" call :action_menu "Китайський варіант Wi-Fi" "com.wapi.wapicertmanage" "Відключити" "utilities_menu"
if "%app_choice%"=="10" call :action_menu "Аналітика MIUI" "com.miui.analytics" "Відключити" "utilities_menu"
if "%app_choice%"=="11" call :action_menu "Голосова активація" "com.quicinc.voice.activation" "Відключити" "utilities_menu"
if "%app_choice%"=="12" call :action_menu "Китайський оприділяч номера" "com.miui.yellowpage" "Відключити" "utilities_menu"
if "%app_choice%"=="13" call :action_menu "Звіти про помилки та зворотній зв'язок" "com.miui.bugreport com.miui.miservice" "Відключити" "utilities_menu"
if "%app_choice%"=="14" call :action_menu "Ініціалізація Google" "com.google.android.onetimeinitializer com.google.android.partnersetup" "Відключити" "utilities_menu"
if "%app_choice%"=="15" call :action_menu "Китайський Mi Pay" "com.xiaomi.payment com.mipay.wallet.in" "Відключити" "utilities_menu"
if "%app_choice%"=="16" call :action_menu "Китайський акційний сервіс" "com.xiaomi.mirecycle" "Відключити" "utilities_menu"
if "%app_choice%"=="17" call :action_menu "Китайський сервіс підтвердження платежів" "com.tencent.soter.soterserver" "Відключити" "utilities_menu"
if "%app_choice%"=="18" call :action_menu "Логи батареї Catchlog" "com.bsp.catchlog" "Відключити" "utilities_menu"
if "%app_choice%"=="19" call :action_menu "Меню SIM-карти" "com.android.stk" "Відключити" "utilities_menu"
if "%app_choice%"=="20" call :action_menu "Навігаційні жести" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "Відключити" "utilities_menu"
if "%app_choice%"=="21" call :action_menu "Оптимізація MIUI Daemon" "com.miui.daemon" "Відключити" "utilities_menu"
if "%app_choice%"=="22" call :action_menu "Оптимізація процесів" "com.xiaomi.joyose" "Відключити" "utilities_menu"
if "%app_choice%"=="23" call :action_menu "Очікування OK Google" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "Відключити" "utilities_menu"
if "%app_choice%"=="24" call :action_menu "Реклама MIUI" "com.miui.msa.global" "Відключити" "utilities_menu"
if "%app_choice%"=="25" call :action_menu "Рекламні закладки" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "Відключити" "utilities_menu"
if "%app_choice%"=="26" call :action_menu "Рекомендації друку Google" "com.google.android.printservice.recommendation" "Відключити" "utilities_menu"
if "%app_choice%"=="27" call :action_menu "Резервна копія у хмарі" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "Відключити" "utilities_menu"
if "%app_choice%"=="28" call :action_menu "Резервне копіювання шпалер" "com.android.wallpaperbackup" "Відключити" "utilities_menu"
if "%app_choice%"=="29" call :action_menu "Сенсорний помічник" "com.miui.touchassistant" "Відключити" "utilities_menu"
if "%app_choice%"=="30" call :action_menu "Служба друку" "com.android.bips com.android.printspooler" "Відключити" "utilities_menu"
if "%app_choice%"=="31" call :action_menu "Стрічка віджетів App vault" "com.miui.personalassistant" "Відключити" "utilities_menu"
if "%app_choice%"=="32" call :action_menu "Трасування системи" "com.android.traceur" "Відключити" "utilities_menu"
if "%app_choice%"=="33" call :action_menu "Шрифт Noto Serif" "com.android.theme.font.notoserifsource" "Відключити" "utilities_menu"
if "%app_choice%"=="0" goto main_menu
goto utilities_menu

:google_menu
cls
echo === Програми від Google ===
call :check_status "com.google.android.projection.gearhead" auto_status
call :check_status "com.android.chrome" chrome_status
call :check_status "com.google.android.gm" gmail_status
call :check_status "com.google.android.apps.googleassistant" assistant_status
call :check_status "com.google.android.apps.tachyon" duo_status
call :check_status "com.google.android.apps.nbu.files" files_status
call :check_status "com.google.android.apps.maps" maps_status
call :check_status "com.google.android.music" music_status
call :check_status "com.google.android.apps.subscriptions.red" one_status
call :check_status "com.google.android.apps.docs" drive_status
call :check_status "com.google.android.googlequicksearchbox" search_status
call :check_status "com.google.android.videos" videos_status
call :check_status "com.google.android.apps.healthdata" health_status
call :check_status "com.google.android.apps.safetyhub" safetyhub_status
call :check_status "com.google.android.apps.youtube" youtube_status
call :check_status "com.google.android.apps.youtube.music" ytmusic_status
call :check_status "com.google.android.apps.wellbeing" wellbeing_status
echo 1) Android Auto (com.google.android.projection.gearhead) - Статус: %auto_status%
echo 2) Chrome (com.android.chrome) - Статус: %chrome_status%
echo 3) Gmail (com.google.android.gm) - Статус: %gmail_status%
echo 4) Google Assistant (com.google.android.apps.googleassistant) - Статус: %assistant_status%
echo 5) Google Duo (com.google.android.apps.tachyon) - Статус: %duo_status%
echo 6) Google Files (com.google.android.apps.nbu.files) - Статус: %files_status%
echo 7) Google Maps (com.google.android.apps.maps) - Статус: %maps_status%
echo 8) Google Music (com.google.android.music) - Статус: %music_status%
echo 9) Google One (com.google.android.apps.subscriptions.red) - Статус: %one_status%
echo 10) Google Drive (com.google.android.apps.docs) - Статус: %drive_status%
echo 11) Google Search (com.google.android.googlequicksearchbox) - Статус: %search_status%
echo 12) Google Videos (com.google.android.videos) - Статус: %videos_status%
echo 13) Health Connect (com.google.android.apps.healthdata) - Статус: %health_status%
echo 14) Safety Hub (com.google.android.apps.safetyhub) - Статус: %safetyhub_status%
echo 15) YouTube (com.google.android.apps.youtube) - Статус: %youtube_status%
echo 16) YouTube Music (com.google.android.apps.youtube.music) - Статус: %ytmusic_status%
echo 17) Цифрове благополуччя (com.google.android.apps.wellbeing) - Статус: %wellbeing_status%
echo 0) Повернутися до головного меню
echo -------------------------
set /p app_choice="Виберіть програму: "
if "%app_choice%"=="1" call :action_menu "Android Auto" "com.google.android.projection.gearhead" "Видалити" "google_menu"
if "%app_choice%"=="2" call :action_menu "Chrome" "com.android.chrome" "Видалити" "google_menu"
if "%app_choice%"=="3" call :action_menu "Gmail" "com.google.android.gm" "Видалити" "google_menu"
if "%app_choice%"=="4" call :action_menu "Google Assistant" "com.google.android.apps.googleassistant" "Видалити" "google_menu"
if "%app_choice%"=="5" call :action_menu "Google Duo" "com.google.android.apps.tachyon" "Видалити" "google_menu"
if "%app_choice%"=="6" call :action_menu "Google Files" "com.google.android.apps.nbu.files" "Видалити" "google_menu"
if "%app_choice%"=="7" call :action_menu "Google Maps" "com.google.android.apps.maps" "Видалити" "google_menu"
if "%app_choice%"=="8" call :action_menu "Google Music" "com.google.android.music" "Видалити" "google_menu"
if "%app_choice%"=="9" call :action_menu "Google One" "com.google.android.apps.subscriptions.red" "Видалити" "google_menu"
if "%app_choice%"=="10" call :action_menu "Google Drive" "com.google.android.apps.docs" "Видалити" "google_menu"
if "%app_choice%"=="11" call :action_menu "Google Search" "com.google.android.googlequicksearchbox" "Видалити" "google_menu"
if "%app_choice%"=="12" call :action_menu "Google Videos" "com.google.android.videos" "Видалити" "google_menu"
if "%app_choice%"=="13" call :action_menu "Health Connect" "com.google.android.apps.healthdata" "Видалити" "google_menu"
if "%app_choice%"=="14" call :action_menu "Safety Hub" "com.google.android.apps.safetyhub" "Видалити" "google_menu"
if "%app_choice%"=="15" call :action_menu "YouTube" "com.google.android.apps.youtube" "Видалити" "google_menu"
if "%app_choice%"=="16" call :action_menu "YouTube Music" "com.google.android.apps.youtube.music" "Видалити" "google_menu"
if "%app_choice%"=="17" call :action_menu "Цифрове благополуччя" "com.google.android.apps.wellbeing" "Видалити" "google_menu"
if "%app_choice%"=="0" goto main_menu
goto google_menu

:third_party_menu
cls
echo === Сторонні додатки ===
call :check_status "com.amazon.mShop.android.shopping com.amazon.appmanager" amazon_status
call :check_status "com.block.juggle" juggle_status
call :check_status "com.booking" booking_status
call :check_status "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" fb_status
call :check_status "com.netflix.mediaclient com.netflix.partner.activation" netflix_status
call :check_status "com.microsoft.skydrive" skydrive_status
call :check_status "com.opera.browser com.opera.preinstall" opera_status
call :check_status "com.spotify.music" spotify_status
call :check_status "com.einnovation.temu" temu_status
call :check_status "cn.wps.moffice_eng" wps_status
echo 1) Amazon (com.amazon.mShop.android.shopping com.amazon.appmanager) - Статус: %amazon_status%
echo 2) Block Juggle (com.block.juggle) - Статус: %juggle_status%
echo 3) Booking.com (com.booking) - Статус: %booking_status%
echo 4) Facebook (com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana) - Статус: %fb_status%
echo 5) Netflix (com.netflix.mediaclient com.netflix.partner.activation) - Статус: %netflix_status%
echo 6) OneDrive (com.microsoft.skydrive) - Статус: %skydrive_status%
echo 7) Opera (com.opera.browser com.opera.preinstall) - Статус: %opera_status%
echo 8) Spotify (com.spotify.music) - Статус: %spotify_status%
echo 9) Temu (com.einnovation.temu) - Статус: %temu_status%
echo 10) WPS Office (cn.wps.moffice_eng) - Статус: %wps_status%
echo 0) Повернутися до головного меню
echo -------------------------
set /p app_choice="Виберіть програму: "
if "%app_choice%"=="1" call :action_menu "Amazon" "com.amazon.mShop.android.shopping com.amazon.appmanager" "Видалити" "third_party_menu"
if "%app_choice%"=="2" call :action_menu "Block Juggle" "com.block.juggle" "Видалити" "third_party_menu"
if "%app_choice%"=="3" call :action_menu "Booking.com" "com.booking" "Видалити" "third_party_menu"
if "%app_choice%"=="4" call :action_menu "Facebook" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "Видалити" "third_party_menu"
if "%app_choice%"=="5" call :action_menu "Netflix" "com.netflix.mediaclient com.netflix.partner.activation" "Видалити" "third_party_menu"
if "%app_choice%"=="6" call :action_menu "OneDrive" "com.microsoft.skydrive" "Видалити" "third_party_menu"
if "%app_choice%"=="7" call :action_menu "Opera" "com.opera.browser com.opera.preinstall" "Видалити" "third_party_menu"
if "%app_choice%"=="8" call :action_menu "Spotify" "com.spotify.music" "Видалити" "third_party_menu"
if "%app_choice%"=="9" call :action_menu "Temu" "com.einnovation.temu" "Видалити" "third_party_menu"
if "%app_choice%"=="10" call :action_menu "WPS Office" "cn.wps.moffice_eng" "Видалити" "third_party_menu"
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
    if not defined installed for /f %%i in ('adb shell pm list packages -d ^| findstr "%%p"') do set /a disabled+=1
    if not defined installed if not defined disabled for /f %%i in ('adb shell pm list packages -u ^| findstr "%%p"') do (
        set /a uninstalled+=1
        set "system_exists=1"
    )
    if not defined installed if not defined disabled if not defined uninstalled set /a uninstalled+=1
)

if %total% equ %installed% set "%2=[GREEN]Встановлено[NC]"
if %total% equ %disabled% set "%2=[YELLOW]Відключено[NC]"
if %total% equ %uninstalled% if %system_exists% equ 1 set "%2=[RED]Видалено[NC]"
if %total% equ %uninstalled% if %system_exists% equ 0 set "%2=[BLUE]Не встановлено[NC]"
if %installed% gtr 0 if %total% neq %installed% set "%2=[CYAN]Встановлено частково[NC]"

goto :eof

:disable_package
set "is_disabled="
for /f %%i in ('adb shell pm list packages -d ^| findstr "%1"') do set "is_disabled=1"
if defined is_disabled (
    echo [YELLOW]Пакет %1 вже відключено.[NC]
) else (
    for /f "delims=" %%i in ('adb shell pm disable-user --user 0 %1 2^>^&1') do set "output=%%i"
    if "!output!"=="Package %1 new state: disabled-user" (
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
    if "!output!"=="Package %1 new state: enabled" (
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
    if "!output!"=="Package %1 installed for user: 0" (
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
echo [GREEN]Дія для %1 (%2)[NC]

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
echo 1) Відключити
echo 2) Увімкнути
echo 3) Видалити
echo 4) Відновити
echo 0) Повернутися
echo -------------------------
set /p action="Виберіть дію: "

if "!action!"=="1" for %%p in (%2) do call :disable_package %%p
if "!action!"=="2" for %%p in (%2) do call :enable_package %%p
if "!action!"=="3" for %%p in (%2) do call :uninstall_package %%p
if "!action!"=="4" for %%p in (%2) do call :install_package %%p
if "!action!"=="0" goto :%4

pause
goto :%4

:exit
adb kill-server >nul 2>&1
echo [GREEN]До зустрічі![NC]
exit