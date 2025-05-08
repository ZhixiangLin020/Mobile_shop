README

Project overview

This Flutter project is a mobile shopping application focused on plush toys. It allows users to:

	Browse a list of plushie products

	Add selected items to a shopping cart.

	View the total price dynamically

	Access individual product details including price, sales, and description

Project structure

untitled2/

├── lib/
│   └── main.dart               # All Dart code is contained here
├── assets/
│   └── images/
│       ├── image_0.png         # Splash screen image
│       ├── image_1.jpg         # Plushie 1
│       ├── image_2.jpg         # Plushie 2
│       ├── image_3.jpg         # Plushie 3
│       ├── image_4.jpg         # Plushie 4
│       ├── image_5.jpg         # Plushie 5
│       └── image_6.png         # Discount banner
├── pubspec.yaml                # Asset and dependency declarations
├── README.md               

Configuration steps

1. Prerequisites
   Ensure the following are installed:
   •	Flutter SDK
   •	Dart SDK
   •	Android Studio or VS Code with Flutter and Dart plugins

2. Install dependencies
   Run the following command in the project directory:
   flutter pub get

Make sure the assets/images/ directory exists and all referenced image files are present.

3. Run the app
   Use the following command to run the app on an emulator or a connected device:
   flutter run
   After launching, a splash screen will display for three seconds before entering the main shop interface.
