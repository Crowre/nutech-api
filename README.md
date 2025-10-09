# 🚀 Nutech Integration API

Digital Wallet and Payment Services API built with Node.js, Express, and MySQL.

## Features

- 🔐 JWT Authentication
- 💰 Balance Management & Top Up
- 🛍️ PPOB Payment Services
- 📊 Transaction History
- 👤 Profile Management
- 📱 Banner System

## Quick Start

\`\`\`bash
npm install
# Edit .env with your database configuration
npm run dev
\`\`\`

## API Documentation

### Public Endpoints
- \`GET /banner\` - Get banners
- \`POST /auth/registration\` - User registration  
- \`POST /auth/login\` - User login

### Private Endpoints
- \`GET /profile\` - Get profile
- \`PUT /profile/update\` - Update profile
- \`GET /balance\` - Get balance
- \`POST /balance/topup\` - Top up balance
- \`GET /service\` - Get services
- \`POST /transaction\` - Create transaction
- \`GET /history\` - Get history

## Tech Stack

- Node.js, Express.js
- MySQL Database
- JWT Authentication
- Multer for file uploads
