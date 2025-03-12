#!/bin/bash

export LANG="uk_UA.UTF-8"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

check_adb() {
    if ! command -v adb &> /dev/null; then
        echo -e "${RED}ADB не знайдено. Встановіть його через пакетний менеджер (наприклад, 'sudo pacman -S android-tools' на Arch) або додайте до папки зі скриптом.${NC}"
        exit 1
    fi
}

check_device() {
    adb devices | grep -q device$
    if [ $? -ne 0 ]; then
        echo -e "${RED}Пристрій не підключено або не налаштовано USB-налагодження.${NC}"
        echo "Перевірте:"
        echo "1. Чи увімкнено режим розробника та USB-налагодження."
        echo "2. Чи підключено пристрій через USB."
        echo "3. Чи дозволено доступ до ADB на пристрої."
        read -p "Натисніть Enter для повторної перевірки..." -r
        check_device
    else
        echo -e "${GREEN}Пристрій підключено успішно!${NC}"
        echo "ID пристрою: $(adb devices | grep device$ | awk '{print $1}')"
    fi
}

check_package_status() {
    local packages=$1
    local installed=0
    local disabled=0
    local uninstalled=0
    local total=0
    local system_exists=0

    for pkg in $packages; do
        total=$((total + 1))
        if adb shell pm list packages -u | grep -q "$pkg"; then
            system_exists=1
            if adb shell pm list packages -d | grep -q "$pkg"; then
                disabled=$((disabled + 1))
            elif adb shell pm list packages | grep -q "$pkg"; then
                installed=$((installed + 1))
            else
                uninstalled=$((uninstalled + 1))
            fi
        else
            uninstalled=$((uninstalled + 1))
        fi
    done

    if [ $total -eq $installed ]; then
        echo -e "${GREEN}Встановлено${NC}"
    elif [ $total -eq $disabled ]; then
        echo -e "${YELLOW}Відключено${NC}"
    elif [ $total -eq $uninstalled ] && [ $system_exists -eq 1 ]; then
        echo -e "${RED}Видалено${NC}"
    elif [ $total -eq $uninstalled ]; then
        echo -e "${BLUE}Не встановлено${NC}"
    else
        echo -e "${CYAN}Встановлено частково${NC}"
    fi
}

disable_package() {
    local package=$1
    if adb shell pm list packages -d | grep -q "$package"; then
        echo -e "${YELLOW}Пакет $package вже відключено.${NC}"
    else
        local output=$(adb shell pm disable-user --user 0 "$package" 2>&1)
        if [[ "$output" =~ "disabled-user" ]]; then
            echo -e "${GREEN}Успішно відключено: $package${NC}"
        else
            echo -e "${RED}Помилка при відключенні $package: $output${NC}"
        fi
    fi
}

enable_package() {
    local package=$1
    if adb shell pm list packages | grep -q "$package" && ! adb shell pm list packages -d | grep -q "$package"; then
        echo -e "${YELLOW}Пакет $package вже увімкнено.${NC}"
    else
        local output=$(adb shell pm enable --user 0 "$package" 2>&1)
        if [[ "$output" =~ "enabled" ]]; then
            echo -e "${GREEN}Успішно увімкнено: $package${NC}"
        else
            echo -e "${RED}Помилка при увімкненні $package: $output${NC}"
        fi
    fi
}

uninstall_package() {
    local package=$1
    if adb shell pm list packages -u | grep -q "$package" && ! adb shell pm list packages | grep -q "$package"; then
        echo -e "${YELLOW}Пакет $package вже видалено.${NC}"
    else
        local output=$(adb shell pm uninstall --user 0 "$package" 2>&1)
        if [[ "$output" == "Success" ]]; then
            echo -e "${GREEN}Успішно видалено: $package${NC}"
        else
            echo -e "${RED}Помилка при видаленні $package: $output${NC}"
        fi
    fi
}

