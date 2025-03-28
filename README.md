<h1 align="center">Bloatware App Removal Tools</h1>

<p align="center">
    <img src="https://img.shields.io/badge/Android-gray?style=for-the-badge&logo=android" alt="Android"/>
    <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License"/>
    <img src="https://img.shields.io/badge/Version-1.02-orange?style=for-the-badge" alt="Version"/>
</p>

<h3 align="center">Choose Language/Оберіть мову</h3>

<p align="center">
    <a href="#english">English</a> | <a href="#українська">Українська</a>
</p>

## English

### Description
This tool allows you to quickly and conveniently remove or disable unnecessary system apps, utilities, Google apps, and third-party apps on devices running MIUI or HyperOS. The scripts are written in Bash (Linux) and PowerShell (Windows), making them versatile for different systems. Everything is alphabetically sorted, with clear menus and app statuses.

#### Key Features:
- 📱 Remove MIUI/HyperOS system apps (e.g., GetApps, Mi Browser).
- ⚙️ Disable critical utilities (e.g., Quick Apps, Touch Assistant).
- 🌐 Manage Google apps (YouTube, Gmail, etc.).
- 🎮 Remove third-party apps (Netflix, Facebook, etc.).
- ✅ Check app statuses via ADB.

### How to Use

#### Prerequisites
1. **ADB (Android Debug Bridge):** Download platform-tools from the [official Android site](https://developer.android.com/tools/releases/platform-tools).
2. **USB Debugging:** Enable "USB Debugging" in Developer Options on your device.
3. **Connection:** Connect your device to your computer via USB.

### Instruction for Linux

#### Create a work folder

* Unzip the archive from platform-tools or install ADB (android-tools package).

* Download the script from Release and move it to the folder with platform-tools, or use git:
    ```bash
    git clone https://github.com/quinsaiz/bloatware-remove.git && cd bloatware-remove
    ```

#### Run the script:

* Give permission to execute the file:
    ```bash
    chmod +x script.sh
    ```

* Run the script:
    ```bash
    ./script.sh
    ```
    
### Instruction for Windows

#### Create a work folder:

* Unzip the archive from platform-tools or install ADB.

* Download the `script.ps1` from Release and move it to the platform-tools folder.

#### Run the script:

* Open PowerShell.

* Go to the folder with the script:
    ```powershell
    cd path/to/bloatware-remove
    ```

* Set execution policy to be able to run scripts only in the current PowerShell session:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    ```

* Run the script:
    ```powershell
    .\script.ps1
    ```
  
**Select an option:** Use numbers to navigate through the menu (for example, 1 for MIUI/HyperOS apps).

**Actions:** Select "Uninstall", "Restore", "Disable", "Enable" for each program.

### Important Notes

    Backup: It’s recommended to back up your device before removing system apps.
    Safety: Disabling critical utilities may affect system stability.
    ADB: Ensure ADB is working correctly (adb devices should list your device).

### Project Structure
```text
bloatware-remove/
│  
├── script.sh   # Bash script for Linux
├── script.ps1  # PowerShell script for Windows
├── LICENSE     # MIT License
└── README.md   # This file
```
### Author

    Name: quinsaiz
    GitHub: https://github.com/quinsaiz

### License

This project is licensed under the [MIT License](/LICENSE).

### Support

If you like this project, please give it a star on GitHub!

<img src="https://img.shields.io/github/stars/quinsaiz/bloatware-remove?style=social" alt="GitHub star"/>

## Українська

### Опис

Цей інструмент дозволяє швидко та зручно видаляти або відключати непотрібні системні програми, утиліти, програми Google та сторонні додатки на пристроях з MIUI або HyperOS. Скрипти написані для Bash (Linux) та PowerShell (Windows), що робить їх універсальними для різних систем. Усе відсортовано за алфавітом, з чіткими меню та статусами програм.
#### Основні можливості:

 - 📱 Видалення системних програм MIUI/HyperOS (наприклад, GetApps, Mi Browser).
 - ⚙️ Відключення критичних утиліт (наприклад, Quick Apps, Сенсорний помічник).
 - 🌐 Управління програмами Google (YouTube, Gmail тощо).
 - 🎮 Видалення сторонніх додатків (Netflix, Facebook тощо).
 - ✅ Перевірка статусу програм через ADB.

### Як використовувати
#### Передумови

1. **ADB (Android Debug Bridge):** Завантажте platform-tools з [офіційного сайту Android](https://developer.android.com/tools/releases/platform-tools).

2. **USB-налагодження:** Увімкніть "Налагодження по USB" у налаштуваннях розробника на вашому пристрої.

3. **Підключення:** Підключіть пристрій до комп’ютера через USB.

### Інструкція для Linux

#### Створення робочої папки:

* Розпакуйте архів з platform-tools або Встановіть ADB (пакет android-tools).

* Завантажте скрипт з Release та перемістіть його у папку з platform-tools, або використайте git:
    ```bash
    git clone https://github.com/quinsaiz/bloatware-remove.git && cd bloatware-remove
    ```

#### Запуск скрипта:

* Дайте права на виконання:
    ```bash
    chmod +x script.sh
    ```

* Запустіть скрипт:
    ```bash
    ./script.sh
    ```
    
### Інструкція для Windows

#### Створення робочої папки:

* Розпакуйте архів з platform-tools або Встановіть ADB.

* Завантажте `script.ps1` з Release та перемістіть його у папку з platform-tools.

#### Запуск скрипта:

* Відкрийте PowerShell.

* Перейдіть до папки зі скриптом у командному рядку:
    ```powershell
    cd шлях/до/bloatware-remove
    ```

* Встановіть політику виконання, щоб мати змогу запускати сценарії лише у поточному сеансі PowerShell:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    ```

* Запустіть скрипт:
    ```powershell
    .\script.ps1
    ```

**Виберіть опцію:** Використовуйте цифри для навігації по меню (наприклад, 1 для MIUI-програм).

**Дії:** Виберіть "Видалити", "Відновити", "Відключити", "Включити" для кожної програми.

### Важливі примітки

    Резервне копіювання: Рекомендується зробити резервну копію перед видаленням системних програм.
    Безпека: Відключення критичних утиліт може вплинути на стабільність системи.
    ADB: Переконайтеся, що ADB працює коректно (adb devices має показати ваш пристрій).

### Структура проєкту
```text
bloatware-remove/
│
├── script.sh   # Bash script for Linux
├── script.ps1  # PowerShell script for Windows
├── LICENSE     # MIT License
└── README.md   # This file
```
### Автор

    Ім’я: quinsaiz
    GitHub: https://github.com/quinsaiz

### Ліцензія

Цей проєкт ліцензовано за [MIT License](/LICENSE).

### Підтримка

Якщо Вам подобається цей проєкт, можете поставити зірку!

<img src="https://img.shields.io/github/stars/quinsaiz/bloatware-remove?style=social" alt="GitHub star"/>