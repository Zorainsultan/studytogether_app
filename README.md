# StudyTogether

A Flutter application designed to help university students create and join collaborative study sessions while also enabling them to find study partners.

###### File Name: `studytogether_app`

###### Repository Link: https://github.com/Zorainsultan/studytogether_app

---

## About

This document provides the instructions necessary to set up and run the StudyTogether application. Follow these steps to ensure the application is configured and runs correctly on your system.

---

## Folder Structure

The folder structure of this project is as follows:

- All source code is in the `lib` folder.
- Most UI designs and main functionalities are under the `pages` subfolder.
- The main function is located in `main.dart` under the `lib` folder.
- Images used in the project are stored in the `assets` folder.

---

## Prerequisites

Please make sure the following requirements are met before starting:

1. **Flutter SDK** – [Install Flutter](https://docs.flutter.dev/get-started/install)
2. **Android Studio** – For Android emulation – [Download](https://developer.android.com/studio)
3. **Xcode** – For iOS emulation (Mac only) – [Download](https://developer.apple.com/xcode/)
4. **Visual Studio Code** (optional but recommended) – [Download](https://code.visualstudio.com/)

---

## Setup Instructions

### 1. Install Flutter

Visit the official [Flutter website](https://docs.flutter.dev/get-started/install) and follow the platform-specific instructions to install Flutter and add it to your system’s PATH.

### 2. Unpack the Project

Extract the zipped project folder to a location of your choice.

### 3. Install Required Packages

Open a terminal in the root directory of the project and run:

`flutter pub get`

### 4. Set Up a Device or Emulator

#### For Android:

1. Open Android Studio

2. Click More Actions > Virtual Device Manager

3. Click + Add Device and select a preferred device, I have tested this app on Google Pixel 7 and 9 for example.

4. Once the emulator is generated i.e: opens infront of you with the home screen - It has built successfully.

#### For iOS (Mac users only):

1. Open Xcode

2. Go to Preferences > Components

3. Download and install the desired simulator, I have tested this app on iphone 14 emulator for example.

4. Launch the simulator and run the app via terminal or VS Code

### 5. Run the Application

#### To run the app from the terminal:

`flutter run`

#### Running from VS Code:

1. Make sure an emulator is running

2. In VS Code, select the emulator from the bottom right corner present in a bar.

3. Click Run > Run Without Debugging from the top menu

Please be patient while the application builds and runs for the first time it may take a while on a new system.

Please also make sure you have are connected to a stable network.

---

## Notes

- The app is not deployed to the Play Store or App Store.
- The backend is cloud based, built using Firebase.

---

## Contact

If any step is unclear or you need assistance, feel free to reach out:

Zorain Sultan
zorainsultanasmat@gmail.com