install_package() {
    local package=$1
    if adb shell pm list packages | grep -q "$package" && ! adb shell pm list packages -d | grep -q "$package"; then
        echo -e "${YELLOW}Пакет $package вже встановлено.${NC}"
    else
        local output=$(adb shell pm install-existing --user 0 "$package" 2>&1)
        if [[ "$output" =~ "installed" || -z "$output" ]]; then
            echo -e "${GREEN}Успішно відновлено: $package${NC}"
        elif [[ "$output" =~ "doesn't exist" ]]; then
            echo -e "${YELLOW}Пакет $package не знайдено в системі для відновлення.${NC}"
        else
            echo -e "${RED}Помилка при відновленні $package: $output${NC}"
        fi
    fi
}

main_menu() {
    clear
    echo -e "${GREEN}=== MIUI/HyperOS видалення програм від Quinsaiz ===${NC}"
    echo "1) Системні програми MIUI/HyperOS"
    echo "2) Службові утиліти (критичні)"
    echo "3) Програми від Google"
    echo "4) Сторонні додатки"
    echo "0) Вихід"
    echo "-------------------------"
    read -p "Виберіть опцію: " choice

    case $choice in
        1) miui_menu ;;
        2) utilities_menu ;;
        3) google_menu ;;
        4) third_party_menu ;;
        0) adb kill-server; echo -e "${GREEN}До зустрічі!${NC}"; exit 0 ;;
        *) echo -e "${RED}Невірний вибір.${NC}"; sleep 2; main_menu ;;
    esac
}

miui_menu() {
    clear
    echo -e "${GREEN}=== Системні програми MIUI/HyperOS ===${NC}"
    echo "1) GetApps (com.xiaomi.mipicks) - Статус: $(check_package_status com.xiaomi.mipicks)"
    echo "2) Mi Browser (com.mi.globalbrowser) - Статус: $(check_package_status com.mi.globalbrowser)"
    echo "3) Mi Home (com.xiaomi.smarthome) - Статус: $(check_package_status com.xiaomi.smarthome)"
    echo "4) Mi Mover (com.miui.huanji) - Статус: $(check_package_status com.miui.huanji)"
    echo "5) Mi Music (com.miui.player) - Статус: $(check_package_status com.miui.player)"
    echo "6) Mi Video (com.miui.video com.miui.videoplayer) - Статус: $(check_package_status "com.miui.video com.miui.videoplayer")"
    echo "7) POCO Community (com.mi.global.pocobbs) - Статус: $(check_package_status com.mi.global.pocobbs)"
    echo "8) POCO Store (com.mi.global.pocostore) - Статус: $(check_package_status com.mi.global.pocostore)"
    echo "9) Ігри Xiaomi (com.xiaomi.glgm) - Статус: $(check_package_status com.xiaomi.glgm)"
    echo "10) Карусель шпалер (com.miui.android.fashiongallery) - Статус: $(check_package_status com.miui.android.fashiongallery)"
    echo "11) Стрічка віджетів MinusScreen (com.mi.globalminusscreen com.mi.android.globalminusscreen) - Статус: $(check_package_status "com.mi.globalminusscreen com.mi.android.globalminusscreen")"
    echo "0) Повернутися до головного меню"
    echo "-------------------------"
    read -p "Виберіть програму: " app_choice

    case $app_choice in
        1) action_menu "GetApps" "com.xiaomi.mipicks" "Видалити" "miui_menu" ;;
        2) action_menu "Mi Browser" "com.mi.globalbrowser" "Видалити" "miui_menu" ;;
        3) action_menu "Mi Home" "com.xiaomi.smarthome" "Видалити" "miui_menu" ;;
        4) action_menu "Mi Mover" "com.miui.huanji" "Видалити" "miui_menu" ;;
        5) action_menu "Mi Music" "com.miui.player" "Видалити" "miui_menu" ;;
        6) action_menu "Mi Video" "com.miui.video com.miui.videoplayer" "Видалити" "miui_menu" ;;
        7) action_menu "POCO Community" "com.mi.global.pocobbs" "Видалити" "miui_menu" ;;
        8) action_menu "POCO Store" "com.mi.global.pocostore" "Видалити" "miui_menu" ;;
        9) action_menu "Ігри Xiaomi" "com.xiaomi.glgm" "Видалити" "miui_menu" ;;
        10) action_menu "Карусель шпалер" "com.miui.android.fashiongallery" "Видалити" "miui_menu" ;;
        11) action_menu "Стрічка віджетів MinusScreen" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "Видалити" "miui_menu" ;;
        0) main_menu ;;
        *) echo -e "${RED}Невірний вибір.${NC}"; sleep 2; miui_menu ;;
    esac
}

