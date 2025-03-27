<h1 align="center">MIUI/HyperOS App Removal Tool</h1>

<p align="center">
    <img src="https://img.shields.io/badge/MIUI-HyperOS-blue?style=for-the-badge&logo=android" alt="MIUI/HyperOS"/>
    <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License"/>
    <img src="https://img.shields.io/badge/Version-1.0-orange?style=for-the-badge" alt="Version"/>
</p>

<h3 align="center">Choose Language/Оберіть мову</h3>

<p align="center">
    <a href="#english">English</a> | <a href="#українська">Українська</a>
</p>

## English

### Description
This tool allows you to quickly and conveniently remove or disable unnecessary system apps, utilities, Google apps, and third-party apps on devices running MIUI or HyperOS. The scripts are written in Bash (Linux) and Batch (Windows), making them versatile for different systems. Everything is alphabetically sorted, with clear menus and app statuses.

#### Key Features:
- 📱 Remove MIUI/HyperOS system apps (e.g., GetApps, Mi Browser).
- ⚙️ Disable critical utilities (e.g., Quick Apps, Touch Assistant).
- 🌐 Manage Google apps (YouTube, Gmail, etc.).
- 🎮 Remove third-party apps (Netflix, Facebook, etc.).
- ✅ Check app statuses via ADB.

### How to Use

#### Prerequisites
1. **ADB (Android Debug Bridge):** Download from the [official Android site](https://developer.android.com/tools/releases/platform-tools).
2. **USB Debugging:** Enable "USB Debugging" in Developer Options on your device.
3. **Connection:** Connect your device to your computer via USB.

#### Instructions for Linux

1. **Install android-tools or Move files from the platform-tools folder to the script folder.**

2. **Download the script**:
    ```bash  
    git clone https://github.com/quinsaiz/miui-clean.git
    cd miui-clean
    ```
3. **Make it executable**:
    ```bash
    chmod +x script.sh
    ```
4. **Run the script**:
    ```bash
    ./script.sh
    ```

#### Instructions for Windows

1. **Install ADB or Move files from the platform-tools folder to the script folder.**

2.  **Download the script:**
Download the ZIP from GitHub and extract it.
Or run:
    ```cmd
    git clone https://github.com/quinsaiz/miui-clean.git
    cd miui-clean 
    ```

3.  **Open CMD: Navigate to the script folder in Command Prompt**
    ```cmd
    cd path/to/miui-clean
    ```
4.  **Run the script:**
    ```cmd
    script.bat
    ```
**Select an option:** Use numbers to navigate through the menu (for example, 1 for MIUI/HyperOS apps).

**Actions:** Select "Uninstall", "Restore", "Disable", "Enable" for each program.

### Important Notes

    Backup: It’s recommended to back up your device before removing system apps.
    Safety: Disabling critical utilities may affect system stability.
    ADB: Ensure ADB is working correctly (adb devices should list your device).

### Project Structure
```text
miui-clean/
│  
├── script.sh   # Bash script for Linux
├── script.bat  # Batch script for Windows
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

<img src="https://img.shields.io/github/stars/quinsaiz/miui-clean?style=social" alt="GitHub star"/>

## Українська

### Опис

Цей інструмент дозволяє швидко та зручно видаляти або відключати непотрібні системні програми, утиліти, програми Google та сторонні додатки на пристроях з MIUI або HyperOS. Скрипти написані для Bash (Linux) та Batch (Windows), що робить їх універсальними для різних систем. Усе відсортовано за алфавітом, з чіткими меню та статусами програм.
#### Основні можливості:

 - 📱 Видалення системних програм MIUI/HyperOS (наприклад, GetApps, Mi Browser).
 - ⚙️ Відключення критичних утиліт (наприклад, Quick Apps, Сенсорний помічник).
 - 🌐 Управління програмами Google (YouTube, Gmail тощо).
 - 🎮 Видалення сторонніх додатків (Netflix, Facebook тощо).
 - ✅ Перевірка статусу програм через ADB.

### Як використовувати
#### Передумови

1. **ADB (Android Debug Bridge):** Завантажте з [офіційного сайту Android](https://developer.android.com/tools/releases/platform-tools).
2. **USB-налагодження:** Увімкніть "Налагодження по USB" у налаштуваннях розробника на вашому пристрої.
3. **Підключення:** Підключіть пристрій до комп’ютера через USB.

#### Інструкція для Linux

1. **Встановіть android-tools або перемістіть файли з папки platform-tools до папки script.**.

2. **Завантажте скрипт:**
    ```bash
    git clone https://github.com/quinsaiz/miui-clean.git
    cd miui-clean
    ```
3. **Дайте права на виконання:**
    ```bash
    chmod +x script.sh
    ```
4. **Запустіть скрипт:**
    ```bash
    ./script.sh
    ```

#### Інструкція для Windows

1. **Встановіть ADB або перемістіть файли з папки platform-tools до папки script.**.

1. **Завантажте скрипт:**
Завантажте ZIP-архів з GitHub та розпакуйте його.
Або виконайте:
    ```cmd
    git clone https://github.com/quinsaiz/miui-clean.git
    cd miui-clean
    ```
2. **Відкрийте CMD:** 
Перейдіть до папки зі скриптом у командному рядку.

    ```cmd
    cd шлях/до/miui-clean
    ```
3. **Запустіть скрипт:**

    ```cmd
    script.bat
    ```

**Виберіть опцію:** Використовуйте цифри для навігації по меню (наприклад, 1 для MIUI-програм).

**Дії:** Виберіть "Видалити", "Відновити", "Відключити", "Включити" для кожної програми.

### Важливі примітки

    Резервне копіювання: Рекомендується зробити резервну копію перед видаленням системних програм.
    Безпека: Відключення критичних утиліт може вплинути на стабільність системи.
    ADB: Переконайтеся, що ADB працює коректно (adb devices має показати ваш пристрій).

### Структура проєкту
```text
miui-clean/
│
├── script.sh   # Bash script for Linux
├── script.bat  # Batch script for Windows
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

<img src="https://img.shields.io/github/stars/quinsaiz/miui-clean?style=social" alt="GitHub star"/>