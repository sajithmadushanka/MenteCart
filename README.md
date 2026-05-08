# MenteCart — Service Booking Platform

MenteCart is a full-stack service booking application built with Flutter and Node.js.  
Users can browse services, add bookings to a cart, select dates and time slots, complete bookings using online payments, and manage their booking history.

This project was developed as part of the GlobalTNA Full Stack Flutter Developer Technical Assessment.

---

# Live Demo
https://youtu.be/QBT5qXSAtl8

## Backend API
https://mentecart.onrender.com

## Mobile App
Distributed through Google Play Internal App Sharing.
https://play.google.com/apps/test/RQtuUr5iWVE/ahAO29uNS8WkhMW8R36n78B41mtYGCt6DBQU5crNy8tClrA7p-9Zt1bz2ElGVnQw-uyT1pa3XCZEf-egsf1Wstppml
---

# Tech Stack

## Frontend (Mobile)
- Flutter
- Dart 3
- BLoC State Management
- GoRouter
- Dio
- Cached Network Image

## Backend
- Node.js
- Express.js
- TypeScript
- MongoDB Atlas
- JWT Authentication
- Docker

## Payments
- PayHere Sandbox Integration

## Deployment
- Render (Backend Hosting)
- MongoDB Atlas (Cloud Database)
- Docker Compose

---

# Features

## Authentication
- User signup and login
- JWT access authentication
- Refresh token flow
- Protected routes
- Persistent login session
- Logout support

## Services
- Browse services
- Service detail screen
- Search services
- Category filtering
- Cached service images
- Paginated API support

## Cart System
- Add service bookings to cart
- Date and time slot selection
- Quantity updates
- Remove cart items
- Capacity validation
- Running total calculation

## Booking System
- Checkout flow
- Booking lifecycle management
- Booking details screen
- Booking cancellation
- Booking history
- Payment status tracking

## Payments
- PayHere payment integration
- WebView payment flow
- Payment success handling
- Pending / paid booking states

## UX Improvements
- Global error handling
- Offline error messages
- Empty state components
- Loading indicators
- Bottom navigation shell
- Success screens
- Cached images with shimmer loading

## DevOps
- Dockerized backend
- Hosted production backend
- Environment configuration using --dart-define
- MongoDB Atlas integration

---

# System Architecture

Flutter Mobile App
        ↓
REST API (Node.js + Express)
        ↓
MongoDB Atlas



# Author

Sajith Madushanka