utilities_menu() {
    clear
    echo -e "${GREEN}=== Службові утиліти (критичні) ===${NC}"
    echo "1) Bluetooth MIDI (com.android.bluetoothmidiservice) - Статус: $(check_package_status com.android.bluetoothmidiservice)"
    echo "2) Device Health Services (com.google.android.apps.turbo) - Статус: $(check_package_status com.google.android.apps.turbo)"
    echo "3) MMS служба (com.android.mms.service) - Статус: $(check_package_status com.android.mms.service)"
    echo "4) Qualcomm Miracast (com.qualcomm.atfwd) - Статус: $(check_package_status com.qualcomm.atfwd)"
    echo "5) Qualcomm RCS повідомлення (com.qualcomm.qti.uceShimService) - Статус: $(check_package_status com.qualcomm.qti.uceShimService)"
    echo "6) Quick Apps (com.miui.hybrid com.miui.hybrid.accessory) - Статус: $(check_package_status "com.miui.hybrid com.miui.hybrid.accessory")"
    echo "7) TalkBack (com.google.android.marvin.talkback) - Статус: $(check_package_status com.google.android.marvin.talkback)"
    echo "8) Китайські віртуальні картки (com.miui.vsimcore) - Статус: $(check_package_status com.miui.vsimcore)"
    echo "9) Китайський варіант Wi-Fi (com.wapi.wapicertmanage) - Статус: $(check_package_status com.wapi.wapicertmanage)"
    echo "10) Аналітика MIUI (com.miui.analytics) - Статус: $(check_package_status com.miui.analytics)"
    echo "11) Голосова активація (com.quicinc.voice.activation) - Статус: $(check_package_status com.quicinc.voice.activation)"
    echo "12) Китайський оприділяч номера (com.miui.yellowpage) - Статус: $(check_package_status com.miui.yellowpage)"
    echo "13) Звіти про помилки та зворотній зв'язок (com.miui.bugreport com.miui.miservice) - Статус: $(check_package_status "com.miui.bugreport com.miui.miservice")"
    echo "14) Ініціалізація Google (com.google.android.onetimeinitializer com.google.android.partnersetup) - Статус: $(check_package_status "com.google.android.onetimeinitializer com.google.android.partnersetup")"
    echo "15) Китайський Mi Pay (com.xiaomi.payment com.mipay.wallet.in) - Статус: $(check_package_status "com.xiaomi.payment com.mipay.wallet.in")"
    echo "16) Китайський акційний сервіс (com.xiaomi.mirecycle) - Статус: $(check_package_status com.xiaomi.mirecycle)"
    echo "17) Китайський сервіс підтвердження платежів (com.tencent.soter.soterserver) - Статус: $(check_package_status com.tencent.soter.soterserver)"
    echo "18) Логи батареї Catchlog (com.bsp.catchlog) - Статус: $(check_package_status com.bsp.catchlog)"
    echo "19) Меню SIM-карти (com.android.stk) - Статус: $(check_package_status com.android.stk)"
    echo "20) Навігаційні жести (com.android.internal.systemui.navbar.gestural ...) - Статус: $(check_package_status "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton")"
    echo "21) Оптимізація MIUI Daemon (com.miui.daemon) - Статус: $(check_package_status com.miui.daemon)"
    echo "22) Оптимізація процесів (com.xiaomi.joyose) - Статус: $(check_package_status com.xiaomi.joyose)"
    echo "23) Очікування OK Google (com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle) - Статус: $(check_package_status "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle")"
    echo "24) Реклама MIUI (com.miui.msa.global) - Статус: $(check_package_status com.miui.msa.global)"
    echo "25) Рекламні закладки (com.android.bookmarkprovider com.android.providers.partnerbookmarks) - Статус: $(check_package_status "com.android.bookmarkprovider com.android.providers.partnerbookmarks")"
    echo "26) Рекомендації друку Google (com.google.android.printservice.recommendation) - Статус: $(check_package_status com.google.android.printservice.recommendation)"
    echo "27) Резервна копія у хмарі (com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase) - Статус: $(check_package_status "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase")"
    echo "28) Резервне копіювання шпалер (com.android.wallpaperbackup) - Статус: $(check_package_status com.android.wallpaperbackup)"
    echo "29) Сенсорний помічник (com.miui.touchassistant) - Статус: $(check_package_status com.miui.touchassistant)"
    echo "30) Служба друку (com.android.bips com.android.printspooler) - Статус: $(check_package_status "com.android.bips com.android.printspooler")"
    echo "31) Стрічка віджетів App vault (com.miui.personalassistant) - Статус: $(check_package_status com.miui.personalassistant)"
    echo "32) Трасування системи (com.android.traceur) - Статус: $(check_package_status com.android.traceur)"
    echo "33) Шрифт Noto Serif (com.android.theme.font.notoserifsource) - Статус: $(check_package_status com.android.theme.font.notoserifsource)"
    echo "0) Повернутися до головного меню"
    echo "-------------------------"
    read -p "Виберіть програму: " app_choice

    case $app_choice in
        1) action_menu "Bluetooth MIDI" "com.android.bluetoothmidiservice" "Відключити" "utilities_menu" ;;
        2) action_menu "Device Health Services" "com.google.android.apps.turbo" "Відключити" "utilities_menu" ;;
        3) action_menu "MMS служба" "com.android.mms.service" "Відключити" "utilities_menu" ;;
        4) action_menu "Qualcomm Miracast" "com.qualcomm.atfwd" "Відключити" "utilities_menu" ;;
        5) action_menu "Qualcomm RCS повідомлення" "com.qualcomm.qti.uceShimService" "Відключити" "utilities_menu" ;;
        6) action_menu "Quick Apps" "com.miui.hybrid com.miui.hybrid.accessory" "Відключити" "utilities_menu" ;;
        7) action_menu "TalkBack" "com.google.android.marvin.talkback" "Відключити" "utilities_menu" ;;
        8) action_menu "Китайські віртуальні картки" "com.miui.vsimcore" "Відключити" "utilities_menu" ;;
        9) action_menu "Китайський варіант Wi-Fi" "com.wapi.wapicertmanage" "Відключити" "utilities_menu" ;;
        10) action_menu "Аналітика MIUI" "com.miui.analytics" "Відключити" "utilities_menu" ;;
        11) action_menu "Голосова активація" "com.quicinc.voice.activation" "Відключити" "utilities_menu" ;;
        12) action_menu "Китайський оприділяч номера" "com.miui.yellowpage" "Відключити" "utilities_menu" ;;
        13) action_menu "Звіти про помилки та зворотній зв'язок" "com.miui.bugreport com.miui.miservice" "Відключити" "utilities_menu" ;;
        14) action_menu "Ініціалізація Google" "com.google.android.onetimeinitializer com.google.android.partnersetup" "Відключити" "utilities_menu" ;;
        15) action_menu "Китайський Mi Pay" "com.xiaomi.payment com.mipay.wallet.in" "Відключити" "utilities_menu" ;;
        16) action_menu "Китайський акційний сервіс" "com.xiaomi.mirecycle" "Відключити" "utilities_menu" ;;
        17) action_menu "Китайський сервіс підтвердження платежів" "com.tencent.soter.soterserver" "Відключити" "utilities_menu" ;;
        18) action_menu "Логи батареї Catchlog" "com.bsp.catchlog" "Відключити" "utilities_menu" ;;
        19) action_menu "Меню SIM-карти" "com.android.stk" "Відключити" "utilities_menu" ;;
        20) action_menu "Навігаційні жести" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "Відключити" "utilities_menu" ;;
        21) action_menu "Оптимізація MIUI Daemon" "com.miui.daemon" "Відключити" "utilities_menu" ;;
        22) action_menu "Оптимізація процесів" "com.xiaomi.joyose" "Відключити" "utilities_menu" ;;
        23) action_menu "Очікування OK Google" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "Відключити" "utilities_menu" ;;
        24) action_menu "Реклама MIUI" "com.miui.msa.global" "Відключити" "utilities_menu" ;;
        25) action_menu "Рекламні закладки" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "Відключити" "utilities_menu" ;;
        26) action_menu "Рекомендації друку Google" "com.google.android.printservice.recommendation" "Відключити" "utilities_menu" ;;
        27) action_menu "Резервна копія у хмарі" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "Відключити" "utilities_menu" ;;
        28) action_menu "Резервне копіювання шпалер" "com.android.wallpaperbackup" "Відключити" "utilities_menu" ;;
        29) action_menu "Сенсорний помічник" "com.miui.touchassistant" "Відключити" "utilities_menu" ;;
        30) action_menu "Служба друку" "com.android.bips com.android.printspooler" "Відключити" "utilities_menu" ;;
        31) action_menu "Стрічка віджетів App vault" "com.miui.personalassistant" "Відключити" "utilities_menu" ;;
        32) action_menu "Трасування системи" "com.android.traceur" "Відключити" "utilities_menu" ;;
        33) action_menu "Шрифт Noto Serif" "com.android.theme.font.notoserifsource" "Відключити" "utilities_menu" ;;
        0) main_menu ;;
        *) echo -e "${RED}Невірний вибір.${NC}"; sleep 2; utilities_menu ;;
    esac
}

