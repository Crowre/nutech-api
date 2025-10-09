# Database Schema Documentation

## Overview
Complete database design for Nutech Integration API supporting all required features:
- User authentication and profiles
- Balance management with integer values
- PPOB payment services
- Transaction history with proper invoice handling
- Banner management system

## Table Relationships

```mermaid
erDiagram
    users ||--o{ balances : has
    users ||--o{ transactions : performs
    users {
        string email PK
        string password
        string first_name
        string last_name
        text profile_image
        timestamp created_on
        timestamp updated_on
    }
    
    balances {
        string email PK,FK
        int balance
        timestamp created_on
        timestamp updated_on
    }
    
    transactions {
        int id PK
        string invoice_number
        string email FK
        string service_code
        string service_name
        enum transaction_type
        int total_amount
        timestamp created_on
    }
    
    services {
        int id PK
        string service_code UK
        string service_name
        string service_icon
        int service_tariff
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }
    
    banners {
        int id PK
        string banner_name
        string banner_image
        text description
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }