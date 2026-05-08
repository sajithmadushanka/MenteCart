# MenteCart Backend API

Node.js + Express backend powering the MenteCart service booking platform.

This backend handles:
- Authentication
- Service management
- Cart management
- Booking lifecycle
- PayHere payment integration
- Slot capacity validation
- JWT authorization
- Booking cancellation
- Dockerized deployment

---

# Tech Stack

- Node.js
- Express.js
- TypeScript
- MongoDB Atlas
- Mongoose
- JWT Authentication
- bcrypt
- Docker
- PayHere Sandbox Integration

---

# Production Deployment

Hosted on Render:
`https://mentecart.onrender.com`

API Base URL
`https://mentecart.onrender.com/api`

local 
`http://localhost:4040`

API Base URL
`http://localhost:4040/api`


API Endpoints

# Local Development
Install Dependencies
npm install


add .env

Run Development Server
npm run dev

# to check payment getway localy you need to run # Cloudflared Tunnel 
(instead user docker all services deployed in there)

Docker Setup
docker compose up --build


# Credentials
Admin User  - only admin user can create service / delete service / update service
Email: `admin@mentecart.com`
Password: `Admin123!`


# API COLLECTION 
please use postman collection from root folder


# ENDPOINTS -----

Authentication

| Method | Endpoint               | Description                    |
| ------ | ---------------------- | ------------------------------ |
| POST   | `/api/auth/signup`     | Register a new user            |
| POST   | `/api/auth/login`      | User login                     |
| POST   | `/api/auth/refresh`    | Refresh access token           |
| POST   | `/api/auth/logout`     | Logout current session         |
| GET    | `/api/auth/logout-all` | Logout from all devices        |
| GET    | `/api/auth/me`         | Get authenticated user profile |

Services

| Method | Endpoint                                | Description          |
| ------ | --------------------------------------- | -------------------- |
| GET    | `/api/services`                         | Get all services     |
| GET    | `/api/services/:id`                     | Get service by ID    |
| POST   | `/api/services`                         | Create a new service |
| GET    | `/api/services?page=:page&limit=:limit` | Paginated services   |
| GET    | `/api/services?category=:category`      | Filter services      |
| GET    | `/api/services/search?q=:query`         | Search services      |
| PATCH  | `/api/services/:id`                     | Update service       |
| DELETE | `/api/services/:id`                     | Delete service       |

Cart

| Method | Endpoint              | Description      |
| ------ | --------------------- | ---------------- |
| GET    | `/api/cart`           | Get user cart    |
| POST   | `/api/cart/items`     | Add item to cart |
| PATCH  | `/api/cart/items/:id` | Update cart item |
| DELETE | `/api/cart/items/:id` | Remove cart item |

Bookings

| Method | Endpoint                   | Description                 |
| ------ | -------------------------- | --------------------------- |
| POST   | `/api/bookings/checkout`   | Checkout and create booking |
| GET    | `/api/bookings`            | Get all bookings            |
| GET    | `/api/bookings/:id`        | Get booking by ID           |
| PATCH  | `/api/bookings/:id/cancel` | Cancel booking              |
| GET    | `/api/bookings/payhere`    | PayHere payment integration |




| GET    | `/health` | Health check endpoint |


# Author

Sajith Madushanka