google_menu() {
    clear
    echo -e "${GREEN}=== Програми від Google ===${NC}"
    echo "1) Android Auto (com.google.android.projection.gearhead) - Статус: $(check_package_status com.google.android.projection.gearhead)"
    echo "2) Chrome (com.android.chrome) - Статус: $(check_package_status com.android.chrome)"
    echo "3) Gmail (com.google.android.gm) - Статус: $(check_package_status com.google.android.gm)"
    echo "4) Google Assistant (com.google.android.apps.googleassistant) - Статус: $(check_package_status com.google.android.apps.googleassistant)"
    echo "5) Google Duo (com.google.android.apps.tachyon) - Статус: $(check_package_status com.google.android.apps.tachyon)"
    echo "6) Google Files (com.google.android.apps.nbu.files) - Статус: $(check_package_status com.google.android.apps.nbu.files)"
    echo "7) Google Maps (com.google.android.apps.maps) - Статус: $(check_package_status com.google.android.apps.maps)"
    echo "8) Google Music (com.google.android.music) - Статус: $(check_package_status com.google.android.music)"
    echo "9) Google One (com.google.android.apps.subscriptions.red) - Статус: $(check_package_status com.google.android.apps.subscriptions.red)"
    echo "10) Google Drive (com.google.android.apps.docs) - Статус: $(check_package_status com.google.android.apps.docs)"
    echo "11) Google Search (com.google.android.googlequicksearchbox) - Статус: $(check_package_status com.google.android.googlequicksearchbox)"
    echo "12) Google Videos (com.google.android.videos) - Статус: $(check_package_status com.google.android.videos)"
    echo "13) Health Connect (com.google.android.apps.healthdata) - Статус: $(check_package_status com.google.android.apps.healthdata)"
    echo "14) Safety Hub (com.google.android.apps.safetyhub) - Статус: $(check_package_status com.google.android.apps.safetyhub)"
    echo "15) YouTube (com.google.android.apps.youtube) - Статус: $(check_package_status com.google.android.apps.youtube)"
    echo "16) YouTube Music (com.google.android.apps.youtube.music) - Статус: $(check_package_status com.google.android.apps.youtube.music)"
    echo "17) Цифрове благополуччя (com.google.android.apps.wellbeing) - Статус: $(check_package_status com.google.android.apps.wellbeing)"
    echo "0) Повернутися до головного меню"
    echo "-------------------------"
    read -p "Виберіть програму: " app_choice

    case $app_choice in
        1) action_menu "Android Auto" "com.google.android.projection.gearhead" "Видалити" "google_menu" ;;
        2) action_menu "Chrome" "com.android.chrome" "Видалити" "google_menu" ;;
        3) action_menu "Gmail" "com.google.android.gm" "Видалити" "google_menu" ;;
        4) action_menu "Google Assistant" "com.google.android.apps.googleassistant" "Видалити" "google_menu" ;;
        5) action_menu "Google Duo" "com.google.android.apps.tachyon" "Видалити" "google_menu" ;;
        6) action_menu "Google Files" "com.google.android.apps.nbu.files" "Видалити" "google_menu" ;;
        7) action_menu "Google Maps" "com.google.android.apps.maps" "Видалити" "google_menu" ;;
        8) action_menu "Google Music" "com.google.android.music" "Видалити" "google_menu" ;;
        9) action_menu "Google One" "com.google.android.apps.subscriptions.red" "Видалити" "google_menu" ;;
        10) action_menu "Google Drive" "com.google.android.apps.docs" "Видалити" "google_menu" ;;
        11) action_menu "Google Search" "com.google.android.googlequicksearchbox" "Видалити" "google_menu" ;;
        12) action_menu "Google Videos" "com.google.android.videos" "Видалити" "google_menu" ;;
        13) action_menu "Health Connect" "com.google.android.apps.healthdata" "Видалити" "google_menu" ;;
        14) action_menu "Safety Hub" "com.google.android.apps.safetyhub" "Видалити" "google_menu" ;;
        15) action_menu "YouTube" "com.google.android.apps.youtube" "Видалити" "google_menu" ;;
        16) action_menu "YouTube Music" "com.google.android.apps.youtube.music" "Видалити" "google_menu" ;;
        17) action_menu "Цифрове благополуччя" "com.google.android.apps.wellbeing" "Видалити" "google_menu" ;;
        0) main_menu ;;
        *) echo -e "${RED}Невірний вибір.${NC}"; sleep 2; google_menu ;;
    esac
}

