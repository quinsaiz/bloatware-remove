#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

check_adb() {
    if [ -f "./adb" ] && [ -x "./adb" ]; then
        ADB="./adb"
        echo -e "${GREEN}Using local ADB binary from script directory.${NC}"
    elif command -v adb &> /dev/null; then
        ADB="adb"
        echo -e "${GREEN}Using system-wide ADB.${NC}"
    else
        echo -e "${RED}ADB not found. Install it via 'sudo pacman -S android-tools' or place an ADB binary in the script folder.${NC}"
        exit 1
    fi
}

check_device() {
    if [ "$ADB" = "./adb" ]; then
        $ADB devices | grep -q device$
    else
        $ADB devices | grep -q device$
        if [ $? -ne 0 ]; then
            echo -e "${YELLOW}ADB requires sudo to detect devices. Attempting with sudo...${NC}"
            sudo $ADB devices | grep -q device$
        fi
    fi

    if [ $? -ne 0 ]; then
        echo -e "${RED}Device is not connected or USB debugging is not configured.${NC}"
        echo "Check:"
        echo "1. Whether developer mode and USB debugging are enabled."
        echo "2. Whether the device is connected via USB."
        echo "3. ADB access is allowed on the device."
        read -p "Press Enter to retry..." -r
        check_device
    else
        echo -e "${GREEN}Device connected successfully!${NC}"
        if [ "$ADB" = "./adb" ]; then
            echo "Device ID: $($ADB devices | grep device$ | awk '{print $1}')"
        else
            echo "Device ID: $(sudo $ADB devices | grep device$ | awk '{print $1}')"
        fi
    fi
}

main_menu() {
    clear
    echo -e "${GREEN}=== MIUI/HyperOS bloatware app removal script by Quinsaiz ===${NC}"
    echo "1) MIUI/HyperOS system apps"
    echo "2) System utility"
    echo "3) Google apps"
    echo "4) Third-party apps"
    echo "99) Restore Xiaomi Dialer & Messages"
    echo "0) Exit"
    echo "-------------------------"
    read -p "Select an option: " choice

    case $choice in
        1) miui_menu ;;
        2) utilities_menu ;;
        3) google_menu ;;
        4) third_party_menu ;;
        99) restore_miui_dialer_messages ;;
        0) $ADB kill-server; echo -e "${GREEN}Good luck!${NC}"; exit 0 ;;
        *) echo -e "${RED}Wrong choice.${NC}"; sleep 1; main_menu ;;
    esac
}

