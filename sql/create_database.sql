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
DROP TABLE IF EXISTS user_notifications;
DROP TABLE IF EXISTS journey_edit_logs;
DROP TABLE IF EXISTS user_achievements;
DROP TABLE IF EXISTS achievements;
DROP TABLE IF EXISTS achievement_categories;
DROP TABLE IF EXISTS user_titles;
DROP TABLE IF EXISTS achievement_stats;
DROP TABLE IF EXISTS journey_views;
DROP TABLE IF EXISTS user_search_history;
DROP TABLE IF EXISTS user_logins;
DROP TABLE IF EXISTS event_images;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS journeys;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS subscription_record;
DROP TABLE IF EXISTS subscription_plans;
DROP TABLE IF EXISTS card_details;
DROP TABLE IF EXISTS billing_address;
DROP TABLE IF EXISTS announcements;
DROP TABLE IF EXISTS event_likes;
DROP TABLE IF EXISTS event_comments;

-- Create users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(320) NOT NULL UNIQUE COMMENT 'Maximum email address length according to RFC5321',
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    profile_image VARCHAR(255),
    description TEXT,
    role ENUM('admin', 'editor', 'moderator', 'support_staff', 'traveller') NOT NULL,
    status ENUM('active', 'blocked', 'banned', 'hidden') NOT NULL DEFAULT 'active',
    public_sharing ENUM('allowed', 'not_allowed') NOT NULL DEFAULT 'allowed',
    profile_visibility ENUM('public', 'private') NOT NULL DEFAULT 'private',
    is_premium BOOLEAN NOT NULL DEFAULT FALSE, -- Whether the user is a premium user
    used_free_trial BOOLEAN NOT NULL DEFAULT FALSE, -- Whether the user has used the free trial
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
    status ENUM('public', 'private', 'hidden', 'published') NOT NULL DEFAULT 'private',
    publish_date DATETIME DEFAULT NULL, -- Date when journey was first published
    latitude FLOAT,
    longitude FLOAT,
    no_edits BOOLEAN DEFAULT FALSE, -- Prevent edits by others (for paid subscribers/staff)
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_journey_status (status),
    INDEX idx_journey_publish_date (publish_date),
    city_name VARCHAR(100)
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
    destination VARCHAR(100),
    latitude FLOAT,
    longitude FLOAT,
    dest_latitude FLOAT,
    dest_longitude FLOAT,
    FOREIGN KEY (journey_id) REFERENCES journeys(journey_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create event_images table (supporting multiple images per event and cover image)
CREATE TABLE event_images (
    img_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    journey_id INT NOT NULL,
    img_path VARCHAR(255) NOT NULL,
    img_name VARCHAR(50),
    is_cover BOOLEAN DEFAULT FALSE, -- Whether this image is the cover image for the journey
    upload_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (journey_id) REFERENCES journeys(journey_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create subscription_plans table
CREATE TABLE subscription_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM ('1 month trial','1 month free', '3 months free', '12 months free', '1 month', '3 months', '12 months'),
    duration_months INT NOT NULL,
    price_ex_gst DECIMAL(10,2),
    price_inc_gst DECIMAL(10,2),
    discount_percent INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create card_details table
CREATE TABLE card_details (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    card_no VARCHAR(19) NOT NULL,
    card_name VARCHAR(100) NOT NULL,
    expiration_date VARCHAR(5) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create billing_address table
CREATE TABLE billing_address (
    billing_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    street VARCHAR(255),
    zip VARCHAR(10),
    country VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create subscription_record table
CREATE TABLE subscription_record (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    billing_id INT NOT NULL,
    card_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM ('Active','Expired','Pending'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    gift_by_admin BOOLEAN DEFAULT FALSE,
    admin_id INT,
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (billing_id) REFERENCES billing_address (billing_id),
    FOREIGN KEY (card_id) REFERENCES card_details (card_id),
    FOREIGN KEY (admin_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create announcements table
CREATE TABLE announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    start_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_edited_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    expire_at DATETIME,
    author_id INT,
    author_name VARCHAR(50) NOT NULL,
    priority INT NOT NULL DEFAULT 0,
    FOREIGN KEY (author_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create event_likes table
CREATE TABLE event_likes (
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create comments table
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    is_hidden BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create comment_reactions table
CREATE TABLE comment_reactions (
    reaction_id INT AUTO_INCREMENT PRIMARY KEY,
    comment_id INT NOT NULL,
    user_id INT NOT NULL,
    reaction_type ENUM('like', 'dislike') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_reaction (comment_id, user_id, reaction_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create comment_reports table
CREATE TABLE comment_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    comment_id INT NOT NULL,
    reporter_id INT NOT NULL,
    report_reason ENUM('abusive', 'offensive', 'spam') NOT NULL,
    report_status ENUM('pending', 'hidden', 'rejected', 'escalated', 'reviewed') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP NULL,
    reviewed_by INT NULL,
    FOREIGN KEY (comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE,
    FOREIGN KEY (reporter_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Chats table
CREATE TABLE chat (
    chat_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id_1 INT NOT NULL,
    user_id_2 INT NOT NULL,
    chat_history JSON
);

-- Create admin_notifications table
CREATE TABLE admin_notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('comment_report', 'report_escalated','chat_report') NOT NULL,
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Dual Nullable Foreign Keys
    related_comment_id INT DEFAULT NULL,
    related_chat_id INT DEFAULT NULL,

    -- Only one can be non-null at a time
    CHECK (
        (related_comment_id IS NOT NULL AND related_chat_id IS NULL) OR
        (related_comment_id IS NULL AND related_chat_id IS NOT NULL)
    ),

    FOREIGN KEY (related_comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE,
    FOREIGN KEY (related_chat_id) REFERENCES chat(chat_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create achievement_categories table
CREATE TABLE achievement_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create achievements table
CREATE TABLE achievements (
    achievement_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    icon_path VARCHAR(255),
    category_id INT NOT NULL,
    unlock_condition VARCHAR(255) NOT NULL,
    is_hidden BOOLEAN DEFAULT FALSE,
    is_premium BOOLEAN DEFAULT FALSE,
    reward_type ENUM('badge', 'title', 'feature_access', 'visual_effect') DEFAULT 'badge',
    reward_data JSON,
    valid_from TIMESTAMP NULL,
    valid_until TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES achievement_categories(category_id) ON DELETE CASCADE,
    INDEX idx_achievement_category (category_id),
    INDEX idx_achievement_premium (is_premium),
    INDEX idx_achievement_validity (valid_from, valid_until)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create user_achievements table
CREATE TABLE user_achievements (
    user_achievement_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress INT DEFAULT 0,
    is_displayed BOOLEAN DEFAULT TRUE,
    custom_title VARCHAR(100) NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_achievement (user_id, achievement_id),
    INDEX idx_user_achievements (user_id),
    INDEX idx_achievement_unlocked (achievement_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create user_titles table for achievement rewards
CREATE TABLE user_titles (
    title_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title_name VARCHAR(100) NOT NULL,
    title_type ENUM('achievement', 'location_expert', 'milestone', 'special') NOT NULL,
    title_data JSON,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT FALSE,
    source_achievement_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (source_achievement_id) REFERENCES achievements(achievement_id) ON DELETE SET NULL,
    INDEX idx_user_titles (user_id),
    INDEX idx_active_titles (user_id, is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create achicommentsevement_stats table for admin analytics
CREATE TABLE achievement_stats (
    stat_id INT AUTO_INCREMENT PRIMARY KEY,
    achievement_id INT NOT NULL,
    total_unlocks INT DEFAULT 0,
    unlock_rate DECIMAL(5,2) DEFAULT 0.00,
    avg_time_to_unlock INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id) ON DELETE CASCADE,
    INDEX idx_achievement_stats (achievement_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create journey views tracking table for achievement system
CREATE TABLE journey_views (
    view_id INT AUTO_INCREMENT PRIMARY KEY,
    viewer_id INT NOT NULL,
    journey_id INT NOT NULL,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (viewer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (journey_id) REFERENCES journeys(journey_id) ON DELETE CASCADE,
    UNIQUE KEY unique_view (viewer_id, journey_id),
    INDEX idx_viewer_views (viewer_id, viewed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create user search history table for achievement system
CREATE TABLE user_search_history (
    search_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    search_term VARCHAR(255),
    search_type VARCHAR(50) DEFAULT 'journey',
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_search (user_id, searched_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create user login history table for achievement system
CREATE TABLE user_logins (
    login_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    login_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45),
    user_agent TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_login_date (user_id, login_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `issues` (
  `issue_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `assigned_user_id` INT DEFAULT NULL,
  `summary` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('new', 'open', 'stalled', 'resolved') NOT NULL,
  `issue_type` ENUM('support', 'appeal') DEFAULT 'support',
  `appeal_type` ENUM('hidden_journey', 'sharing_blocked', 'account_banned') DEFAULT NULL,
  `related_journey_id` INT DEFAULT NULL,
  `auto_action_taken` BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (`issue_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`assigned_user_id`) REFERENCES `users`(`user_id`) ON DELETE SET NULL,
  FOREIGN KEY (`related_journey_id`) REFERENCES `journeys`(`journey_id`) ON DELETE SET NULL,
  INDEX `idx_issues_type` (`issue_type`),
  INDEX `idx_issues_appeal_type` (`appeal_type`),
  INDEX `idx_issues_journey` (`related_journey_id`)
);

CREATE TABLE `support_comments` ( 
  `comment_id` INT NOT NULL AUTO_INCREMENT,
  `issue_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `content` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  FOREIGN KEY (`issue_id`) REFERENCES `issues`(`issue_id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE
);

-- Create journey_edit_logs table for tracking all editing actions
CREATE TABLE journey_edit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    journey_id INT NOT NULL,
    editor_id INT NOT NULL,
    edit_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    change_type ENUM('text', 'location', 'image', 'status', 'events') NOT NULL,
    change_description TEXT NOT NULL,
    reason TEXT NOT NULL,
    old_value TEXT,
    new_value TEXT,
    FOREIGN KEY (journey_id) REFERENCES journeys(journey_id) ON DELETE CASCADE,
    FOREIGN KEY (editor_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_journey_logs (journey_id, edit_timestamp),
    INDEX idx_editor_logs (editor_id, edit_timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create user_notifications table for notifying users about changes
CREATE TABLE user_notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    notification_type ENUM('journey_edited', 'sharing_blocked', 'journey_hidden', 'account_banned', 'appeal_response') NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    related_journey_id INT DEFAULT NULL,
    related_editor_id INT DEFAULT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (related_journey_id) REFERENCES journeys(journey_id) ON DELETE SET NULL,
    FOREIGN KEY (related_editor_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_user_notifications (user_id, created_at),
    INDEX idx_unread_notifications (user_id, is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Note: The 'appeals' table has been removed as its functionality is now
-- integrated into the 'issues' table with issue_type = 'appeal'.
