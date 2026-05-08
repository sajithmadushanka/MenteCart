# MenteCart Mobile App

Flutter mobile application for the MenteCart service booking platform.

The mobile app allows users to:
- browse available services
- search and filter services
- manage booking cart
- complete bookings
- pay online using PayHere
- track booking history
- manage authentication sessions

This project was developed as part of the GlobalTNA Full Stack Flutter Developer Technical Assessment.

---
# Running the App
flutter pub get

flutter run \
--dart-define=API_BASE_URL=https://mentecart.onrender.com/api

or 

flutter run \
--dart-define=API_BASE_URL=http:/127.0.0.1:4040/api

# download app ---
https://play.google.com/apps/test/RQtuUr5iWVE/ahAO29uNS8WkhMW8R36n78B41mtYGCt6DBQU5crNy8tClrA7p-9Zt1bz2ElGVnQw-uyT1pa3XCZEf-egsf1Wstppml


# Sandbox & Testing
Name on Card : CVV

NO :4916217501611292

Expiry date : 02/33

------------------------------------------------------
# Tech Stack

- Flutter
- Dart 3
- BLoC State Management
- GoRouter
- Dio
- Cached Network Image
- Flutter Secure Storage
- WebView Flutter

---

# Features

# Authentication
- User signup
- User login
- JWT access token authentication
- Refresh token flow
- Auto-login session persistence
- Protected navigation
- Logout support

---

# Services Module
- Browse services
- Service details
- Search services
- Category filtering
- Cached service images
- Pull-to-refresh
- Empty state handling

---

# Cart Module
- Add services to cart
- Date selection
- Time slot selection
- Quantity updates
- Remove items
- Capacity validation
- Dynamic total calculation

---

# Booking Module
- Checkout flow
- Booking history
- Booking details
- Booking cancellation
- Payment status tracking

---

# Payment Integration
- PayHere WebView integration
- Payment success flow
- Payment status updates
- Booking success screen

---

# UX Improvements
- Bottom navigation shell
- Global error snackbars
- Offline error handling
- Loading indicators
- Empty state components
- Success screens
- Cached image loading with shimmer effect

---

# App Architecture

The app follows feature-first clean architecture principles.

lib/
│
├── app/
│   ├── router/
│   ├── shell/
│   ├── services/
│   └── network/
│
├── core/
│   ├── widgets/
│   ├── utils/
│   └── theme/
│
├── features/
│   ├── auth/
│   ├── services/
│   ├── cart/
│   ├── bookings/
│   └── profile/
│
└── main.dart



# Author

Sajith Madushanka