miui_menu() {
    clear
    echo -e "${GREEN}=== MIUI/HyperOS system apps ===${NC}"
    echo "1) Cleaner (com.miui.cleaner)"
    echo "2) Compass (com.miui.compass)"
    echo "3) GetApps (com.xiaomi.mipicks)"
    echo "4) Mi Browser (com.mi.globalbrowser)"
    echo "5) Mi Home (com.xiaomi.smarthome)"
    echo "6) Mi Mover (com.miui.huanji)"
    echo "7) Mi Music (com.miui.player)"
    echo "8) Mi Video (com.miui.video com.miui.videoplayer)"
    echo "9) MinusScreen Widget (com.mi.globalminusscreen com.mi.android.globalminusscreen)"
    echo "10) POCO Store & Community (com.mi.global.pocostore com.mi.global.pocobbs)"
    echo "11) QR Scanner (com.xiaomi.scanner)"
    echo "12) ShareMe (com.xiaomi.midrop)"
    echo "13) Downloads (com.android.providers.downloads.ui)"
    echo "14) Themes (com.android.thememanager)"
    echo "15) Wallpaper Carousel (com.miui.android.fashiongallery)"
    echo "16) Xiaomi Games (com.xiaomi.glgm)"
    echo "98) Uninstall selectively"
    echo "99) Check status of apps"
    echo "0) Return to main menu"
    echo "-------------------------"
    read -p "Select an app: " app_choice

    case $app_choice in
        1) action_menu "Cleaner" "com.miui.cleaner" "Uninstall" "miui_menu" ;;
        2) action_menu "Compass" "com.miui.compass" "Uninstall" "miui_menu" ;;
        3) action_menu "GetApps" "com.xiaomi.mipicks" "Uninstall" "miui_menu" ;;
        4) action_menu "Mi Browser" "com.mi.globalbrowser" "Uninstall" "miui_menu" ;;
        5) action_menu "Mi Home" "com.xiaomi.smarthome" "Uninstall" "miui_menu" ;;
        6) action_menu "Mi Mover" "com.miui.huanji" "Uninstall" "miui_menu" ;;
        7) action_menu "Mi Music" "com.miui.player" "Uninstall" "miui_menu" ;;
        8) action_menu "Mi Video" "com.miui.video com.miui.videoplayer" "Uninstall" "miui_menu" ;;
        9) action_menu "MinusScreen Widget" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "Uninstall" "miui_menu" ;;
        10) action_menu "POCO Store & Community" "com.mi.global.pocostore com.mi.global.pocobbs" "Uninstall" "miui_menu" ;;
        11) action_menu "QR Scanner" "com.xiaomi.scanner" "Uninstall" "miui_menu" ;;
        12) action_menu "ShareMe" "com.xiaomi.midrop" "Uninstall" "miui_menu" ;;
        13) action_menu "Downloads" "com.android.providers.downloads.ui" "Uninstall" "miui_menu" ;;
        14) action_menu "Themes" "com.android.thememanager" "Uninstall" "miui_menu" ;;
        15) action_menu "Wallpaper Carousel" "com.miui.android.fashiongallery" "Uninstall" "miui_menu" ;;
        16) action_menu "Xiaomi Games" "com.xiaomi.glgm" "Uninstall" "miui_menu" ;;
        98) selective_uninstall "miui_menu" "com.miui.cleaner" "com.miui.compass" "com.xiaomi.mipicks" "com.mi.globalbrowser" "com.xiaomi.smarthome" "com.miui.huanji" "com.miui.player" "com.miui.video com.miui.videoplayer" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "com.mi.global.pocostore com.mi.global.pocobbs" "com.xiaomi.scanner" "com.xiaomi.midrop" "com.android.providers.downloads.ui" "com.android.thememanager" "com.miui.android.fashiongallery" "com.xiaomi.glgm" ;;
        99) check_all_status "miui_menu" "com.miui.cleaner" "com.miui.compass" "com.xiaomi.mipicks" "com.mi.globalbrowser" "com.xiaomi.smarthome" "com.miui.huanji" "com.miui.player" "com.miui.video com.miui.videoplayer" "com.mi.globalminusscreen com.mi.android.globalminusscreen" "com.mi.global.pocostore com.mi.global.pocobbs" "com.xiaomi.scanner" "com.xiaomi.midrop" "com.android.providers.downloads.ui" "com.android.thememanager" "com.miui.android.fashiongallery" "com.xiaomi.glgm" ;;
        0) main_menu ;;
        *) echo -e "${RED}Wrong choice.${NC}"; sleep 1; miui_menu ;;
    esac
}

