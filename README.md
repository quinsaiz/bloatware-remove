<h1 align="center">Bloatware App Removal Tools</h1>

<p align="center">
    <img src="https://img.shields.io/badge/Android-gray?style=for-the-badge&logo=android" alt="Android"/>
    <img src="https://img.shields.io/badge/License-GPLv3-green?style=for-the-badge" alt="License"/>
    <img src="https://img.shields.io/badge/Version-1.10-orange?style=for-the-badge" alt="Version"/>
</p>

## Description
This tool allows you to quickly and conveniently remove or disable unnecessary system apps, utilities, Google apps, and third-party apps on devices running MIUI or HyperOS. The scripts are written in Bash (Linux) and PowerShell (Windows), making them versatile for different systems. Everything is alphabetically sorted, with clear menus and app statuses.

### Key Features:
- 📱 Remove MIUI/HyperOS system apps (e.g., GetApps, Mi Browser).
- ⚙️ Disable critical utilities (e.g., Quick Apps, Touch Assistant).
- 🌐 Manage Google apps (YouTube, Gmail, etc.).
- 🎮 Remove third-party apps (Netflix, Facebook, etc.).
- ✅ Check app statuses via ADB.

## How to Use

### Prerequisites
1. **ADB (Android Debug Bridge):** Download platform-tools from the [official Android site](https://developer.android.com/tools/releases/platform-tools).
2. **USB Debugging:** Enable "USB Debugging" in Developer Options on your device.
3. **Connection:** Connect your device to your computer via USB.

## Instruction for Linux

### Create a work folder

* Unzip the archive from platform-tools or install ADB (android-tools package).

* Download the script from Release and move it to the folder with platform-tools, or use git:
    ```bash
    git clone https://github.com/quinsaiz/bloatware-remove.git && cd bloatware-remove
    ```

### Run the script:

* Give permission to execute the file:
    ```bash
    chmod +x script.sh
    ```

* Run the script:
    ```bash
    ./script.sh
    ```
    
## Instruction for Windows

### Create a work folder:

* Unzip the archive from platform-tools or install ADB.

* Download the `script.ps1` from Release and move it to the platform-tools folder.

### Run the script:

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

## Important Notes

**Backup:** It’s recommended to back up your device before removing system apps.

**Safety:** Disabling critical utilities may affect system stability.

**ADB:** Ensure ADB is working correctly (adb devices should list your device).

## Project Structure
```text
bloatware-remove/
│  
├── script.sh   # Bash script for Linux
├── script.ps1  # PowerShell script for Windows
├── LICENSE     # GPLv3 License
└── README.md   # This file
```
## Author

    Name: quinsaiz
    GitHub: https://github.com/quinsaiz

## License

This project is licensed under the [GPLv3 License](/LICENSE).

## Support

If you like this project, please give it a star on GitHub!

<img src="https://img.shields.io/github/stars/quinsaiz/bloatware-remove?style=social" alt="GitHub star"/>