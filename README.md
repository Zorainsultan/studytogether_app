# Application Name: StudyTogether

###### File Name: studytogether_app

A Flutter application designed for university students to find and join sessions.

## About

This document provides the instructions necessary to set up and run the StudyTogether application. Follow these steps to make sure that the application is configured and runs correctly on your system.

## Folder Structure

The folder structure of this project is as follows:

- All the produced code is in the lib folder. This folder is structured in a way for easy navigation. It has folders as for the different UI pages, for example login, join/create session, profile etc.
- The main function to run the application is in main.dart uneder the lib folder.
- The images used are in the assets folder.

## Prerequisites

Please make sure the following requirements are met before you begin:

1. Flutter SDK: Installed and configured. https://docs.flutter.dev/get-started/install
2. Android Studio: For Android emulation. https://developer.android.com/studio
3. Xcode: For iOS emulation (Mac only). https://developer.apple.com/xcode/
4. Visual Studio Code: Optional but recommended for code editing. https://code.visualstudio.com/

## Set Up Instuctions

1. Install Flutter
   Vist the Flutter official site and download the Flutter SDK. Once downloaded, follow the platform specific instructions to add Flutter to your system’s PATH environment so you can use it from the terminal.

2. Unpack the Project
   Extract the zipped project folder to any location on your machine where you'd like to keep the project files.

3. Install Required Packages
   Open your terminal or command line and navigate to the root directory of the extracted project. Then run:

- flutter pub get

This command fetches all the dependencies listed in the pubspec.yaml file.

Alternatively, if you’re using VS Code, you can open the project folder and run the same command from the built in terminal.

4. Set Up a Device or Emulator

For Android:
a. Open Android Studio
b. click More Actions > Virtual Device Manager
c. Click the + Add Device button and select a preferred device (e.g. Pixel 7)
d. Once the virtual device is created, click Run to launch it

For iOS (Mac Users only):
a. Open Xcode
b. Go to Preferences > Components
c. Download and install the simulator you'd like to use (e.g. iPhone 14)
d. Run the app from your terminal or via an IDE like VS Code once the simulator is running

## Debug/Run the application

Run the following command in your terminal within the project directory: flutter run.
If using VS Code, you need to select the emulatng the boor first, usittom line in VS Code window, then click on Run from the top Menu, and click Run without debugging , or you could also make sure you open the emulator first using Android Studio or Xcode using the same steps as above also mentioned below and then debug the code.

For Android:
a. Open Android Studio
b. click More Actions > Virtual Device Manager
c. Click the + Add Device button and select a preferred device (e.g. Pixel 7)
d. Once the virtual device is created, click Run to launch it

For iOS (Mac Users only):
a. Open Xcode
b. Go to Preferences > Components
c. Download and install the simulator you'd like to use (e.g. iPhone 14)
d. Run the app from your terminal or via an IDE like VS Code once the simulator is running

Please be patient while the code debugs and runs, it normally takes some time for the application to run on a new system at first.

## Notes

The app is not deployed to the Play Store or App Store.
The backend is completely cloud based and built using firebase.
Code is currently structured to prioritise functionality over visual polish.
Further improvements could include session filtering, user profiles, chat, etc.

## Additional Info

If during any stage any step is unclear please visit the offical flutter website for troubleshooting guide or please dont hesitate to contact the developer of the app Zorain Sultan at zorainsultanasmat@gmail.com.