utilities_menu() {
    clear
    echo -e "${GREEN}=== System utility ===${NC}"
    echo "1) Ad Bookmarks (com.android.bookmarkprovider com.android.providers.partnerbookmarks)"
    echo "2) Battery Logs Catchlog (com.bsp.catchlog)"
    echo "3) Bluetooth MIDI (com.android.bluetoothmidiservice)"
    echo "4) Cloud Backup (com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase)"
    echo "5) Google One Time Initialization (com.google.android.onetimeinitializer com.google.android.partnersetup)"
    echo "6) Google Print Recommendations (com.google.android.printservice.recommendation)"
    echo "7) MIUI Ads (com.miui.msa.global)"
    echo "8) MIUI Analytics (com.miui.analytics)"
    echo "9) MIUI Daemon (com.miui.daemon)"
    echo "10) MMS Service (com.android.mms.service)"
    echo "11) Navigation Gestures (com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton)"
    echo "12) Noto Serif Font (com.android.theme.font.notoserifsource)"
    echo "13) OK Google Detection (com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle)"
    echo "14) Print Service (com.android.bips com.android.printspooler)"
    echo "15) Quick Apps (com.miui.hybrid com.miui.hybrid.accessory)"
    echo "16) SIM Card Menu (com.android.stk)"
    echo "17) System Tracing (com.android.traceur)"
    echo "18) TalkBack (com.google.android.marvin.talkback)"
    echo "19) Touch Assistant (com.miui.touchassistant)"
    echo "20) Voice Activation (com.quicinc.voice.activation)"
    echo "21) Wallpaper Backup (com.android.wallpaperbackup)"
    echo "22) App Vault Widget (com.miui.personalassistant)"
    echo "23) Bug Reports & Feedback (com.miui.bugreport com.miui.miservice)"
    echo "24) Chinese Caller ID (com.miui.yellowpage)"
    echo "25) Chinese Mi Pay (com.xiaomi.payment com.mipay.wallet.in)"
    echo "26) Chinese Payment Verification Service (com.tencent.soter.soterserver)"
    echo "27) Chinese Promo Service (com.xiaomi.mirecycle)"
    echo "28) Chinese Virtual Cards (com.miui.vsimcore)"
    echo "29) Chinese Wi-Fi Variant (com.wapi.wapicertmanage)"
    echo "30) Device Health Services (com.google.android.apps.turbo)"
    echo "31) Interconnectivity & Services (com.milink.service com.xiaomi.mirror)"
    echo "32) Joyose (com.xiaomi.joyose)"
    echo "33) Qualcomm Miracast (com.qualcomm.atfwd)"
    echo "34) Qualcomm RCS (com.qualcomm.qti.uceShimService)"
    echo "98) Uninstall selectively"
    echo "99) Check status of apps"
    echo "0) Return to main menu"
    echo "-------------------------"
    read -p "Select an app: " app_choice

    case $app_choice in
        1) action_menu "Ad Bookmarks" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "Disable" "utilities_menu" ;;
        2) action_menu "Battery Logs Catchlog" "com.bsp.catchlog" "Disable" "utilities_menu" ;;
        3) action_menu "Bluetooth MIDI" "com.android.bluetoothmidiservice" "Disable" "utilities_menu" ;;
        4) action_menu "Cloud Backup" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "Disable" "utilities_menu" ;;
        5) action_menu "Google One Time Initialization" "com.google.android.onetimeinitializer com.google.android.partnersetup" "Disable" "utilities_menu" ;;
        6) action_menu "Google Print Recommendations" "com.google.android.printservice.recommendation" "Disable" "utilities_menu" ;;
        7) action_menu "MIUI Ads" "com.miui.msa.global" "Disable" "utilities_menu" ;;
        8) action_menu "MIUI Analytics" "com.miui.analytics" "Disable" "utilities_menu" ;;
        9) action_menu "MIUI Daemon" "com.miui.daemon" "Disable" "utilities_menu" ;;
        10) action_menu "MMS Service" "com.android.mms.service" "Disable" "utilities_menu" ;;
        11) action_menu "Navigation Gestures" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "Disable" "utilities_menu" ;;
        12) action_menu "Noto Serif Font" "com.android.theme.font.notoserifsource" "Disable" "utilities_menu" ;;
        13) action_menu "OK Google Detection" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "Disable" "utilities_menu" ;;
        14) action_menu "Print Service" "com.android.bips com.android.printspooler" "Disable" "utilities_menu" ;;
        15) action_menu "Quick Apps" "com.miui.hybrid com.miui.hybrid.accessory" "Disable" "utilities_menu" ;;
        16) action_menu "SIM Card Menu" "com.android.stk" "Disable" "utilities_menu" ;;
        17) action_menu "System Tracing" "com.android.traceur" "Disable" "utilities_menu" ;;
        18) action_menu "TalkBack" "com.google.android.marvin.talkback" "Disable" "utilities_menu" ;;
        19) action_menu "Touch Assistant" "com.miui.touchassistant" "Disable" "utilities_menu" ;;
        20) action_menu "Voice Activation" "com.quicinc.voice.activation" "Disable" "utilities_menu" ;;
        21) action_menu "Wallpaper Backup" "com.android.wallpaperbackup" "Disable" "utilities_menu" ;;
        22) action_menu "App Vault Widget" "com.miui.personalassistant" "Disable" "utilities_menu" ;;
        23) action_menu "Bug Reports & Feedback" "com.miui.bugreport com.miui.miservice" "Disable" "utilities_menu" ;;
        24) action_menu "Chinese Caller ID" "com.miui.yellowpage" "Disable" "utilities_menu" ;;
        25) action_menu "Chinese Mi Pay" "com.xiaomi.payment com.mipay.wallet.in" "Disable" "utilities_menu" ;;
        26) action_menu "Chinese Payment Verification Service" "com.tencent.soter.soterserver" "Disable" "utilities_menu" ;;
        27) action_menu "Chinese Promo Service" "com.xiaomi.mirecycle" "Disable" "utilities_menu" ;;
        28) action_menu "Chinese Virtual Cards" "com.miui.vsimcore" "Disable" "utilities_menu" ;;
        29) action_menu "Chinese Wi-Fi Variant" "com.wapi.wapicertmanage" "Disable" "utilities_menu" ;;
        30) action_menu "Device Health Services" "com.google.android.apps.turbo" "Disable" "utilities_menu" ;;
        31) action_menu "Interconnectivity & Services" "com.milink.service com.xiaomi.mirror" "Disable" "utilities_menu" ;;
        32) action_menu "Joyose" "com.xiaomi.joyose" "Disable" "utilities_menu" ;;
        33) action_menu "Qualcomm Miracast" "com.qualcomm.atfwd" "Disable" "utilities_menu" ;;
        34) action_menu "Qualcomm RCS" "com.qualcomm.qti.uceShimService" "Disable" "utilities_menu" ;;
        98) selective_uninstall "utilities_menu" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "com.bsp.catchlog" "com.android.bluetoothmidiservice" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "com.google.android.onetimeinitializer com.google.android.partnersetup" "com.google.android.printservice.recommendation" "com.miui.msa.global" "com.miui.analytics" "com.miui.daemon" "com.android.mms.service" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "com.android.theme.font.notoserifsource" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "com.android.bips com.android.printspooler" "com.miui.hybrid com.miui.hybrid.accessory" "com.android.stk" "com.android.traceur" "com.google.android.marvin.talkback" "com.miui.touchassistant" "com.quicinc.voice.activation" "com.android.wallpaperbackup" "com.miui.personalassistant" "com.miui.bugreport com.miui.miservice" "com.miui.yellowpage" "com.xiaomi.payment com.mipay.wallet.in" "com.tencent.soter.soterserver" "com.xiaomi.mirecycle" "com.miui.vsimcore" "com.wapi.wapicertmanage" "com.google.android.apps.turbo" "com.milink.service com.xiaomi.mirror" "com.xiaomi.joyose" "com.qualcomm.atfwd" "com.qualcomm.qti.uceShimService" ;;
        99) check_all_status "utilities_menu" "com.android.bookmarkprovider com.android.providers.partnerbookmarks" "com.bsp.catchlog" "com.android.bluetoothmidiservice" "com.miui.cloudbackup com.miui.cloudservice com.miui.cloudservice.sysbase" "com.google.android.onetimeinitializer com.google.android.partnersetup" "com.google.android.printservice.recommendation" "com.miui.msa.global" "com.miui.analytics" "com.miui.daemon" "com.android.mms.service" "com.android.internal.systemui.navbar.gestural com.android.internal.systemui.navbar.gestural_extra_wide_back com.android.internal.systemui.navbar.gestural_narrow_back com.android.internal.systemui.navbar.gestural_wide_back com.android.internal.systemui.navbar.threebutton" "com.android.theme.font.notoserifsource" "com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle" "com.android.bips com.android.printspooler" "com.miui.hybrid com.miui.hybrid.accessory" "com.android.stk" "com.android.traceur" "com.google.android.marvin.talkback" "com.miui.touchassistant" "com.quicinc.voice.activation" "com.android.wallpaperbackup" "com.miui.personalassistant" "com.miui.bugreport com.miui.miservice" "com.miui.yellowpage" "com.xiaomi.payment com.mipay.wallet.in" "com.tencent.soter.soterserver" "com.xiaomi.mirecycle" "com.miui.vsimcore" "com.wapi.wapicertmanage" "com.google.android.apps.turbo" "com.milink.service com.xiaomi.mirror" "com.xiaomi.joyose" "com.qualcomm.atfwd" "com.qualcomm.qti.uceShimService" ;;
        0) main_menu ;;
        *) echo -e "${RED}Wrong choice.${NC}"; sleep 1; utilities_menu ;;
    esac
}

