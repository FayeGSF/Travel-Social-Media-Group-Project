-- Set character set
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Create and use database based on environment
-- For local environment, create database
DROP DATABASE IF EXISTS Wanderlog;
CREATE DATABASE Wanderlog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE Wanderlog;

-- Note: For PythonAnywhere, the database TeamCHC$Wanderlog should already exist
-- and this script should be executed with that database already selected.

-- Drop existing tables if they exist
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS journeys;
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    profile_image VARCHAR(255),
    description TEXT,
    role ENUM('admin', 'editor', 'traveller') NOT NULL,
    status ENUM('active', 'blocked', 'banned') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    action_history TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create journeys table
CREATE TABLE journeys (
    journey_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATETIME NOT NULL,
    last_edited TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status ENUM('public', 'private') NOT NULL DEFAULT 'private',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create events table
CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    journey_id INT NOT NULL,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    event_image VARCHAR(255),
    description TEXT,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    last_edited TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (journey_id) REFERENCES journeys(journey_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci; 

CREATE TABLE subscription_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('1 month','3 months', '12 months'),  
    price_ex_gst DECIMAL(10,2),         
    price_inc_gst DECIMAL(10,2),                      
    discount_percent INT,   
    is_trial BOOLEAN DEFAULT FALSE       
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci; 

CREATE TABLE subscriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    amount DECIMAL (10,2),
    gst_included ENUM('Yes-15%','No'),
    biling_address VARCHAR (100),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM ('Active','Expired'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci; 