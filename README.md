# Fashion Store - Flutter E-commerce App

A modern, responsive e-commerce mobile application built with Flutter. This project demonstrates a complete shopping experience, from authentication to checkout, using clean architecture and state management.

## 🚀 Features

- **User Authentication**: Secure Login and Sign-up system integrated with Firebase Authentication, including Google Sign-In support.
- **Product Discovery**: 
  - Dynamic home screen with categorized product listings.
  - Real-time search functionality.
  - Category-based filtering (Dresses, Shirts, Shoes, etc.).
- **Product Details**: 
  - Detailed product views with image galleries.
  - Size and color selection.
  - Quantity management.
- **Cart System**: 
  - Centralized cart management using Riverpod.
  - Add/remove items and update quantities dynamically.
- **Checkout**: 
  - Summary of items, subtotal, and shipping calculations.
  - Promo code application support.
- **Responsive UI**: Pixel-perfect design adapted for various screen sizes using `flutter_screenutil`.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Flutter Riverpod](https://riverpod.dev)
- **Backend/Auth**: [Firebase](https://firebase.google.com) (Auth, Firestore)
- **Networking**: [http](https://pub.dev/packages/http) (API integration with DummyJSON)
- **Design & UI**: 
  - `flutter_screenutil` (Responsiveness)
  - `cached_network_image` (Image optimization)
  - `google_fonts` (Typography)

## 📦 Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/tayyba678/Fashion_App_store.git
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Firebase Setup**:
   - Create a project on the [Firebase Console](https://console.firebase.google.com/).
   - Add an Android app and download the `google-services.json` file.
   - Place it in `android/app/`.
4. **Run the app**:
   ```bash
   flutter run
   ```


## 📄 License
This project is licensed under the MIT License.