google_menu() {
    clear
    echo -e "${GREEN}=== Google apps ===${NC}"
    echo "1) Android Auto (com.google.android.projection.gearhead)"
    echo "2) Chrome (com.android.chrome)"
    echo "3) Contacts (com.google.android.contacts)"
    echo "4) Dialer (com.google.android.dialer)"
    echo "5) Digital Wellbeing (com.google.android.apps.wellbeing)"
    echo "6) Drive (com.google.android.apps.docs)"
    echo "7) Files (com.google.android.apps.nbu.files)"
    echo "8) Gmail (com.google.android.gm)"
    echo "9) Google Assistant (com.google.android.apps.googleassistant)"
    echo "10) Google Duo (com.google.android.apps.tachyon)"
    echo "11) Google Music (com.google.android.music)"
    echo "12) Google One (com.google.android.apps.subscriptions.red)"
    echo "13) Google Search (com.google.android.googlequicksearchbox)"
    echo "14) Google Videos (com.google.android.videos)"
    echo "15) Health Connect (com.google.android.apps.healthdata)"
    echo "16) Maps (com.google.android.apps.maps)"
    echo "17) Messages (google.android.apps.messaging)"
    echo "18) Safety Hub (com.google.android.apps.safetyhub)"
    echo "19) YouTube (com.google.android.youtube)"
    echo "20) YouTube Music (com.google.android.apps.youtube.music)"
    echo "98) Uninstall selectively"
    echo "99) Check status of apps"
    echo "0) Return to main menu"
    echo "-------------------------"
    read -p "Select an app: " app_choice

    case $app_choice in
        1) action_menu "Android Auto" "com.google.android.projection.gearhead" "Uninstall" "google_menu" ;;
        2) action_menu "Chrome" "com.android.chrome" "Uninstall" "google_menu" ;;
        3) action_menu "Contacts" "com.google.android.contacts" "Uninstall" "google_menu" ;;
        4) action_menu "Dialer" "com.google.android.dialer" "Uninstall" "google_menu" ;;
        5) action_menu "Digital Wellbeing" "com.google.android.apps.wellbeing" "Uninstall" "google_menu" ;;
        6) action_menu "Drive" "com.google.android.apps.docs" "Uninstall" "google_menu" ;;
        7) action_menu "Files" "com.google.android.apps.nbu.files" "Uninstall" "google_menu" ;;
        8) action_menu "Gmail" "com.google.android.gm" "Uninstall" "google_menu" ;;
        9) action_menu "Google Assistant" "com.google.android.apps.googleassistant" "Uninstall" "google_menu" ;;
        10) action_menu "Google Duo" "com.google.android.apps.tachyon" "Uninstall" "google_menu" ;;
        11) action_menu "Google Music" "com.google.android.music" "Uninstall" "google_menu" ;;
        12) action_menu "Google One" "com.google.android.apps.subscriptions.red" "Uninstall" "google_menu" ;;
        13) action_menu "Google Search" "com.google.android.googlequicksearchbox" "Uninstall" "google_menu" ;;
        14) action_menu "Google Videos" "com.google.android.videos" "Uninstall" "google_menu" ;;
        15) action_menu "Health Connect" "com.google.android.apps.healthdata" "Uninstall" "google_menu" ;;
        16) action_menu "Maps" "com.google.android.apps.maps" "Uninstall" "google_menu" ;;
        17) action_menu "Messages" "google.android.apps.messaging" "Uninstall" "google_menu" ;;
        18) action_menu "Safety Hub" "com.google.android.apps.safetyhub" "Uninstall" "google_menu" ;;
        19) action_menu "YouTube" "com.google.android.youtube" "Uninstall" "google_menu" ;;
        20) action_menu "YouTube Music" "com.google.android.apps.youtube.music" "Uninstall" "google_menu" ;;
        98) selective_uninstall "google_menu" "com.google.android.projection.gearhead" "com.android.chrome" "com.google.android.contacts" "com.google.android.dialer" "com.google.android.apps.wellbeing" "com.google.android.apps.docs" "com.google.android.apps.nbu.files" "com.google.android.gm" "com.google.android.apps.googleassistant" "com.google.android.apps.tachyon" "com.google.android.music" "com.google.android.apps.subscriptions.red" "com.google.android.googlequicksearchbox" "com.google.android.videos" "com.google.android.apps.healthdata" "com.google.android.apps.maps" "google.android.apps.messaging" "com.google.android.apps.safetyhub" "com.google.android.youtube" "com.google.android.apps.youtube.music" ;;
        99) check_all_status "google_menu" "com.google.android.projection.gearhead" "com.android.chrome" "com.google.android.contacts" "com.google.android.dialer" "com.google.android.apps.wellbeing" "com.google.android.apps.docs" "com.google.android.apps.nbu.files" "com.google.android.gm" "com.google.android.apps.googleassistant" "com.google.android.apps.tachyon" "com.google.android.music" "com.google.android.apps.subscriptions.red" "com.google.android.googlequicksearchbox" "com.google.android.videos" "com.google.android.apps.healthdata" "com.google.android.apps.maps" "google.android.apps.messaging" "com.google.android.apps.safetyhub" "com.google.android.youtube" "com.google.android.apps.youtube.music" ;;
        0) main_menu ;;
        *) echo -e "${RED}Wrong choice.${NC}"; sleep 1; google_menu ;;
    esac
}