third_party_menu() {
    clear
    echo -e "${GREEN}=== Сторонні додатки ===${NC}"
    echo "1) Amazon (com.amazon.mShop.android.shopping com.amazon.appmanager) - Статус: $(check_package_status "com.amazon.mShop.android.shopping com.amazon.appmanager")"
    echo "2) Block Juggle (com.block.juggle) - Статус: $(check_package_status com.block.juggle)"
    echo "3) Booking (com.booking) - Статус: $(check_package_status com.booking)"
    echo "4) Facebook (com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana) - Статус: $(check_package_status "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana")"
    echo "5) Netflix (com.netflix.mediaclient com.netflix.partner.activation) - Статус: $(check_package_status "com.netflix.mediaclient com.netflix.partner.activation")"
    echo "6) OneDrive (com.microsoft.skydrive) - Статус: $(check_package_status com.microsoft.skydrive)"
    echo "7) Opera (com.opera.browser com.opera.preinstall) - Статус: $(check_package_status "com.opera.browser com.opera.preinstall")"
    echo "8) Spotify (com.spotify.music) - Статус: $(check_package_status com.spotify.music)"
    echo "9) Temu (com.einnovation.temu) - Статус: $(check_package_status com.einnovation.temu)"
    echo "10) WPS Office (cn.wps.moffice_eng) - Статус: $(check_package_status cn.wps.moffice_eng)"
    echo "0) Повернутися до головного меню"
    echo "-------------------------"
    read -p "Виберіть програму: " app_choice

    case $app_choice in
        1) action_menu "Amazon" "com.amazon.mShop.android.shopping com.amazon.appmanager" "Видалити" "third_party_menu" ;;
        2) action_menu "Block Juggle" "com.block.juggle" "Видалити" "third_party_menu" ;;
        3) action_menu "Booking" "com.booking" "Видалити" "third_party_menu" ;;
        4) action_menu "Facebook" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "Видалити" "third_party_menu" ;;
        5) action_menu "Netflix" "com.netflix.mediaclient com.netflix.partner.activation" "Видалити" "third_party_menu" ;;
        6) action_menu "OneDrive" "com.microsoft.skydrive" "Видалити" "third_party_menu" ;;
        7) action_menu "Opera" "com.opera.browser com.opera.preinstall" "Видалити" "third_party_menu" ;;
        8) action_menu "Spotify" "com.spotify.music" "Видалити" "third_party_menu" ;;
        9) action_menu "Temu" "com.einnovation.temu" "Видалити" "third_party_menu" ;;
        10) action_menu "WPS Office" "cn.wps.moffice_eng" "Видалити" "third_party_menu" ;;
        0) main_menu ;;
        *) echo -e "${RED}Невірний вибір.${NC}"; sleep 2; third_party_menu ;;
    esac
}

