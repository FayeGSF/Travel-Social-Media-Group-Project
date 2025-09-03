-- For local database (This will be executed in local environment)
-- USE Wanderlog;

-- Note: For PythonAnywhere, the database TeamCHC$Wanderlog should already be selected
-- when executing this script.

-- Clean existing data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE events;
TRUNCATE TABLE journeys;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- Inserting Travellers (20)
INSERT INTO users (username, password_hash, email, first_name, last_name, location, profile_image, description, role, status) 
VALUES 
('traveller01', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller1@wanderlog.com', 'John', 'Smith', 'New York', 'static/images/profileplaceholder.png', 'Hello, I am John Smith from New York.', 'traveller', 'active'),
('traveller02', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller2@wanderlog.com', 'Jane', 'Johnson', 'Los Angeles', 'static/images/profileplaceholder.png', 'Hello, I am Jane Johnson from Los Angeles.', 'traveller', 'active'),
('traveller03', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller3@wanderlog.com', 'Alex', 'Williams', 'Chicago', 'static/images/profileplaceholder.png', 'Hello, I am Alex Williams from Chicago.', 'traveller', 'active'),
('traveller04', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller4@wanderlog.com', 'Chris', 'Brown', 'Houston', 'static/images/profileplaceholder.png', 'Hello, I am Chris Brown from Houston.', 'traveller', 'active'),
('traveller05', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller5@wanderlog.com', 'Taylor', 'Jones', 'Phoenix', 'static/images/profileplaceholder.png', 'Hello, I am Taylor Jones from Phoenix.', 'traveller', 'active'),
('traveller06', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller6@wanderlog.com', 'Charlie', 'Evans', 'San Francisco', 'static/images/profileplaceholder.png', 'Hello, I am Charlie Evans from San Francisco.', 'traveller', 'active'),
('traveller07', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller7@wanderlog.com', 'Olivia', 'Moore', 'Seattle', 'static/images/profileplaceholder.png', 'Hello, I am Olivia Moore from Seattle.', 'traveller', 'active'),
('traveller08', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller8@wanderlog.com', 'Liam', 'White', 'Denver', 'static/images/profileplaceholder.png', 'Hello, I am Liam White from Denver.', 'traveller', 'active'),
('traveller09', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller9@wanderlog.com', 'Emma', 'Harris', 'Boston', 'static/images/profileplaceholder.png', 'Hello, I am Emma Harris from Boston.', 'traveller', 'active'),
('traveller10', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller10@wanderlog.com', 'Noah', 'Clark', 'Miami', 'static/images/profileplaceholder.png', 'Hello, I am Noah Clark from Miami.', 'traveller', 'active'),
('traveller11', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller11@wanderlog.com', 'Sophia', 'Lewis', 'Philadelphia', 'static/images/profileplaceholder.png', 'Hello, I am Sophia Lewis from Philadelphia.', 'traveller', 'active'),
('traveller12', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller12@wanderlog.com', 'Mason', 'Walker', 'Atlanta', 'static/images/profileplaceholder.png', 'Hello, I am Mason Walker from Atlanta.', 'traveller', 'active'),
('traveller13', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller13@wanderlog.com', 'Isabella', 'Hall', 'Las Vegas', 'static/images/profileplaceholder.png', 'Hello, I am Isabella Hall from Las Vegas.', 'traveller', 'active'),
('traveller14', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller14@wanderlog.com', 'James', 'Allen', 'Portland', 'static/images/profileplaceholder.png', 'Hello, I am James Allen from Portland.', 'traveller', 'active'),
('traveller15', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller15@wanderlog.com', 'Ava', 'Young', 'Minneapolis', 'static/images/profileplaceholder.png', 'Hello, I am Ava Young from Minneapolis.', 'traveller', 'active'),
('traveller16', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller16@wanderlog.com', 'Lucas', 'King', 'Detroit', 'static/images/profileplaceholder.png', 'Hello, I am Lucas King from Detroit.', 'traveller', 'active'),
('traveller17', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller17@wanderlog.com', 'Mia', 'Wright', 'Charlotte', 'static/images/profileplaceholder.png', 'Hello, I am Mia Wright from Charlotte.', 'traveller', 'active'),
('traveller18', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller18@wanderlog.com', 'Benjamin', 'Lopez', 'Orlando', 'static/images/profileplaceholder.png', 'Hello, I am Benjamin Lopez from Orlando.', 'traveller', 'active'),
('traveller19', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller19@wanderlog.com', 'Harper', 'Hill', 'Pittsburgh', 'static/images/profileplaceholder.png', 'Hello, I am Harper Hill from Pittsburgh.', 'traveller', 'active'),
('traveller20', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller20@wanderlog.com', 'Ethan', 'Scott', 'Nashville', 'static/images/profileplaceholder.png', 'Hello, I am Ethan Scott from Nashville.', 'traveller', 'active');

-- Inserting Editors (6)
INSERT INTO users (username, password_hash, email, first_name, last_name, location, profile_image, description, role, status) 
VALUES 
('editor01', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor1@wanderlog.com', 'Sam', 'Garcia', 'San Antonio', 'static/images/profileplaceholder.png', 'Hello, I am Sam Garcia from San Antonio.', 'editor', 'active'),
('editor02', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor2@wanderlog.com', 'Casey', 'Miller', 'San Diego', 'static/images/profileplaceholder.png', 'Hello, I am Casey Miller from San Diego.', 'editor', 'active'),
('editor03', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor3@wanderlog.com', 'Jordan', 'Davis', 'Dallas', 'static/images/profileplaceholder.png', 'Hello, I am Jordan Davis from Dallas.', 'editor', 'active'),
('editor04', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor4@wanderlog.com', 'Chloe', 'Adams', 'Kansas City', 'static/images/profileplaceholder.png', 'Hello, I am Chloe Adams from Kansas City.', 'editor', 'active'),
('editor05', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor5@wanderlog.com', 'Daniel', 'Baker', 'Columbus', 'static/images/profileplaceholder.png', 'Hello, I am Daniel Baker from Columbus.', 'editor', 'active'),
('editor06', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor6@wanderlog.com', 'Ella', 'Nelson', 'Indianapolis', 'static/images/profileplaceholder.png', 'Hello, I am Ella Nelson from Indianapolis.', 'editor', 'active');

-- Inserting Admins (3)
INSERT INTO users (username, password_hash, email, first_name, last_name, location, profile_image, description, role, status) 
VALUES 
('admin01', '$2b$12$op0ZsbL0o1KWmZ2w3i0TNe8Gl2zx4lMEUiynvDG5NrmXUWJcMB0bq', 'admin1@wanderlog.com', 'Morgan', 'Rodriguez', 'San Jose', 'static/images/profileplaceholder.png', 'Hello, I am Morgan Rodriguez from San Jose.', 'admin', 'active'),
('admin02', '$2b$12$op0ZsbL0o1KWmZ2w3i0TNe8Gl2zx4lMEUiynvDG5NrmXUWJcMB0bq', 'admin2@wanderlog.com', 'Drew', 'Martinez', 'Austin', 'static/images/profileplaceholder.png', 'Hello, I am Drew Martinez from Austin.', 'admin', 'active'),
('admin03', '$2b$12$op0ZsbL0o1KWmZ2w3i0TNe8Gl2zx4lMEUiynvDG5NrmXUWJcMB0bq', 'admin3@wanderlog.com', 'Jamie', 'Hernandez', 'Jacksonville', 'static/images/profileplaceholder.png', 'Hello, I am Jamie Hernandez from Jacksonville.', 'admin', 'active');

-- Insert journeys (15 public, 15 private)
-- First, get the user IDs
SET @traveller1_id = (SELECT user_id FROM users WHERE username = 'traveller01');
SET @traveller2_id = (SELECT user_id FROM users WHERE username = 'traveller02');
SET @traveller3_id = (SELECT user_id FROM users WHERE username = 'traveller03');
SET @traveller4_id = (SELECT user_id FROM users WHERE username = 'traveller04');
SET @traveller5_id = (SELECT user_id FROM users WHERE username = 'traveller05');
SET @traveller6_id = (SELECT user_id FROM users WHERE username = 'traveller06');
SET @traveller7_id = (SELECT user_id FROM users WHERE username = 'traveller07');
SET @traveller8_id = (SELECT user_id FROM users WHERE username = 'traveller08');
SET @traveller9_id = (SELECT user_id FROM users WHERE username = 'traveller09');
SET @traveller10_id = (SELECT user_id FROM users WHERE username = 'traveller10');

INSERT INTO journeys (user_id, title, location, description, start_date, status) 
VALUES 
-- Public journeys (1-15)
(@traveller1_id, 'Exploring New York', 'New York', 'A week-long journey exploring NYC attractions.', '2023-01-05 09:00:00', 'public'),
(@traveller1_id, 'Sunny Days in Los Angeles', 'Los Angeles', 'Enjoying the sunny beaches and Hollywood.', '2023-02-10 10:00:00', 'public'),
(@traveller2_id, 'Adventures in Chicago', 'Chicago', 'Discovering deep-dish pizza and architecture.', '2023-03-15 08:00:00', 'public'),
(@traveller2_id, 'Texas Road Trip', 'Houston', 'Exploring the big state of Texas.', '2023-04-20 07:00:00', 'public'),
(@traveller3_id, 'Miami Beach Getaway', 'Miami', 'Relaxing at the famous Miami beaches.', '2023-05-18 11:00:00', 'public'),
(@traveller3_id, 'Boston Historical Tour', 'Boston', 'Visiting historic sites and universities.', '2023-06-12 09:00:00', 'public'),
(@traveller4_id, 'Seattle Coffee Culture', 'Seattle', 'Exploring coffee shops and markets.', '2023-07-07 10:00:00', 'public'),
(@traveller4_id, 'Denver Mountain Escape', 'Denver', 'Hiking and enjoying the mountains.', '2023-08-01 08:00:00', 'public'),
(@traveller5_id, 'Las Vegas Casino Experience', 'Las Vegas', 'Trying my luck in the casinos.', '2023-09-03 14:00:00', 'public'),
(@traveller5_id, 'San Francisco Bay Adventure', 'San Francisco', 'Enjoying the Golden Gate Bridge and Alcatraz.', '2023-10-08 09:00:00', 'public'),
(@traveller6_id, 'Washington DC Museums', 'Washington DC', 'Exploring the Smithsonian museums.', '2023-11-15 10:00:00', 'public'),
(@traveller6_id, 'New Orleans Jazz Fest', 'New Orleans', 'Experiencing the famous jazz scene.', '2023-12-05 16:00:00', 'public'),
(@traveller7_id, 'Portland Nature Escape', 'Portland', 'Hiking and enjoying craft beer.', '2023-12-12 08:00:00', 'public'),
(@traveller7_id, 'San Diego Beach Trip', 'San Diego', 'Surfing and enjoying the warm sun.', '2023-12-20 09:00:00', 'public'),
(@traveller8_id, 'Phoenix Desert Adventure', 'Phoenix', 'Exploring the desert landscape.', '2023-12-28 07:00:00', 'public'),
-- Private journeys (16-30)
(@traveller8_id, 'Weekend in Austin', 'Austin', 'Enjoying live music and BBQ.', '2023-12-30 11:00:00', 'private'),
(@traveller9_id, 'Nashville Country Music Tour', 'Nashville', 'Exploring country music and food.', '2023-12-31 13:00:00', 'private'),
(@traveller9_id, 'Philadelphia History Tour', 'Philadelphia', 'Visiting historical landmarks.', '2023-12-31 09:00:00', 'private'),
(@traveller10_id, 'Detroit Auto Experience', 'Detroit', 'Exploring car history and culture.', '2023-12-31 10:00:00', 'private'),
(@traveller10_id, 'Salt Lake City Skiing', 'Salt Lake City', 'Hitting the slopes and enjoying winter.', '2023-12-31 08:00:00', 'private'),
(@traveller1_id, 'Orlando Theme Park Trip', 'Orlando', 'Visiting Disney and Universal Studios.', '2023-12-31 09:00:00', 'private'),
(@traveller2_id, 'Charlotte Food Tasting', 'Charlotte', 'Exploring the diverse food scene.', '2023-12-31 12:00:00', 'private'),
(@traveller3_id, 'Minneapolis Winter Wonderland', 'Minneapolis', 'Enjoying snow and winter festivals.', '2023-12-31 10:00:00', 'private'),
(@traveller4_id, 'Pittsburgh Bridge Tour', 'Pittsburgh', 'Walking across the iconic bridges.', '2023-12-31 09:00:00', 'private'),
(@traveller5_id, 'Indianapolis Speedway Experience', 'Indianapolis', 'Visiting the Indianapolis 500 track.', '2023-12-31 08:00:00', 'private'),
(@traveller6_id, 'Kansas City BBQ Crawl', 'Kansas City', 'Tasting famous Kansas City BBQ.', '2023-12-31 11:00:00', 'private'),
(@traveller7_id, 'Columbus Art Tour', 'Columbus', 'Exploring museums and street art.', '2023-12-31 10:00:00', 'private'),
(@traveller8_id, 'St. Louis Gateway Arch Visit', 'St. Louis', 'Seeing the Gateway Arch and city sights.', '2023-12-31 09:00:00', 'private'),
(@traveller9_id, 'Sacramento Wine Tasting', 'Sacramento', 'Visiting local wineries and vineyards.', '2023-12-31 11:00:00', 'private'),
(@traveller10_id, 'Albuquerque Balloon Fiesta', 'Albuquerque', 'Watching the hot air balloon festival.', '2023-12-31 06:00:00', 'private');

-- Insert events for each journey with existing images
INSERT INTO events (journey_id, user_id, title, location, event_image, description, start_date, end_date)
WITH numbered_events AS (
    SELECT 
        j.journey_id,
        j.user_id,
        CONCAT('Event ', ROW_NUMBER() OVER (PARTITION BY j.journey_id ORDER BY j.journey_id)) as title,
        j.location,
        ROW_NUMBER() OVER (ORDER BY j.start_date, j.journey_id) as global_event_number,
        CONCAT('Description for event ', ROW_NUMBER() OVER (PARTITION BY j.journey_id ORDER BY j.journey_id)) as description,
        CONVERT_TZ(DATE_ADD(j.start_date, INTERVAL (ROW_NUMBER() OVER (PARTITION BY j.journey_id ORDER BY j.journey_id) - 1) * 3 HOUR), 'UTC', '+12:00') as start_date,
        CONVERT_TZ(DATE_ADD(j.start_date, INTERVAL (ROW_NUMBER() OVER (PARTITION BY j.journey_id ORDER BY j.journey_id) - 1) * 3 + 2 HOUR), 'UTC', '+12:00') as end_date
    FROM 
        journeys j
    CROSS JOIN 
        (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8) numbers
)
SELECT 
    journey_id,
    user_id,
    title,
    location,
    CASE 
        WHEN global_event_number <= 30 THEN
            CONCAT('images/event', global_event_number, '.jpg')
        ELSE ''
    END as event_image,
    description,
    start_date,
    end_date
FROM numbered_events; 

-- subscription plans

INSERT INTO subscription_plans (type, price_ex_gst, price_inc_gst, discount_percent, is_trial)
VALUES
  -- Free Trials
  ('1 month', NULL, NULL, NULL, TRUE),
  ('3 months', NULL, NULL, NULL, TRUE),
  ('12 months', NULL, NULL, NULL, TRUE),

  -- Paid Plans
  ('1 month', 5.22, 6.00, NULL, FALSE),
  ('3 months', 14.09, 16.20, 10.00, FALSE),
  ('12 months', 46.96, 54.00, 25.00, FALSE);
  
  -- subscriptions
INSERT INTO subscriptions (user_id, plan_id, amount, gst_included, biling_address, start_date, end_date, status)
VALUES
(1, 1, 0.00, 'No', '123 Queen St, Auckland, New Zealand', '2025-05-06', '2025-06-06', 'Active'),
(2, 2, 0.00, 'No', '456 Market St, San Francisco, USA', '2025-05-06', '2025-08-06', 'Active'),
(3, 3, 0.00, 'No', '789 Oxford St, London, UK', '2025-05-06', '2026-05-06', 'Active');

-- Paid 1-Month Subscription (plan_id 4) for Users 4–6
INSERT INTO subscriptions (user_id, plan_id, amount, gst_included, biling_address, start_date, end_date, status)
VALUES
(4, 4, 6.00, 'Yes-15%', '321 Lambton Quay, Wellington, New Zealand', '2025-05-06', '2025-06-06', 'Active'),
(5, 4, 5.22, 'No', '101 Champs-Élysées, Paris, France', '2025-05-06', '2025-06-06', 'Active'),
(6, 4, 5.22, 'No', '45 Broadway St, New York, USA', '2025-05-06', '2025-06-06', 'Active');

-- Paid 3-Month Subscription (plan_id 5) for Users 7–9
INSERT INTO subscriptions (user_id, plan_id, amount, gst_included, biling_address, start_date, end_date, status)
VALUES
(7, 5, 14.09, 'No', '22 Nathan Rd, Hong Kong', '2025-05-06', '2025-08-06', 'Active'),
(8, 5, 16.20, 'Yes-15%', '88 Cashel St, Christchurch, New Zealand', '2025-05-06', '2025-08-06', 'Active'),
(9, 5, 14.09, 'No', '15 King St, Sydney, Australia', '2025-05-06', '2025-08-06', 'Active');

-- Paid 12-Month Subscription (plan_id 6) for Users 10–17
INSERT INTO subscriptions (user_id, plan_id, amount, gst_included, biling_address, start_date, end_date, status)
VALUES
(10, 6, 54.00, 'Yes-15%', '101 Victoria Rd, Auckland, New Zealand', '2025-05-06', '2026-05-06', 'Active'),
(11, 6, 46.96, 'No', '50 George St, Edinburgh, UK', '2025-05-06', '2026-05-06', 'Active'),
(12, 6, 54.00, 'Yes-15%', '123 Queen St, Wellington, New Zealand', '2025-05-06', '2026-05-06', 'Active'),
(13, 6, 46.96, 'No', '42 Yonge St, Toronto, Canada', '2025-05-06', '2026-05-06', 'Active'),
(14, 6, 46.96, 'No', '78 Collins St, Melbourne, Australia', '2025-05-06', '2026-05-06', 'Active'),
(15, 6, 46.96, 'No', '99 Orchard Rd, Singapore', '2025-05-06', '2026-05-06', 'Active'),
(16, 6, 46.96, 'No', '33 Union Square, New York, USA', '2025-05-06', '2026-05-06', 'Active'),
(17, 6, 46.96, 'No', '100 Park Ave, Paris, France', '2025-05-06', '2026-05-06', 'Active');

INSERT INTO subscriptions (user_id, plan_id, amount, gst_included, biling_address, start_date, end_date, status)
VALUES
(18, 1, 0.00, 'No', '222 Victoria St, Auckland, New Zealand', '2025-03-06', '2025-03-06', 'Expired'),
(19, 2, 0.00, 'No', '101 Baker St, London, UK', '2025-02-06', '2025-05-06', 'Expired'),
(20, 3, 0.00, 'No', '555 High St, Melbourne, Australia', '2025-04-06', '2025-04-06', 'Expired');