third_party_menu() {
    clear
    echo -e "${GREEN}=== Third-party apps ===${NC}"
    echo "1) Amazon (com.amazon.mShop.android.shopping com.amazon.appmanager)"
    echo "2) Block Juggle (com.block.juggle)"
    echo "3) Booking (com.booking)"
    echo "4) Facebook (com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana)"
    echo "5) Netflix (com.netflix.mediaclient com.netflix.partner.activation)"
    echo "6) OneDrive (com.microsoft.skydrive)"
    echo "7) Opera (com.opera.browser com.opera.preinstall)"
    echo "8) Spotify (com.spotify.music)"
    echo "9) Temu (com.einnovation.temu)"
    echo "10) WPS Office (cn.wps.moffice_eng)"
    echo "98) Uninstall selectively"
    echo "99) Check status of apps"
    echo "0) Return to main menu"
    echo "-------------------------"
    read -p "Select an app: " app_choice

    case $app_choice in
        1) action_menu "Amazon" "com.amazon.mShop.android.shopping com.amazon.appmanager" "Uninstall" "third_party_menu" ;;
        2) action_menu "Block Juggle" "com.block.juggle" "Uninstall" "third_party_menu" ;;
        3) action_menu "Booking" "com.booking" "Uninstall" "third_party_menu" ;;
        4) action_menu "Facebook" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "Uninstall" "third_party_menu" ;;
        5) action_menu "Netflix" "com.netflix.mediaclient com.netflix.partner.activation" "Uninstall" "third_party_menu" ;;
        6) action_menu "OneDrive" "com.microsoft.skydrive" "Uninstall" "third_party_menu" ;;
        7) action_menu "Opera" "com.opera.browser com.opera.preinstall" "Uninstall" "third_party_menu" ;;
        8) action_menu "Spotify" "com.spotify.music" "Uninstall" "third_party_menu" ;;
        9) action_menu "Temu" "com.einnovation.temu" "Uninstall" "third_party_menu" ;;
        10) action_menu "WPS Office" "cn.wps.moffice_eng" "Uninstall" "third_party_menu" ;;
        98) selective_uninstall "third_party_menu" "com.amazon.mShop.android.shopping com.amazon.appmanager" "com.block.juggle" "com.booking" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "com.netflix.mediaclient com.netflix.partner.activation" "com.microsoft.skydrive" "com.opera.browser com.opera.preinstall" "com.spotify.music" "com.einnovation.temu" "cn.wps.moffice_eng" ;;
        99) check_all_status "third_party_menu" "com.amazon.mShop.android.shopping com.amazon.appmanager" "com.block.juggle" "com.booking" "com.facebook.services com.facebook.system com.facebook.appmanager com.facebook.katana" "com.netflix.mediaclient com.netflix.partner.activation" "com.microsoft.skydrive" "com.opera.browser com.opera.preinstall" "com.spotify.music" "com.einnovation.temu" "cn.wps.moffice_eng" ;;
        0) main_menu ;;
        *) echo -e "${RED}Wrong choice.${NC}"; sleep 1; third_party_menu ;;
    esac
}