action_menu() {
    local name=$1
    local packages=$2
    local recommendation=$3
    local return_menu=$4
    clear
    echo -e "${GREEN}Дія для $name (\"$packages\")${NC}"

    local installed_pkgs=""
    local disabled_pkgs=""
    local uninstalled_pkgs=""
    local not_installed_pkgs=""
    local status_output=""

    for pkg in $packages; do
        if adb shell pm list packages -u | grep -q "$pkg"; then
            if adb shell pm list packages -d | grep -q "$pkg"; then
                disabled_pkgs="$disabled_pkgs $pkg"
            elif adb shell pm list packages | grep -q "$pkg"; then
                installed_pkgs="$installed_pkgs $pkg"
            else
                uninstalled_pkgs="$uninstalled_pkgs $pkg"
            fi
        else
            not_installed_pkgs="$not_installed_pkgs $pkg"
        fi
    done

    if [ -n "$installed_pkgs" ]; then
        status_output="${GREEN}Встановлено${NC} (${installed_pkgs# })"
    fi
    if [ -n "$disabled_pkgs" ]; then
        [ -n "$status_output" ] && status_output="$status_output, "
        status_output="$status_output${YELLOW}Відключено${NC} (${disabled_pkgs# })"
    fi
    if [ -n "$uninstalled_pkgs" ]; then
        [ -n "$status_output" ] && status_output="$status_output, "
        status_output="$status_output${RED}Видалено${NC} (${uninstalled_pkgs# })"
    fi
    if [ -n "$not_installed_pkgs" ]; then
        [ -n "$status_output" ] && status_output="$status_output, "
        status_output="$status_output${BLUE}Не встановлено${NC} (${not_installed_pkgs# })"
    fi

    echo -e "Статус: $status_output"
    echo "Рекомендація: $recommendation"
    echo "1) Відключити"
    echo "2) Увімкнути"
    echo "3) Видалити"
    echo "4) Відновити"
    echo "0) Повернутися"
    echo "-------------------------"
    read -p "Виберіть дію: " action

    case $action in
        1) for pkg in $packages; do disable_package "$pkg"; done ;;
        2) for pkg in $packages; do enable_package "$pkg"; done ;;
        3) for pkg in $packages; do uninstall_package "$pkg"; done ;;
        4) for pkg in $packages; do install_package "$pkg"; done ;;
        0) $return_menu ;;
        *) echo -e "${RED}Невірна дія${NC}" ;;
    esac

    read -p "Натисніть Enter для продовження..." -r
    $return_menu
}

check_adb
adb kill-server > /dev/null 2>&1
adb start-server > /dev/null 2>&1
check_device
echo -e "${GREEN}MIUI/HyperOS видалення програм від Quinsaiz${NC}"
main_menu