action_menu() {
    local name=$1
    local packages=$2
    local recommendation=$3
    local return_menu=$4
    clear
    echo -e "${GREEN}Action for $name${NC}"

    local installed_pkgs=""
    local disabled_pkgs=""
    local uninstalled_pkgs=""
    local not_installed_pkgs=""
    local status_output=""

    for pkg in $packages; do
        if $ADB shell pm list packages -u | grep -q "$pkg"; then
            if $ADB shell pm list packages -d | grep -q "$pkg"; then
                disabled_pkgs="$disabled_pkgs $pkg"
            elif $ADB shell pm list packages | grep -q "$pkg"; then
                installed_pkgs="$installed_pkgs $pkg"
            else
                uninstalled_pkgs="$uninstalled_pkgs $pkg"
            fi
        else
            not_installed_pkgs="$not_installed_pkgs $pkg"
        fi
    done

    if [ -n "$installed_pkgs" ]; then
        status_output="${GREEN}Installed${NC} (${installed_pkgs# })"
    fi
    if [ -n "$disabled_pkgs" ]; then
        [ -n "$status_output" ] && status_output="$status_output, "
        status_output="$status_output${YELLOW}Disabled${NC} (${disabled_pkgs# })"
    fi
    if [ -n "$uninstalled_pkgs" ]; then
        [ -n "$status_output" ] && status_output="$status_output, "
        status_output="$status_output${RED}Uninstalled${NC} (${uninstalled_pkgs# })"
    fi
    if [ -n "$not_installed_pkgs" ]; then
        [ -n "$status_output" ] && status_output="$status_output, "
        status_output="$status_output${BLUE}Not installed${NC} (${not_installed_pkgs# })"
    fi

    echo -e "Status: $status_output"
    echo "Recommendation: $recommendation"
    echo "1) Uninstall"
    echo "2) Disable"
    echo "3) Restore"
    echo "4) Enable"
    echo "0) Return"
    echo "-------------------------"
    read -p "Select an action: " action

    case $action in
        1) for pkg in $packages; do uninstall_package "$pkg"; done ;;
        2) for pkg in $packages; do disable_package "$pkg"; done ;;
        3) for pkg in $packages; do install_package "$pkg"; done ;;
        4) for pkg in $packages; do enable_package "$pkg"; done ;;
        0) $return_menu ;;
        *) echo -e "${RED}Wrong action.${NC}" ;;
    esac

    read -p "Press Enter to continue..." -r
    $return_menu
}

uninstall_package() {
    local package=$1

    if $ADB shell pm list packages -u | grep -q "$package" && ! $ADB shell pm list packages | grep -q "$package"; then
        echo -e "${YELLOW}The package $package has already been removed.${NC}"
    else
        local output=$($ADB shell pm uninstall --user 0 "$package" 2>&1)
        if [[ "$output" == "Success" ]]; then
            echo -e "${GREEN}Successfully uninstalled: $package${NC}"
        else
            echo -e "${RED}Failed to remove $package: $output${NC}"
        fi
    fi
}

disable_package() {
    local package=$1

    if $ADB shell pm list packages -d | grep -q "$package"; then
        echo -e "${YELLOW}Package $package is already disabled.${NC}"
    else
        local output=$($ADB shell pm disable-user --user 0 "$package" 2>&1)
        if [[ "$output" =~ "disabled-user" ]]; then
            echo -e "${GREEN}Successfully disabled: $package${NC}"
        else
            echo -e "${RED}Failed to disable $package: $output${NC}"
        fi
    fi
}

install_package() {
    local package=$1

    if $ADB shell pm list packages | grep -q "$package" && ! $ADB shell pm list packages -d | grep -q "$package"; then
        echo -e "${YELLOW}The package $package is already installed.${NC}"
    else
        local output=$($ADB shell pm install-existing --user 0 "$package" 2>&1)
        if [[ "$output" =~ "installed" || -z "$output" ]]; then
            echo -e "${GREEN}Successfully restored: $package${NC}"
        elif [[ "$output" =~ "doesn't exist" ]]; then
            echo -e "${YELLOW}Package $package was not found on the system to restore.${NC}"
        else
            echo -e "${RED}Error restoring $package: $output${NC}"
        fi
    fi
}

enable_package() {
    local package=$1

    if $ADB shell pm list packages | grep -q "$package" && ! $ADB shell pm list packages -d | grep -q "$package"; then
        echo -e "${YELLOW}Package $package is already enabled.${NC}"
    else
        local output=$($ADB shell pm enable --user 0 "$package" 2>&1)
        if [[ "$output" =~ "enabled" ]]; then
            echo -e "${GREEN}Successfully enabled: $package${NC}"
        else
            echo -e "${RED}Failed to enable $package: $output${NC}"
        fi
    fi
}

selective_uninstall() {
    local return_menu=$1
    shift
    local pkg_groups=("$@")
    local max_index=$((${#pkg_groups[@]} - 1))

    clear
    echo -e "${GREEN}=== Uninstall selectively ===${NC}"
    echo "Enter the program numbers separated by a space (for example, '1 5 6')."
    echo "Range: 1–$((max_index + 1))"
    echo "-------------------------"
    read -p "Select programs: " selection

    for num in $selection; do
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$((max_index + 1))" ]; then
            local pkg_group="${pkg_groups[$((num - 1))]}"
            for pkg in $pkg_group; do
                uninstall_package "$pkg"
            done
        else
            echo -e "${RED}Wrong number: $num${NC}"
        fi
    done

    read -p "Press Enter to continue..." -r
    $return_menu
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
        if $ADB shell pm list packages -u | grep -q "$pkg"; then
            system_exists=1
            if $ADB shell pm list packages -d | grep -q "$pkg"; then
                disabled=$((disabled + 1))
            elif $ADB shell pm list packages | grep -q "$pkg"; then
                installed=$((installed + 1))
            else
                uninstalled=$((uninstalled + 1))
            fi
        else
            uninstalled=$((uninstalled + 1))
        fi
    done

    if [ $total -eq $installed ]; then
        echo -e "${GREEN}Installed${NC}"
    elif [ $total -eq $disabled ]; then
        echo -e "${YELLOW}Disabled${NC}"
    elif [ $total -eq $uninstalled ] && [ $system_exists -eq 1 ]; then
        echo -e "${RED}Uninstalled${NC}"
    elif [ $total -eq $uninstalled ]; then
        echo -e "${BLUE}Not installed${NC}"
    else
        echo -e "${CYAN}Partially installed{NC}"
    fi
}

check_all_status() {
    local return_menu=$1
    shift
    local pkg_groups=("$@")

    clear
    echo -e "${GREEN}=== Check status of apps ===${NC}"
    local index=0
    for pkg_group in "${pkg_groups[@]}"; do
        index=$((index + 1))
        local name=""
        case $return_menu in
            "miui_menu")
                case $index in
                    1) name="Cleaner" ;;
                    2) name="Compass" ;;
                    3) name="GetApps" ;;
                    4) name="Mi Browser" ;;
                    5) name="Mi Home" ;;
                    6) name="Mi Mover" ;;
                    7) name="Mi Music" ;;
                    8) name="Mi Video" ;;
                    9) name="MinusScreen Widget" ;;
                    10) name="POCO Store & Community" ;;
                    11) name="QR Scanner" ;;
                    12) name="ShareMe" ;;
                    13) name="Downloads" ;;
                    14) name="Themes" ;;
                    15) name="Wallpaper Carousel" ;;
                    16) name="Xiaomi Games" ;;
                esac ;;
            "utilities_menu")
                case $index in
                    1) name="Ad Bookmarks" ;;
                    2) name="Battery Logs Catchlog" ;;
                    3) name="Bluetooth MIDI" ;;
                    4) name="Cloud Backup" ;;
                    5) name="Google One Time Initialization" ;;
                    6) name="Google Print Recommendations" ;;
                    7) name="MIUI Ads" ;;
                    8) name="MIUI Analytics" ;;
                    9) name="MIUI Daemon" ;;
                    10) name="MMS Service" ;;
                    11) name="Navigation Gestures" ;;
                    12) name="Noto Serif Font" ;;
                    13) name="OK Google Detection" ;;
                    14) name="Print Service" ;;
                    15) name="Quick Apps" ;;
                    16) name="SIM Card Menu" ;;
                    17) name="System Tracing" ;;
                    18) name="TalkBack" ;;
                    19) name="Touch Assistant" ;;
                    20) name="Voice Activation" ;;
                    21) name="Wallpaper Backup" ;;
                    22) name="App Vault Widget" ;;
                    23) name="Bug Reports & Feedback" ;;
                    24) name="Chinese Caller ID" ;;
                    25) name="Chinese Mi Pay" ;;
                    26) name="Chinese Payment Verification Service" ;;
                    27) name="Chinese Promo Service" ;;
                    28) name="Chinese Virtual Cards" ;;
                    29) name="Chinese Wi-Fi Variant" ;;
                    30) name="Device Health Services" ;;
                    31) name="Interconnectivity & Services" ;;
                    32) name="Joyose" ;;
                    33) name="Qualcomm Miracast" ;;
                    34) name="Qualcomm RCS" ;;
                esac ;;
            "google_menu")
                case $index in
                    1) name="Android Auto" ;;
                    2) name="Chrome" ;;
                    3) name="Contacts" ;;
                    4) name="Dialer" ;;
                    5) name="Digital Wellbeing" ;;
                    6) name="Drive" ;;
                    7) name="Files" ;;
                    8) name="Gmail" ;;
                    9) name="Google Assistant" ;;
                    10) name="Google Duo" ;;
                    11) name="Google Music" ;;
                    12) name="Google One" ;;
                    13) name="Google Search" ;;
                    14) name="Google Videos" ;;
                    15) name="Health Connect" ;;
                    16) name="Maps" ;;
                    17) name="Messages" ;;
                    18) name="Safety Hub" ;;
                    19) name="YouTube" ;;
                    20) name="YouTube Music" ;;
                esac ;;
            "third_party_menu")
                case $index in
                    1) name="Amazon" ;;
                    2) name="Block Juggle" ;;
                    3) name="Booking" ;;
                    4) name="Facebook" ;;
                    5) name="Netflix" ;;
                    6) name="OneDrive" ;;
                    7) name="Opera" ;;
                    8) name="Spotify" ;;
                    9) name="Temu" ;;
                    10) name="WPS Office" ;;
                esac ;;
        esac
        echo -e "$index) $name | $(check_package_status "$pkg_group")"
    done
    echo "-------------------------"
    read -p "Press Enter to continue..." -r
    $return_menu
}

restore_miui_dialer_messages() {
    clear
    echo -e "${GREEN}=== Restoring Xiaomi Dialer & Messages ===${NC}"

    echo "Checking Xiaomi Dialer (com.android.contacts) in system..."
    local dialer_output=$($ADB shell pm install-existing --user 0 com.android.contacts 2>&1)
    if [[ "$dialer_output" =~ "installed" || -z "$dialer_output" ]]; then
        echo -e "${GREEN}Xiaomi Dialer restored successfully from system!${NC}"
    elif [[ "$dialer_output" =~ "doesn't exist" ]]; then
        echo -e "${YELLOW}Xiaomi Dialer not found in system.${NC}"
    else
        echo -e "${RED}Error restoring Xiaomi Dialer from system: $dialer_output${NC}"
    fi

    echo "Checking Xiaomi Messages (com.android.mms) in system..."
    local messages_output=$($ADB shell pm install-existing --user 0 com.android.mms 2>&1)
    if [[ "$messages_output" =~ "installed" || -z "$messages_output" ]]; then
        echo -e "${GREEN}Xiaomi Messages restored successfully from system!${NC}"
    elif [[ "$messages_output" =~ "doesn't exist" ]]; then
        echo -e "${YELLOW}Xiaomi Messages not found in system.${NC}"
    else
        echo -e "${RED}Error restoring Xiaomi Messages from system: $messages_output${NC}"
    fi

    read -p "Press Enter to continue..." -r
    main_menu
}

check_adb
if [ "$ADB" = "./adb" ]; then
    $ADB kill-server > /dev/null 2>&1
    $ADB start-server > /dev/null 2>&1
else
    $ADB kill-server > /dev/null 2>&1 || sudo $ADB kill-server > /dev/null 2>&1
    $ADB start-server > /dev/null 2>&1 || sudo $ADB start-server > /dev/null 2>&1
fi
check_device
echo -e "${GREEN}MIUI/HyperOS bloatware app removal script by Quinsaiz${NC}"
main_menu