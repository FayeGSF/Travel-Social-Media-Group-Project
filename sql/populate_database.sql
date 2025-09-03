USE Wanderlog;

-- Clean existing data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE user_notifications;
TRUNCATE TABLE journey_edit_logs;
TRUNCATE TABLE user_achievements;
TRUNCATE TABLE achievements;
TRUNCATE TABLE achievement_categories;
TRUNCATE TABLE event_images;
TRUNCATE TABLE events;
TRUNCATE TABLE journeys;
TRUNCATE TABLE comments;
TRUNCATE TABLE comment_reactions;
TRUNCATE TABLE comment_reports;
TRUNCATE TABLE admin_notifications;
TRUNCATE TABLE event_likes;
TRUNCATE TABLE subscription_record;
TRUNCATE TABLE card_details;
TRUNCATE TABLE billing_address;
TRUNCATE TABLE announcements;
TRUNCATE TABLE users;
TRUNCATE TABLE journey_views;
TRUNCATE TABLE user_search_history;
TRUNCATE TABLE user_logins;
SET FOREIGN_KEY_CHECKS = 1;

-- Insert 20 traveller users with different subscription status
INSERT INTO users (username, password_hash, email, first_name, last_name, location, profile_image, description, role, status, is_premium, used_free_trial, profile_visibility)
VALUES
-- Premium users (with active subscriptions)
('traveller01', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller1@wanderlog.com', 'John', 'Smith', 'Auckland', 'static/images/avatars/profileplaceholder.png', 'Adventure seeker exploring New Zealand.', 'traveller', 'active', 1, 1, 'public'),
('traveller02', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller2@wanderlog.com', 'Jane', 'Johnson', 'Wellington', 'static/images/avatars/profileplaceholder.png', 'Photography enthusiast and travel blogger.', 'traveller', 'active', 1, 1, 'public'),
('traveller03', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller3@wanderlog.com', 'Mike', 'Williams', 'Christchurch', 'static/images/avatars/profileplaceholder.png', 'Nature lover and hiking expert.', 'traveller', 'active', 1, 0, 'public'),

-- Free trial users
('traveller04', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller4@wanderlog.com', 'Sarah', 'Brown', 'Queenstown', 'static/images/avatars/profileplaceholder.png', 'Extreme sports enthusiast.', 'traveller', 'active', 0, 1, 'public'),
('traveller05', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller5@wanderlog.com', 'David', 'Jones', 'Rotorua', 'static/images/avatars/profileplaceholder.png', 'Cultural explorer interested in Maori heritage.', 'traveller', 'active', 0, 1, 'public'),

-- Regular free users
('traveller06', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller6@wanderlog.com', 'Emma', 'Evans', 'Dunedin', 'static/images/avatars/profileplaceholder.png', 'Student exploring New Zealand on a budget.', 'traveller', 'active', 0, 0, 'public'),
('traveller07', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller7@wanderlog.com', 'Tom', 'Moore', 'Hamilton', 'static/images/avatars/profileplaceholder.png', 'Food lover and casual traveler.', 'traveller', 'active', 0, 0, 'private'),
('traveller08', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller8@wanderlog.com', 'Lisa', 'White', 'Tauranga', 'static/images/avatars/profileplaceholder.png', 'Beach enthusiast and surfer.', 'traveller', 'active', 0, 0, 'public'),
('traveller09', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller9@wanderlog.com', 'Alex', 'Harris', 'Napier', 'static/images/avatars/profileplaceholder.png', 'Art deco architecture fan.', 'traveller', 'active', 0, 0, 'public'),
('traveller10', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller10@wanderlog.com', 'Kate', 'Clark', 'Nelson', 'static/images/avatars/profileplaceholder.png', 'Wine enthusiast and foodie.', 'traveller', 'active', 0, 0, 'public'),

-- Additional users for testing
('traveller11', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller11@wanderlog.com', 'Ryan', 'Taylor', 'Wanaka', 'static/images/avatars/profileplaceholder.png', 'Mountain climber and photographer.', 'traveller', 'active', 0, 0, 'private'),
('traveller12', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller12@wanderlog.com', 'Amy', 'Davis', 'Palmerston North', 'static/images/avatars/profileplaceholder.png', 'University student and travel blogger.', 'traveller', 'active', 0, 0, 'public'),
('traveller13', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller13@wanderlog.com', 'Ben', 'Wilson', 'New Plymouth', 'static/images/avatars/profileplaceholder.png', 'Adventure sports enthusiast.', 'traveller', 'active', 0, 0, 'public'),
('traveller14', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller14@wanderlog.com', 'Sophie', 'Anderson', 'Invercargill', 'static/images/avatars/profileplaceholder.png', 'Southern region explorer.', 'traveller', 'active', 0, 0, 'private'),
('traveller15', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller15@wanderlog.com', 'Chris', 'Thomas', 'Gisborne', 'static/images/avatars/profileplaceholder.png', 'Sunrise enthusiast and early riser.', 'traveller', 'active', 0, 0, 'public'),

-- Additional 5 traveller users to reach 20 total
('traveller16', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller16@wanderlog.com', 'Maya', 'Singh', 'Taupo', 'static/images/avatars/profileplaceholder.png', 'Thermal springs enthusiast and wellness traveler.', 'traveller', 'active', 0, 0, 'public'),
('traveller17', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller17@wanderlog.com', 'Lucas', 'Chen', 'Picton', 'static/images/avatars/profileplaceholder.png', 'Ferry enthusiast and coastal explorer.', 'traveller', 'active', 0, 0, 'public'),
('traveller18', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller18@wanderlog.com', 'Zoe', 'Murphy', 'Franz Josef', 'static/images/avatars/profileplaceholder.png', 'Glacier explorer and adventure photographer.', 'traveller', 'active', 0, 0, 'private'),
('traveller19', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller19@wanderlog.com', 'Ethan', 'Lee', 'Kaikoura', 'static/images/avatars/profileplaceholder.png', 'Marine wildlife enthusiast and whale watching expert.', 'traveller', 'active', 0, 0, 'public'),
('traveller20', '$2b$12$lcaTnkzHu57r2o/rs3e8COx9gUiOWGqodVvE/RNVGAzVplIjX6lOK', 'traveller20@wanderlog.com', 'Aria', 'Patel', 'Oamaru', 'static/images/avatars/profileplaceholder.png', 'Penguin colony observer and wildlife photographer.', 'traveller', 'active', 0, 0, 'public');

-- Insert 6 editor users (no journeys)
INSERT INTO users (username, password_hash, email, first_name, last_name, location, profile_image, description, role, is_premium, status, profile_visibility)
VALUES
('editor01', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor1@wanderlog.com', 'Sam', 'Garcia', 'Auckland', 'static/images/avatars/profileplaceholder.png', 'Content curator and travel guide author.', 'editor', 1, 'active', 'public'),
('editor02', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor2@wanderlog.com', 'Casey', 'Miller', 'Wellington', 'static/images/avatars/profileplaceholder.png', 'Travel content specialist.', 'editor', 1, 'active', 'public'),
('editor03', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor3@wanderlog.com', 'Jordan', 'Davis', 'Christchurch', 'static/images/avatars/profileplaceholder.png', 'Digital marketing expert for travel industry.', 'editor', 1, 'active', 'public'),
('editor04', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor4@wanderlog.com', 'Chloe', 'Adams', 'Queenstown', 'static/images/avatars/profileplaceholder.png', 'Adventure tourism content creator.', 'editor', 1, 'active', 'public'),
('editor05', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor5@wanderlog.com', 'Daniel', 'Baker', 'Rotorua', 'static/images/avatars/profileplaceholder.png', 'Cultural heritage content specialist.', 'editor', 1, 'active', 'public'),
('editor06', '$2b$12$wLA2vOn6.ZUuZqSk4Av6tuNNuduNBCKycFuyVSugtDkk0lrS4m93K', 'editor6@wanderlog.com', 'Ella', 'Nelson', 'Dunedin', 'static/images/avatars/profileplaceholder.png', 'Food and wine tourism editor.', 'editor', 1, 'active', 'public');

-- Insert 3 admin users (no journeys)
INSERT INTO users (username, password_hash, email, first_name, last_name, location, profile_image, description, role, is_premium, status, profile_visibility)
VALUES
('admin01', '$2b$12$op0ZsbL0o1KWmZ2w3i0TNe8Gl2zx4lMEUiynvDG5NrmXUWJcMB0bq', 'admin1@wanderlog.com', 'Morgan', 'Rodriguez', 'Auckland', 'static/images/avatars/profileplaceholder.png', 'Platform administrator and system manager.', 'admin', 1, 'active', 'public'),
('admin02', '$2b$12$op0ZsbL0o1KWmZ2w3i0TNe8Gl2zx4lMEUiynvDG5NrmXUWJcMB0bq', 'admin2@wanderlog.com', 'Drew', 'Martinez', 'Wellington', 'static/images/avatars/profileplaceholder.png', 'Technical operations manager.', 'admin', 1, 'active', 'public'),
('admin03', '$2b$12$op0ZsbL0o1KWmZ2w3i0TNe8Gl2zx4lMEUiynvDG5NrmXUWJcMB0bq', 'admin3@wanderlog.com', 'Jamie', 'Hernandez', 'Christchurch', 'static/images/avatars/profileplaceholder.png', 'User experience and content administrator.', 'admin', 1, 'active', 'public');

-- Get user IDs for travellers (will be used for journeys)
SET @user1 = (SELECT user_id FROM users WHERE username = 'traveller01');
SET @user2 = (SELECT user_id FROM users WHERE username = 'traveller02');
SET @user3 = (SELECT user_id FROM users WHERE username = 'traveller03');
SET @user4 = (SELECT user_id FROM users WHERE username = 'traveller04');
SET @user5 = (SELECT user_id FROM users WHERE username = 'traveller05');
SET @user6 = (SELECT user_id FROM users WHERE username = 'traveller06');
SET @user7 = (SELECT user_id FROM users WHERE username = 'traveller07');
SET @user8 = (SELECT user_id FROM users WHERE username = 'traveller08');
SET @user9 = (SELECT user_id FROM users WHERE username = 'traveller09');
SET @user10 = (SELECT user_id FROM users WHERE username = 'traveller10');

-- Create journeys for traveller users only
INSERT INTO journeys (user_id, title, location, description, start_date, status, latitude, longitude) VALUES
-- Premium users journeys (multiple journeys)
(@user1, 'Exploring Auckland City', 'Auckland', 'A comprehensive exploration of Auckland urban life and coastal beauty.', '2024-01-15 09:00:00', 'public', -36.8485, 174.7633),
(@user1, 'Rotorua Thermal Adventure', 'Rotorua', 'Discovering geothermal wonders and Māori culture in Rotorua.', '2024-03-20 10:00:00', 'public', -38.1368, 176.2497),
(@user1, 'Coromandel Peninsula Discovery', 'Coromandel', 'Exploring pristine beaches and forest trails of Coromandel.', '2024-04-10 08:30:00', 'published', -36.7654, 175.4950),
(@user1, 'Christchurch Location Expert Test', 'Christchurch', 'Testing Location Expert achievement with multiple Christchurch events.', '2024-05-01 09:00:00', 'public', -43.5321, 172.6362);

-- Update 3 Christchurch journeys for traveller01
INSERT INTO journeys (user_id, title, location, description, start_date, status, city_name, latitude, longitude) VALUES
(@user1, 'Christchurch Airport Exploration', 'Christchurch Airport', 'Exploring the facilities and surroundings of Christchurch Airport.', '2024-09-15 09:00:00', 'public', 'Christchurch', -43.4894, 172.5329),
(@user1, 'Hagley Park Walk', 'Hagley Park', 'Enjoying a relaxing walk in the heart of Christchurch at Hagley Park.', '2024-09-20 10:00:00', 'public', 'Christchurch', -43.5308, 172.6203),
(@user1, 'Lyttelton Port Adventure', 'Lyttelton Port', 'Discovering the bustling activities at Lyttelton Port.', '2024-09-25 11:00:00', 'public', 'Christchurch', -43.6008, 172.7190);

-- Update 2 Selwyn District journeys for traveller01
INSERT INTO journeys (user_id, title, location, description, start_date, status, city_name, latitude, longitude) VALUES
(@user1, 'Prebbleton Nature Retreat', 'Prebbleton', 'Relaxing in the serene environment of Prebbleton.', '2024-10-01 09:00:00', 'public', 'Selwyn District', -43.5667, 172.5144),
(@user1, 'Rolleston Adventure Park', 'Rolleston', 'Enjoying thrilling activities in Rolleston Adventure Park.', '2024-10-05 10:00:00', 'public', 'Selwyn District', -43.5860, 172.3830);

-- traveller02: 3 New Zealand journeys
INSERT INTO journeys (user_id, title, location, description, start_date, status, city_name, latitude, longitude) VALUES
(@user2, 'Wellington City Explorer', 'Wellington', 'Discovering the capital city of New Zealand.', '2023-04-01 09:00:00', 'public', 'Wellington', -41.2865, 174.7762),
(@user2, 'Queenstown Adventure', 'Queenstown', 'Thrilling activities in the adventure capital.', '2023-05-10 10:00:00', 'public', 'Queenstown', -45.0312, 168.6626),
(@user2, 'Christchurch Garden Tour', 'Christchurch', 'Exploring the beautiful gardens of Christchurch.', '2023-06-15 11:00:00', 'public', 'Christchurch', -43.5321, 172.6362);

-- traveller03: 3 New Zealand journeys
INSERT INTO journeys (user_id, title, location, description, start_date, status, city_name, latitude, longitude) VALUES
(@user3, 'Nelson Sunshine Trip', 'Nelson', 'Enjoying the most sunshine hours in New Zealand.', '2023-07-20 09:00:00', 'public', 'Nelson', -41.2706, 173.2839),
(@user3, 'Wanaka Lake Views', 'Wanaka', 'Spectacular lake and mountain scenery.', '2023-08-25 10:00:00', 'public', 'Wanaka', -44.6985, 169.1374),
(@user3, 'Dunedin Scottish Heritage', 'Dunedin', 'Experiencing New Zealand''s Scottish heritage city.', '2023-09-30 11:00:00', 'public', 'Dunedin', -45.8788, 170.5028);

-- traveller04: 2 New Zealand journeys
INSERT INTO journeys (user_id, title, location, description, start_date, status, city_name, latitude, longitude) VALUES
(@user4, 'Bay of Islands Cruise', 'Bay of Islands', 'Sailing through the beautiful Bay of Islands.', '2023-10-05 09:00:00', 'public', 'Bay of Islands', -35.2778, 174.0910),
(@user4, 'Napier Art Deco Tour', 'Napier', 'Exploring the Art Deco architecture of Napier.', '2023-11-10 10:00:00', 'public', 'Napier', -39.4928, 176.9120);

-- traveller05: 3 international journeys
INSERT INTO journeys (user_id, title, location, description, start_date, status, city_name, latitude, longitude) VALUES
(@user5, 'Sydney Opera House Visit', 'Sydney', 'Exploring the iconic Sydney Opera House.', '2023-12-15 09:00:00', 'public', 'Sydney', -33.8688, 151.2093),
(@user5, 'Tokyo City Lights', 'Tokyo', 'Experiencing the vibrant nightlife of Tokyo.', '2024-01-20 10:00:00', 'public', 'Tokyo', 35.6895, 139.6917),
(@user5, 'Paris Romance', 'Paris', 'Romantic journey through the city of love.', '2024-02-25 11:00:00', 'public', 'Paris', 48.8566, 2.3522);

-- traveller06: 2 international journeys
INSERT INTO journeys (user_id, title, location, description, start_date, status, city_name, latitude, longitude) VALUES
(@user6, 'New York City Skyscrapers', 'New York', 'Admiring the impressive skyscrapers of New York.', '2024-03-01 09:00:00', 'public', 'New York', 40.7128, -74.0060),
(@user6, 'London Historical Tour', 'London', 'Exploring the rich history of London.', '2024-04-05 10:00:00', 'public', 'London', 51.5074, -0.1278);

INSERT INTO journeys (user_id, title, location, description, start_date, status, latitude, longitude) VALUES
(@user2, 'Wellington Capital Experience', 'Wellington', 'Exploring New Zealand capital culture and harbor views.', '2024-02-01 10:30:00', 'public', -41.2865, 174.7762),
(@user2, 'Queenstown Adventure Weekend', 'Queenstown', 'Thrilling adventures in the adventure capital of the world.', '2024-03-15 09:00:00', 'published', -45.0312, 168.6626),
(@user2, 'Milford Sound Journey', 'Milford Sound', 'Experiencing the breathtaking fiords of Milford Sound.', '2024-04-25 07:00:00', 'public', -44.6714, 167.9251),
(@user3, 'Christchurch Garden City', 'Christchurch', 'Exploring the rebuilt garden city and its cultural renaissance.', '2024-01-25 11:00:00', 'public', -43.5321, 172.6362),
(@user3, 'Banks Peninsula Explorer', 'Akaroa', 'Discovering French heritage and scenic beauty of Banks Peninsula.', '2024-04-05 09:30:00', 'public', -43.8041, 172.9684),
-- Trial users journeys
(@user4, 'Queenstown Extreme Sports', 'Queenstown', 'Bungee jumping, skydiving and extreme adventures.', '2024-02-10 08:00:00', 'public', -45.0312, 168.6626),
(@user4, 'Central Otago Wine Trail', 'Central Otago', 'Tasting premium wines in stunning Central Otago vineyards.', '2024-04-15 10:00:00', 'published', -45.0000, 169.0000),
(@user5, 'Rotorua Cultural Heritage', 'Rotorua', 'Deep dive into Māori culture and traditional experiences.', '2024-03-01 10:00:00', 'public', -38.1368, 176.2497),
-- Free users journeys
(@user6, 'Dunedin Student Life', 'Dunedin', 'Budget-friendly exploration of Dunedin student culture.', '2024-01-30 12:00:00', 'public', -45.8788, 170.5028),
(@user7, 'Hamilton Food Scene', 'Hamilton', 'Discovering local cuisine and food culture in Hamilton.', '2024-02-20 11:30:00', 'private', -37.7879, 175.2793),
(@user8, 'Tauranga Beach Adventures', 'Tauranga', 'Surfing and beach activities around Tauranga region.', '2024-03-10 07:30:00', 'public', -37.6878, 176.1651),
(@user9, 'Napier Art Deco Weekend', 'Napier', 'Exploring the famous Art Deco architecture of Napier.', '2024-02-25 09:00:00', 'public', -39.4928, 176.9120),
(@user10, 'Nelson Wine & Food Festival', 'Nelson', 'Enjoying the best wines and local produce in Nelson.', '2024-04-20 10:30:00', 'public', -41.2706, 173.2840);

-- Get journey IDs for events
SET @j1 = (SELECT journey_id FROM journeys WHERE user_id = @user1 ORDER BY start_date LIMIT 1);
SET @j2 = (SELECT journey_id FROM journeys WHERE user_id = @user1 ORDER BY start_date LIMIT 1 OFFSET 1);
SET @j3 = (SELECT journey_id FROM journeys WHERE user_id = @user1 ORDER BY start_date LIMIT 1 OFFSET 2);
SET @j4_christchurch = (SELECT journey_id FROM journeys WHERE user_id = @user1 ORDER BY start_date LIMIT 1 OFFSET 3);
SET @j4 = (SELECT journey_id FROM journeys WHERE user_id = @user2 ORDER BY start_date LIMIT 1);
SET @j5 = (SELECT journey_id FROM journeys WHERE user_id = @user2 ORDER BY start_date LIMIT 1 OFFSET 1);
SET @j6 = (SELECT journey_id FROM journeys WHERE user_id = @user2 ORDER BY start_date LIMIT 1 OFFSET 2);
SET @j7 = (SELECT journey_id FROM journeys WHERE user_id = @user3 ORDER BY start_date LIMIT 1);
SET @j8 = (SELECT journey_id FROM journeys WHERE user_id = @user3 ORDER BY start_date LIMIT 1 OFFSET 1);
SET @j9 = (SELECT journey_id FROM journeys WHERE user_id = @user4 ORDER BY start_date LIMIT 1);
SET @j10 = (SELECT journey_id FROM journeys WHERE user_id = @user4 ORDER BY start_date LIMIT 1 OFFSET 1);

-- Create events for journeys (each journey gets 4-6 events)
INSERT INTO events (journey_id, user_id, title, location, description, start_date, end_date, latitude, longitude) VALUES
-- Journey 1 events (Auckland)
(@j1, @user1, 'Sky Tower Visit', 'Auckland', 'Visiting Auckland iconic Sky Tower and observation deck.', '2024-01-15 10:00:00', '2024-01-15 12:00:00', -36.8485, 174.7633),
(@j1, @user1, 'Harbour Bridge Climb', 'Auckland', 'Adventure climb over Auckland Harbour Bridge.', '2024-01-15 14:00:00', '2024-01-15 16:00:00', -36.8018, 174.7799),
(@j1, @user1, 'Waiheke Island Ferry', 'Auckland', 'Ferry trip to beautiful Waiheke Island for wine tasting.', '2024-01-16 09:00:00', '2024-01-16 17:00:00', -36.8020, 175.0917),
(@j1, @user1, 'Mission Bay Beach Walk', 'Auckland', 'Relaxing beach walk along Mission Bay waterfront.', '2024-01-16 18:00:00', '2024-01-16 19:30:00', -36.8558, 174.8276),

-- Journey 2 events (Rotorua)
(@j2, @user1, 'Te Puia Geothermal Park', 'Rotorua', 'Exploring geysers and traditional Māori village.', '2024-03-20 11:00:00', '2024-03-20 14:00:00', -38.1562, 176.2649),
(@j2, @user1, 'Wai-O-Tapu Thermal Wonderland', 'Rotorua', 'Witnessing colorful hot springs and mud pools.', '2024-03-20 15:30:00', '2024-03-20 17:30:00', -38.2675, 176.3666),
(@j2, @user1, 'Traditional Hangi Feast', 'Rotorua', 'Enjoying authentic Māori earth-cooked meal and cultural show.', '2024-03-20 19:00:00', '2024-03-20 22:00:00', -38.1368, 176.2497),
(@j2, @user1, 'Redwood Forest Walk', 'Rotorua', 'Peaceful walk through magnificent redwood forest trails.', '2024-03-21 09:00:00', '2024-03-21 11:00:00', -38.1581, 176.2907),

-- Journey 3 events (Coromandel)
(@j3, @user1, 'Cathedral Cove Hike', 'Coromandel', 'Hiking to the famous Cathedral Cove beach formation.', '2024-04-10 09:00:00', '2024-04-10 12:00:00', -36.8288, 175.7784),
(@j3, @user1, 'Hot Water Beach', 'Coromandel', 'Digging hot pools in the sand at unique Hot Water Beach.', '2024-04-10 14:00:00', '2024-04-10 16:00:00', -36.8739, 175.7997),
(@j3, @user1, 'Driving Creek Railway', 'Coromandel', 'Scenic narrow-gauge railway journey through native forest.', '2024-04-11 10:00:00', '2024-04-11 12:30:00', -36.7654, 175.4950),

-- Journey 4 events (Christchurch - Location Expert Test)
(@j4_christchurch, @user1, 'Christchurch Botanic Gardens', 'Christchurch', 'Exploring diverse plant collections in the beautiful botanic gardens.', '2024-05-01 10:00:00', '2024-05-01 12:00:00', -43.5309, 172.6236),
(@j4_christchurch, @user1, 'Canterbury Museum Visit', 'Christchurch', 'Discovering Canterbury history and cultural artifacts.', '2024-05-01 14:00:00', '2024-05-01 16:00:00', -43.5308, 172.6260),
(@j4_christchurch, @user1, 'Punting on Avon River', 'Christchurch', 'Relaxing punt ride through the heart of Christchurch.', '2024-05-02 09:00:00', '2024-05-02 10:30:00', -43.5316, 172.6398),
(@j4_christchurch, @user1, 'Christchurch Cathedral Tour', 'Christchurch', 'Visiting the iconic earthquake-damaged cathedral area.', '2024-05-02 11:00:00', '2024-05-02 12:30:00', -43.5321, 172.6362),
(@j4_christchurch, @user1, 'Quake City Exhibition', 'Christchurch', 'Learning about earthquake experiences and city rebuilding.', '2024-05-02 14:00:00', '2024-05-02 16:00:00', -43.5320, 172.6360),
(@j4_christchurch, @user1, 'Hagley Park Stroll', 'Christchurch', 'Peaceful walk through Christchurch largest urban park.', '2024-05-03 09:00:00', '2024-05-03 11:00:00', -43.5261, 172.6201),
(@j4_christchurch, @user1, 'Christchurch Tram Tour', 'Christchurch', 'Historic tram tour around the central city attractions.', '2024-05-03 14:00:00', '2024-05-03 16:00:00', -43.5320, 172.6360),
(@j4_christchurch, @user1, 'Arts Centre Exploration', 'Christchurch', 'Exploring galleries and studios in the historic Arts Centre.', '2024-05-04 10:00:00', '2024-05-04 12:00:00', -43.5282, 172.6334),
(@j4_christchurch, @user1, 'Re:START Mall Shopping', 'Christchurch', 'Shopping at the unique shipping container mall.', '2024-05-04 14:00:00', '2024-05-04 16:00:00', -43.5307, 172.6379),

-- Journey 5 events (Wellington)
(@j4, @user2, 'Te Papa Museum', 'Wellington', 'Exploring New Zealand national museum and cultural treasures.', '2024-02-01 11:00:00', '2024-02-01 15:00:00', -41.2905, 174.7821),
(@j4, @user2, 'Cable Car to Botanic Garden', 'Wellington', 'Historic cable car ride to Wellington Botanic Garden.', '2024-02-01 16:00:00', '2024-02-01 18:00:00', -41.2784, 174.7683),
(@j4, @user2, 'Cuba Street Food Tour', 'Wellington', 'Sampling diverse culinary offerings along vibrant Cuba Street.', '2024-02-01 19:00:00', '2024-02-01 21:00:00', -41.2924, 174.7787),
(@j4, @user2, 'Mount Victoria Lookout', 'Wellington', 'Panoramic city views from Mount Victoria summit.', '2024-02-02 08:30:00', '2024-02-02 10:00:00', -41.2924, 174.7945),

-- Continue with more events for other journeys...
(@j5, @user2, 'Shotover Jet Ride', 'Queenstown', 'High-speed jet boat ride through Shotover River canyons.', '2024-03-15 10:00:00', '2024-03-15 11:00:00', -45.0267, 168.6616),
(@j5, @user2, 'Skyline Gondola', 'Queenstown', 'Scenic gondola ride with spectacular lake and mountain views.', '2024-03-15 14:00:00', '2024-03-15 16:00:00', -45.0312, 168.6594),
(@j5, @user2, 'Bungee Jump at Kawarau', 'Queenstown', 'Original bungee jump experience at historic Kawarau Bridge.', '2024-03-16 11:00:00', '2024-03-16 12:00:00', -45.0320, 168.7188),

(@j9, @user4, 'AJ Hackett Ledge Swing', 'Queenstown', 'Ultimate adrenaline rush with 400m cliff swing.', '2024-02-10 09:00:00', '2024-02-10 10:00:00', -45.0320, 168.6600),
(@j9, @user4, 'Skydive Over Queenstown', 'Queenstown', 'Tandem skydive with incredible alpine scenery.', '2024-02-10 14:00:00', '2024-02-10 15:30:00', -45.0312, 168.6626),
(@j9, @user4, 'White Water Rafting', 'Queenstown', 'Grade 5 rapids adventure on Shotover River.', '2024-02-11 10:00:00', '2024-02-11 13:00:00', -45.0267, 168.6616);

-- Insert event images (each image used only once)
INSERT INTO event_images (event_id, journey_id, img_path, is_cover) VALUES
-- Premium users get multiple images per event
((SELECT event_id FROM events WHERE title = 'Sky Tower Visit'), @j1, 'images/events/preset/event1.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Sky Tower Visit'), @j1, 'images/events/preset/event2.jpg', FALSE),
((SELECT event_id FROM events WHERE title = 'Sky Tower Visit'), @j1, 'images/events/preset/event3.jpg', FALSE),

((SELECT event_id FROM events WHERE title = 'Harbour Bridge Climb'), @j1, 'images/events/preset/event4.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Harbour Bridge Climb'), @j1, 'images/events/preset/event5.jpg', FALSE),

((SELECT event_id FROM events WHERE title = 'Waiheke Island Ferry'), @j1, 'images/events/preset/event6.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Waiheke Island Ferry'), @j1, 'images/events/preset/event7.jpg', FALSE),
((SELECT event_id FROM events WHERE title = 'Waiheke Island Ferry'), @j1, 'images/events/preset/event8.jpg', FALSE),

((SELECT event_id FROM events WHERE title = 'Mission Bay Beach Walk'), @j1, 'images/events/preset/event9.jpg', TRUE),

-- More events with single images for other users
((SELECT event_id FROM events WHERE title = 'Te Puia Geothermal Park'), @j2, 'images/events/preset/event10.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Wai-O-Tapu Thermal Wonderland'), @j2, 'images/events/preset/event11.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Traditional Hangi Feast'), @j2, 'images/events/preset/event12.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Redwood Forest Walk'), @j2, 'images/events/preset/event13.jpg', TRUE),

-- Christchurch events images for Location Expert test
((SELECT event_id FROM events WHERE title = 'Christchurch Botanic Gardens'), @j4_christchurch, 'images/events/preset/event26.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Canterbury Museum Visit'), @j4_christchurch, 'images/events/preset/event27.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Punting on Avon River'), @j4_christchurch, 'images/events/preset/event28.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Christchurch Cathedral Tour'), @j4_christchurch, 'images/events/preset/event29.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Quake City Exhibition'), @j4_christchurch, 'images/events/preset/event30.jpg', TRUE),

((SELECT event_id FROM events WHERE title = 'Te Papa Museum'), @j4, 'images/events/preset/event14.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Te Papa Museum'), @j4, 'images/events/preset/event15.jpg', FALSE),
((SELECT event_id FROM events WHERE title = 'Te Papa Museum'), @j4, 'images/events/preset/event16.jpg', FALSE),

((SELECT event_id FROM events WHERE title = 'Cable Car to Botanic Garden'), @j4, 'images/events/preset/event17.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Cuba Street Food Tour'), @j4, 'images/events/preset/event18.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Mount Victoria Lookout'), @j4, 'images/events/preset/event19.jpg', TRUE),

((SELECT event_id FROM events WHERE title = 'Shotover Jet Ride'), @j5, 'images/events/preset/event20.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Skyline Gondola'), @j5, 'images/events/preset/event21.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Bungee Jump at Kawarau'), @j5, 'images/events/preset/event22.jpg', TRUE),

((SELECT event_id FROM events WHERE title = 'AJ Hackett Ledge Swing'), @j9, 'images/events/preset/event23.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'Skydive Over Queenstown'), @j9, 'images/events/preset/event24.jpg', TRUE),
((SELECT event_id FROM events WHERE title = 'White Water Rafting'), @j9, 'images/events/preset/event25.jpg', TRUE);

-- Insert subscription plans
INSERT INTO subscription_plans (type, duration_months, price_ex_gst, price_inc_gst, discount_percent)
VALUES
('1 month trial', 1, NULL, NULL, NULL),
('1 month free', 1, NULL, NULL, NULL),
('3 months free', 3, NULL, NULL, NULL),
('12 months free', 12, NULL, NULL, NULL),
('1 month', 1, 5.22, 6.00, NULL),
('3 months', 3, 14.09, 16.20, 10.00),
('12 months', 12, 46.96, 54.00, 25.00);

-- Insert card details for premium users
INSERT INTO card_details (user_id, card_no, card_name, expiration_date)
VALUES
(@user1, 1234567890123456, 'John Smith', '05/27'),
(@user2, 1234567890123457, 'Jane Johnson', '06/27'),
(@user3, 1234567890123458, 'Mike Williams', '07/27');

-- Insert billing addresses
INSERT INTO billing_address (user_id, street, zip, country)
VALUES
(@user1, '123 Queen St, Auckland', '1010', 'New Zealand'),
(@user2, '456 Lambton Quay, Wellington', '6011', 'New Zealand'),
(@user3, '789 Cashel St, Christchurch', '8011', 'New Zealand');

-- Insert subscription records
INSERT INTO subscription_record (user_id, plan_id, billing_id, card_id, start_date, end_date, status)
VALUES
(@user1, 7, 1, 1, '2024-01-01', '2025-12-31', 'Active'),
(@user2, 6, 2, 2, '2024-02-01', '2025-02-01', 'Active'),
(@user3, 5, 3, 3, '2024-03-01', '2025-03-01', 'Active');

-- Insert announcements
INSERT INTO announcements (title, content, priority, author_id, author_name, start_at, expire_at) VALUES
('Welcome to Wanderlog!', 'Start your journey with us and explore amazing destinations around New Zealand.', 4, 27, 'admin01', '2024-01-01 00:00:00', '2025-12-31 23:59:59'),
('System Maintenance Notice', 'Scheduled maintenance will occur on 2024-05-15 from 22:00 to 23:59. Please save your work.', 3, 27, 'admin01', '2024-05-01 00:00:00', '2024-05-15 23:59:59'),
('New Premium Features Available', 'Check out our latest premium features including multi-photo uploads and journey publishing!', 2, 27, 'admin01', '2024-03-01 00:00:00', '2024-06-30 23:59:59'),
('Community Guidelines Update', 'We have updated our community guidelines. Please review the changes to ensure a positive experience for all users.', 1, 27, 'admin01', '2024-02-01 00:00:00', '2024-08-31 23:59:59'),
('Holiday Special Offer', 'Enjoy 25% off all premium subscriptions during our holiday special. Limited time offer!', 4, 27, 'admin01', '2024-04-01 00:00:00', '2024-04-30 23:59:59');

-- Insert achievement categories
INSERT INTO achievement_categories (name, description, icon_path) VALUES
('content', 'Content Creation Achievements', 'static/images/achievements/first_journey.png'),
('community', 'Community Engagement', 'static/images/achievements/community_member.png'),
('exploration', 'Platform Exploration', 'static/images/achievements/storyteller.png'),
('activity', 'User Activity & Loyalty', 'static/images/achievements/active_user.png'),
('premium', 'Premium User Features', 'static/images/achievements/premium_member.png'),
('milestones', 'Major Milestones', 'static/images/achievements/journey_enthusiast.png'),
('special', 'Special Recognition', 'static/images/achievements/detail_recorder.png');

-- Get category IDs
SET @content_cat = (SELECT category_id FROM achievement_categories WHERE name = 'content');
SET @community_cat = (SELECT category_id FROM achievement_categories WHERE name = 'community');
SET @exploration_cat = (SELECT category_id FROM achievement_categories WHERE name = 'exploration');
SET @activity_cat = (SELECT category_id FROM achievement_categories WHERE name = 'activity');
SET @premium_cat = (SELECT category_id FROM achievement_categories WHERE name = 'premium');
SET @milestones_cat = (SELECT category_id FROM achievement_categories WHERE name = 'milestones');
SET @special_cat = (SELECT category_id FROM achievement_categories WHERE name = 'special');

-- Insert achievements
INSERT INTO achievements (name, description, unlock_condition, icon_path, category_id, is_hidden, is_premium, reward_type, reward_data) VALUES
-- Content Creation Achievements (5)
('First Journey', 'Create your first journey', 'create_journey_1', 'static/images/achievements/first_journey.png', @content_cat, FALSE, FALSE, 'badge', NULL),
('Event Creator', 'Add your first event', 'create_event_1', 'static/images/achievements/detail_recorder.png', @content_cat, FALSE, FALSE, 'badge', NULL),
('Photo Enthusiast', 'Upload your first photo', 'upload_photo_1', 'static/images/achievements/first_photographer.png', @content_cat, FALSE, FALSE, 'badge', NULL),
('Profile Complete', 'Set your profile picture and complete your profile', 'set_profile_picture', 'static/images/achievements/profile_completer.png', @content_cat, FALSE, FALSE, 'badge', NULL),
('Journey Explorer', 'Create 3 journeys', 'create_journey_3', 'static/images/achievements/journey_beginner.png', @content_cat, FALSE, FALSE, 'badge', NULL),

-- Community Engagement Achievements (4)
('Community Explorer', 'View 5 public journeys', 'view_journeys_5', 'static/images/achievements/journey_enthusiast.png', @community_cat, FALSE, FALSE, 'badge', NULL),
('Social Beginner', 'Give your first like', 'give_like_1', 'static/images/achievements/first_like.png', @community_cat, FALSE, FALSE, 'badge', NULL),
('Public Sharer', 'Make your first journey public', 'make_public_1', 'static/images/achievements/popular_newcomer.png', @community_cat, FALSE, FALSE, 'badge', NULL),
('Active Participant', 'Give likes to 5 different events', 'give_like_5', 'static/images/achievements/active_commenter.png', @community_cat, FALSE, FALSE, 'badge', NULL),

-- Platform Exploration Achievements (3)
('Search Master', 'Use the search function to find journeys', 'use_search_1', 'static/images/achievements/storyteller.png', @exploration_cat, FALSE, FALSE, 'badge', NULL),
('Location Explorer', 'Visit 3 different locations', 'location_diversity_3', 'static/images/achievements/time_manager.png', @exploration_cat, FALSE, FALSE, 'badge', NULL),
('Profile Perfectionist', 'Complete your profile with all details', 'complete_profile', 'static/images/achievements/premium_member.png', @exploration_cat, FALSE, FALSE, 'badge', NULL),

-- User Activity & Loyalty Achievements (3)
('New User', 'Login for 3 consecutive days', 'login_streak_3', 'static/images/achievements/new_user.png', @activity_cat, FALSE, FALSE, 'badge', NULL),
('Loyal User', 'Login for 7 consecutive days', 'login_streak_7', 'static/images/achievements/active_user.png', @activity_cat, FALSE, FALSE, 'badge', NULL),
('Regular Visitor', 'Login for a total of 15 days', 'login_total_15', 'static/images/achievements/community_member.png', @activity_cat, FALSE, FALSE, 'badge', NULL),

-- Premium User Features Achievements (3)
('Publisher', 'Publish your first journey to homepage', 'publish_journey_1', 'static/images/achievements/first_journey.png', @premium_cat, FALSE, TRUE, 'badge', NULL),
('Cover Designer', 'Add cover images to 3 journeys', 'cover_image_3', 'static/images/achievements/photography_enthusiast.png', @premium_cat, FALSE, TRUE, 'badge', NULL),
('Multi-Photo Master', 'Add multiple photos to 3 events', 'multi_photo_3', 'static/images/achievements/first_photographer.png', @premium_cat, FALSE, TRUE, 'badge', NULL),

-- Major Milestones Achievements (2)
('Active Traveler', 'Create 5 journeys', 'create_journey_5', 'static/images/achievements/journey_enthusiast.png', @milestones_cat, FALSE, FALSE, 'title', '{"title": "Travel Master", "color": "#FFD700"}'),
('Photographer', 'Upload 15 photos', 'upload_photo_15', 'static/images/achievements/photography_enthusiast.png', @milestones_cat, FALSE, FALSE, 'title', '{"title": "Photo Master", "color": "#FF6B6B"}'),

-- Special Recognition Achievements (1)
('Location Expert', 'Publish 10 events in the same location', 'location_expert_10', 'static/images/achievements/detail_recorder.png', @special_cat, FALSE, FALSE, 'title', '{"title": "Location Expert", "dynamic": true}');

-- Award achievements to users based on their activities
INSERT INTO user_achievements (user_id, achievement_id, unlocked_at, is_displayed) VALUES
-- Content Creation Achievements
-- First Journey achievement for users with journeys
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_1'), '2024-01-15 09:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_1'), '2024-02-01 10:30:00', TRUE),
(@user3, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_1'), '2024-01-25 11:00:00', TRUE),
(@user4, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_1'), '2024-02-10 08:00:00', TRUE),
(@user5, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_1'), '2024-03-01 10:00:00', TRUE),
(@user6, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_1'), '2024-01-30 12:00:00', TRUE),
(@user7, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_1'), '2024-02-20 11:30:00', TRUE),
(@user8, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_1'), '2024-03-10 07:30:00', TRUE),
(@user9, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_1'), '2024-02-25 09:00:00', TRUE),
(@user10, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_1'), '2024-04-20 10:30:00', TRUE),

-- Journey Explorer for users with 3+ journeys
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_3'), '2024-04-10 08:30:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_3'), '2024-04-25 07:00:00', TRUE),

-- Active Traveler for user1 (has 4 journeys, milestone achievement)
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_journey_5'), '2024-04-10 08:30:00', TRUE),

-- Event Creator for users with events
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_event_1'), '2024-01-15 10:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_event_1'), '2024-02-01 11:00:00', TRUE),
(@user3, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_event_1'), '2024-01-25 11:00:00', TRUE),
(@user4, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_event_1'), '2024-02-10 09:00:00', TRUE),
(@user5, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_event_1'), '2024-03-01 10:00:00', TRUE),
(@user6, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_event_1'), '2024-01-30 12:00:00', TRUE),
(@user7, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_event_1'), '2024-02-20 11:30:00', TRUE),
(@user8, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_event_1'), '2024-03-10 07:30:00', TRUE),
(@user9, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_event_1'), '2024-02-25 09:00:00', TRUE),
(@user10, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'create_event_1'), '2024-04-20 10:30:00', TRUE),

-- Photo Enthusiast for users with photos
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_1'), '2024-01-15 10:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_1'), '2024-02-01 11:00:00', TRUE),
(@user3, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_1'), '2024-01-25 11:00:00', TRUE),
(@user4, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_1'), '2024-02-10 09:00:00', TRUE),
(@user5, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_1'), '2024-03-01 10:00:00', TRUE),
(@user6, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_1'), '2024-01-30 12:00:00', TRUE),
(@user7, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_1'), '2024-02-20 11:30:00', TRUE),
(@user8, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_1'), '2024-03-10 07:30:00', TRUE),
(@user9, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_1'), '2024-02-25 09:00:00', TRUE),
(@user10, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_1'), '2024-04-20 10:30:00', TRUE),

-- Profile Complete achievement for many users
((SELECT user_id FROM users WHERE username = 'traveller11'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'set_profile_picture'), '2024-03-05 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller12'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'set_profile_picture'), '2024-03-06 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller13'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'set_profile_picture'), '2024-03-07 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller14'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'set_profile_picture'), '2024-03-08 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller15'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'set_profile_picture'), '2024-03-09 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller16'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'set_profile_picture'), '2024-03-10 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller17'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'set_profile_picture'), '2024-03-11 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller18'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'set_profile_picture'), '2024-03-12 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller19'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'set_profile_picture'), '2024-03-13 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller20'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'set_profile_picture'), '2024-03-14 09:00:00', TRUE),

-- Community Achievements
-- Social Beginner for users who gave likes
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-02-02 15:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-01-16 10:00:00', TRUE),
(@user3, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-01-17 11:00:00', TRUE),
(@user4, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-02-11 14:00:00', TRUE),
(@user5, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-02 15:00:00', TRUE),
(@user6, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-01-31 10:00:00', TRUE),
(@user7, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-02-21 11:30:00', TRUE),
(@user8, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-11 07:30:00', TRUE),
(@user9, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-02-26 09:00:00', TRUE),
(@user10, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-04-21 10:30:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller11'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-15 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller12'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-16 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller13'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-17 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller14'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-18 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller15'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-19 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller16'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-20 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller17'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-21 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller18'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-22 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller19'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-23 09:00:00', TRUE),
((SELECT user_id FROM users WHERE username = 'traveller20'), (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_1'), '2024-03-24 09:00:00', TRUE),

-- Public Sharer for users with public journeys
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'make_public_1'), '2024-01-15 09:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'make_public_1'), '2024-02-01 10:30:00', TRUE),
(@user3, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'make_public_1'), '2024-01-25 11:00:00', TRUE),
(@user4, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'make_public_1'), '2024-02-10 08:00:00', TRUE),
(@user5, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'make_public_1'), '2024-03-01 10:00:00', TRUE),
(@user6, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'make_public_1'), '2024-01-30 12:00:00', TRUE),
(@user7, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'make_public_1'), '2024-02-20 11:30:00', TRUE),
(@user8, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'make_public_1'), '2024-03-10 07:30:00', TRUE),
(@user9, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'make_public_1'), '2024-02-25 09:00:00', TRUE),
(@user10, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'make_public_1'), '2024-04-20 10:30:00', TRUE),

-- Community Explorer for viewing other journeys
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'view_journeys_5'), '2024-02-05 09:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'view_journeys_5'), '2024-03-20 12:00:00', TRUE),
(@user3, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'view_journeys_5'), '2024-03-21 13:00:00', TRUE),
(@user4, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'view_journeys_5'), '2024-02-15 14:00:00', TRUE),
(@user5, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'view_journeys_5'), '2024-03-05 15:00:00', TRUE),
(@user6, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'view_journeys_5'), '2024-02-05 10:00:00', TRUE),
(@user7, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'view_journeys_5'), '2024-02-25 11:30:00', TRUE),

-- Exploration Achievements
-- Location Explorer for users who visited multiple locations
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'location_diversity_3'), '2024-04-10 08:30:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'location_diversity_3'), '2024-04-25 07:00:00', TRUE),

-- Activity Achievements
-- New User (3-day login streak)
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'login_streak_3'), '2024-01-17 09:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'login_streak_3'), '2024-02-03 08:45:00', TRUE),
(@user3, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'login_streak_3'), '2024-01-27 09:45:00', TRUE),
(@user4, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'login_streak_3'), '2024-02-13 09:45:00', TRUE),
(@user5, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'login_streak_3'), '2024-03-04 09:45:00', TRUE),

-- Loyal User (7-day login streak) - for more users
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'login_streak_7'), '2024-01-21 09:15:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'login_streak_7'), '2024-02-07 09:15:00', TRUE),

-- Premium Achievements (for premium users only)
-- Publisher for users who published journeys
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'publish_journey_1'), '2024-04-10 08:30:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'publish_journey_1'), '2024-03-15 09:00:00', TRUE),
(@user4, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'publish_journey_1'), '2024-04-15 10:00:00', TRUE),

-- Multi-Photo Master for premium users with multiple photos per event
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'multi_photo_3'), '2024-01-16 09:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'multi_photo_3'), '2024-02-01 11:00:00', TRUE),

-- Active Participant for users who gave multiple likes
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_5'), '2024-02-10 15:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_5'), '2024-01-20 10:00:00', TRUE),
(@user3, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'give_like_5'), '2024-01-25 11:00:00', TRUE),

-- Profile Perfectionist achievement
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'complete_profile'), '2024-01-15 09:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'complete_profile'), '2024-02-01 10:30:00', TRUE),
(@user3, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'complete_profile'), '2024-01-25 11:00:00', TRUE),

-- Photographer milestone for users with many photos
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_15'), '2024-03-01 10:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'upload_photo_15'), '2024-03-15 11:00:00', TRUE),

-- Regular Visitor achievement
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'login_total_15'), '2024-02-15 09:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'login_total_15'), '2024-03-01 09:00:00', TRUE),
(@user3, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'login_total_15'), '2024-02-20 09:00:00', TRUE),

-- Cover Designer for premium users
(@user1, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'cover_image_3'), '2024-02-01 10:00:00', TRUE),
(@user2, (SELECT achievement_id FROM achievements WHERE unlock_condition = 'cover_image_3'), '2024-02-15 11:00:00', TRUE);

-- Insert a new journey for traveller01
INSERT INTO journeys (user_id, title, location, description, start_date, status) VALUES
(@user1, 'New Zealand to USA Adventure', 'Queenstown', 'An exciting journey starting in New Zealand and exploring cities in the USA.', '2024-11-01 09:00:00', 'public');
-- Get the journey_id for the new journey
SET @new_journey_id = (SELECT journey_id FROM journeys WHERE user_id=@user1 AND title='New Zealand to USA Adventure');

-- Insert events for the journey
INSERT INTO events (journey_id, user_id, title, location, description, start_date, end_date, latitude, longitude) VALUES
-- Event 1: Queenstown
(@new_journey_id, @user1, 'Queenstown Adventure Start', 'Queenstown', 'Begin the journey with thrilling activities in Queenstown.', '2024-11-01 10:00:00', '2024-11-01 12:00:00', -45.0312, 168.6626),
-- Event 2: Christchurch
(@new_journey_id, @user1, 'Christchurch Exploration', 'Christchurch', 'Explore the beautiful gardens and heritage of Christchurch.', '2024-11-02 09:00:00', '2024-11-02 11:00:00', -43.5321, 172.6362),
-- Event 3: Auckland
(@new_journey_id, @user1, 'Auckland City Tour', 'Auckland', 'Discover the urban and coastal beauty of Auckland.', '2024-11-03 10:00:00', '2024-11-03 12:00:00', -36.8485, 174.7633),
-- Event 4: Los Angeles
(@new_journey_id, @user1, 'Hollywood Walk of Fame', 'Los Angeles', 'Visit the iconic Hollywood Walk of Fame.', '2024-11-05 14:00:00', '2024-11-05 16:00:00', 34.0522, -118.2437),
-- Event 5: New York City
(@new_journey_id, @user1, 'Times Square Visit', 'New York City', 'Experience the vibrant energy of Times Square.', '2024-11-08 10:00:00', '2024-11-08 12:00:00', 40.7128, -74.0060),
-- Event 6: Chicago
(@new_journey_id, @user1, 'Millennium Park Tour', 'Chicago', 'Explore the famous Millennium Park in Chicago.', '2024-11-07 11:00:00', '2024-11-09 13:00:00', 41.8781, -87.6298),
-- Event 7: San Francisco
(@new_journey_id, @user1, 'Golden Gate Bridge Walk', 'San Francisco', 'Walk across the iconic Golden Gate Bridge.', '2024-11-06 09:00:00', '2024-11-06 11:00:00', 37.7749, -122.4194),
-- Event 8: Return to Auckland
(@new_journey_id, @user1, 'Auckland Return', 'Auckland', 'Conclude the journey back in Auckland.', '2024-11-13 10:00:00', '2024-11-13 12:00:00', -36.8485, 174.7633);

-- Assign images to the events
INSERT INTO event_images (event_id, journey_id, img_path, is_cover) VALUES
((SELECT event_id FROM events WHERE journey_id=@new_journey_id AND title='Queenstown Adventure Start'), @new_journey_id, 'images/events/preset/event1.jpg', TRUE),
((SELECT event_id FROM events WHERE journey_id=@new_journey_id AND title='Christchurch Exploration'), @new_journey_id, 'images/events/preset/event3.jpg', TRUE),
((SELECT event_id FROM events WHERE journey_id=@new_journey_id AND title='Auckland City Tour'), @new_journey_id, 'images/events/preset/event5.jpg', TRUE),
((SELECT event_id FROM events WHERE journey_id=@new_journey_id AND title='Hollywood Walk of Fame'), @new_journey_id, 'images/events/preset/event7.jpg', TRUE),
((SELECT event_id FROM events WHERE journey_id=@new_journey_id AND title='Times Square Visit'), @new_journey_id, 'images/events/preset/event9.jpg', TRUE),
((SELECT event_id FROM events WHERE journey_id=@new_journey_id AND title='Millennium Park Tour'), @new_journey_id, 'images/events/preset/event11.jpg', TRUE),
((SELECT event_id FROM events WHERE journey_id=@new_journey_id AND title='Golden Gate Bridge Walk'), @new_journey_id, 'images/events/preset/event13.jpg', TRUE),
((SELECT event_id FROM events WHERE journey_id=@new_journey_id AND title='Auckland Return'), @new_journey_id, 'images/events/preset/event15.jpg', TRUE);
-- Insert sample comments
INSERT INTO comments (event_id, user_id, content) VALUES
(1, @user2, 'Amazing view from the Sky Tower! Thanks for sharing this journey.'),
(1, @user3, 'I visited here last month too, absolutely incredible experience.'),
(5, @user1, 'Te Papa is such a fantastic museum, spent the whole day there!'),
(8, @user4, 'The bungee jump looks terrifying but so exciting!');

-- Insert comment reactions
INSERT INTO comment_reactions (comment_id, user_id, reaction_type) VALUES
(1, @user1, 'like'),
(1, @user4, 'like'),
(2, @user2, 'like'),
(3, @user3, 'like');

-- Insert event likes for social features
INSERT INTO event_likes (event_id, user_id, created_at) VALUES
(1, @user2, '2024-01-16 10:00:00'),
(1, @user3, '2024-01-17 11:00:00'),
(5, @user1, '2024-02-02 15:00:00'),
(5, @user4, '2024-02-03 09:00:00'),
(8, @user2, '2024-02-11 14:00:00');

-- Insert journey views for analytics
INSERT INTO journey_views (viewer_id, journey_id, viewed_at) VALUES
(@user2, @j1, '2024-01-20 10:00:00'),
(@user3, @j1, '2024-01-21 11:00:00'),
(@user4, @j1, '2024-01-22 14:00:00'),
(@user1, @j4, '2024-02-05 09:00:00'),
(@user3, @j4, '2024-02-06 16:00:00'),
(@user1, @j5, '2024-03-20 12:00:00'),
(@user3, @j5, '2024-03-21 13:00:00');

-- Insert user search history
INSERT INTO user_search_history (user_id, search_term, search_type, searched_at) VALUES
(@user1, 'Auckland', 'journey', '2024-01-10 09:00:00'),
(@user2, 'Wellington', 'journey', '2024-01-25 10:00:00'),
(@user3, 'Queenstown', 'journey', '2024-02-15 11:00:00'),
(@user4, 'adventure', 'journey', '2024-02-05 14:00:00');

-- Insert user login history for achievement tracking
INSERT INTO user_logins (user_id, login_date, ip_address) VALUES
-- User 1 - consistent login pattern
(@user1, '2024-01-15 08:00:00', '192.168.1.100'),
(@user1, '2024-01-16 08:30:00', '192.168.1.100'),
(@user1, '2024-01-17 09:00:00', '192.168.1.100'),
(@user1, '2024-01-18 08:15:00', '192.168.1.100'),
(@user1, '2024-01-19 09:30:00', '192.168.1.100'),
(@user1, '2024-01-20 08:45:00', '192.168.1.100'),
(@user1, '2024-01-21 09:15:00', '192.168.1.100'),

-- User 2 - regular login pattern
(@user2, '2024-02-01 09:00:00', '192.168.1.101'),
(@user2, '2024-02-02 09:15:00', '192.168.1.101'),
(@user2, '2024-02-03 08:45:00', '192.168.1.101'),
(@user2, '2024-02-04 09:30:00', '192.168.1.101'),

-- User 3 - shorter login streak
(@user3, '2024-01-25 10:00:00', '192.168.1.102'),
(@user3, '2024-01-26 10:15:00', '192.168.1.102'),
(@user3, '2024-01-27 09:45:00', '192.168.1.102');
-- Insert sample admin notifications
INSERT INTO admin_notifications (type, content, related_comment_id) VALUES
('comment_report', 'New comment report: User user2 reported comment #3', 3),
('comment_report', 'New comment report: User user2 reported comment #4', 4);

-- Insert sample journey edit logs
INSERT INTO journey_edit_logs (journey_id, editor_id, change_type, change_description, reason, old_value, new_value) VALUES
(@j1, 22, 'text', 'Updated journey title', 'Corrected spelling error', 'Exploring Auckland City', 'Exploring Auckland City - Fixed Spelling'),
(@j1, 22, 'text', 'Updated journey description', 'Added more details about attractions', 'A comprehensive exploration of Auckland urban life and coastal beauty.', 'A comprehensive exploration of Auckland urban life and coastal beauty, including Sky Tower, harbour bridge, and Waiheke Island.'),
(@j4, 23, 'status', 'Changed journey status', 'Journey content needs review', 'public', 'hidden'),
(@j5, 24, 'text', 'Updated journey location', 'Location was incorrectly specified', 'Queenstown', 'Queenstown Central'),
(@j2, 25, 'image', 'Updated cover image', 'Better quality image available', 'images/events/preset/event10.jpg', 'images/events/preset/event15.jpg'),
-- Event edit logs
(@j1, 22, 'events', 'Updated event title', 'Event title contained inappropriate language', 'Sky Tower Adventure - Check this out!', 'Sky Tower Adventure'),
(@j1, 22, 'events', 'Updated event description', 'Added safety information for visitors', 'Amazing view from the top!', 'Amazing view from the top! Please note: Safety equipment required for Sky Jump activities.'),
(@j2, 23, 'events', 'Updated event location', 'Location coordinates were incorrect', 'Rotorua City Center', 'Te Puia Geothermal Park'),
(@j4, 24, 'events', 'Updated event start date/time', 'Event timing conflicted with venue availability', '2024-01-15 09:00:00', '2024-01-15 14:00:00'),
(@j5, 25, 'events', 'Updated event description', 'Removed outdated pricing information', 'Bungee jumping costs $200 per person', 'Bungee jumping available (check current pricing on-site)');

-- Insert sample user notifications
INSERT INTO user_notifications (user_id, notification_type, title, message, related_journey_id, related_editor_id) VALUES
(@user1, 'journey_edited', 'Your journey was edited', 'Admin has updated your journey "Exploring Auckland City" to correct spelling errors.', @j1, 22),
(@user1, 'journey_edited', 'Your journey was edited', 'Admin has updated your journey description to provide more detailed information.', @j1, 22),
(@user2, 'journey_hidden', 'Journey Hidden', 'Your journey "Wellington Capital Experience" has been hidden by a moderator pending content review.', @j4, 23),
(@user2, 'journey_edited', 'Your journey was edited', 'Editor has updated your journey location for better accuracy.', @j5, 24),
(@user1, 'journey_edited', 'Your journey was edited', 'Editor has updated the cover image of your journey "Rotorua Thermal Adventure".', @j2, 25),
-- Event edit notifications
(@user1, 'journey_edited', 'Event in your journey was edited', 'Staff member admin_user has edited an event in your journey "Exploring Auckland City". Reason: Event title contained inappropriate language', @j1, 22),
(@user1, 'journey_edited', 'Event in your journey was edited', 'Staff member admin_user has edited an event in your journey "Exploring Auckland City". Reason: Added safety information for visitors', @j1, 22),
(@user1, 'journey_edited', 'Event in your journey was edited', 'Staff member editor_user has edited an event in your journey "Rotorua Thermal Adventure". Reason: Location coordinates were incorrect', @j2, 23),
(@user2, 'journey_edited', 'Event in your journey was edited', 'Staff member editor2_user has edited an event in your journey "Wellington Capital Experience". Reason: Event timing conflicted with venue availability', @j4, 24),
(@user2, 'journey_edited', 'Event in your journey was edited', 'Staff member support_admin has edited an event in your journey "Queenstown Adventure". Reason: Removed outdated pricing information', @j5, 25);

-- Insert sample appeals through the issues table (integrated with support system)
INSERT INTO issues (user_id, issue_type, appeal_type, related_journey_id, summary, description, status) VALUES
(
    @user2, 
    'appeal', 
    'hidden_journey', 
    @j4, 
    'Appeal: Hidden Journey - Budget Travel Guide',
    'I believe my journey was hidden incorrectly. The content follows all community guidelines and provides valuable travel information for other users. This journey contains legitimate budget travel tips that could help the community save money while traveling.',
    'new'
),
(
    @user7, 
    'appeal', 
    'sharing_blocked', 
    NULL, 
    'Appeal: Public Sharing Disabled',
    'My public sharing was disabled, but I have not violated any terms of service. I only share appropriate travel content that complies with community guidelines. I believe this restriction was applied in error.',
    'new'
),
(
    @user6, 
    'appeal', 
    'hidden_journey', 
    @j6, 
    'Appeal: Hidden Journey - Student Travel Tips',
    'My budget travel journey was hidden, but it contains legitimate money-saving tips for students that could help the community. The content is educational and follows all platform guidelines.',
    'new'
);


-- Update some journeys to have no_edits flag for testing
UPDATE journeys SET no_edits = TRUE WHERE journey_id IN (@j1, @j3) AND user_id = @user1;

-- Assign cover images for the 5 new journeys
-- INSERT INTO event_images (event_id, journey_id, img_path, is_cover) VALUES
-- (19, (SELECT journey_id FROM journeys WHERE title = 'Christchurch Airport Exploration'), 'images/events/preset/event1.jpg', TRUE),
-- (25, (SELECT journey_id FROM journeys WHERE title = 'Hagley Park Walk'), 'images/events/preset/event2.jpg', TRUE),
-- (31, (SELECT journey_id FROM journeys WHERE title = 'Lyttelton Port Adventure'), 'images/events/preset/event3.jpg', TRUE),
-- (37, (SELECT journey_id FROM journeys WHERE title = 'Prebbleton Nature Retreat'), 'images/events/preset/event4.jpg', TRUE),
-- (43, (SELECT journey_id FROM journeys WHERE title = 'Rolleston Adventure Park'), 'images/events/preset/event5.jpg', TRUE);

-- Inserting 20 Campground Issues with randomized assigned_user_id (21 to 29)
INSERT INTO `issues` (`user_id`, `assigned_user_id`, `summary`, `description`, `status`)
VALUES
(1, 23, 'Broken Picnic Table', 'A picnic table at Lakeview Campground is damaged and needs repair.', 'new'),
(2, 27, 'Blocked Trail', 'The hiking trail at Pine Ridge Campground is blocked by fallen trees.', 'open'),
(3, 25, 'Flooded Campsite', 'Heavy rains have flooded several campsites at Riverside Campground.', 'resolved'),
(4, NULL, 'Lost Camper', 'A camper from Hilltop Campground has gone missing during a hike.', 'stalled'),
(5, 24, 'Broken Restroom', 'The restroom at Evergreen Campground is out of service.', 'new'),
(1, 28, 'Wild Animal Sighting', 'A bear was spotted near the campsites at Lakeview Campground.', 'open'),
(2, 26, 'Campfire Ban Violation', 'Visitors have been starting campfires despite the current ban.', 'resolved'),
(3, 21, 'Vandalized Sign', 'A sign at Riverside Campground was vandalized.', 'open'),
(4, 29, 'Overflowing Trash Bins', 'Trash bins at Hilltop Campground are overflowing and need to be emptied.', 'stalled'),
(5, 22, 'Noise Complaint', 'Loud music was reported at Evergreen Campground late at night.', 'new'),
(1, NULL, 'Damaged Water Pipe', 'A water pipe at Lakeview Campground is leaking and needs repair.', 'open'),
(2, 23, 'Injured Hiker', 'A hiker was injured on the trail at Pine Ridge Campground.', 'resolved'),
(3, 25, 'Missing Firewood', 'Firewood has gone missing from the Riverside Campground storage.', 'open'),
(4, 27, 'Lost Dog', 'A camper reported their dog missing at Hilltop Campground.', 'stalled'),
(5, 26, 'Power Outage', 'Power is out at several campsites in Evergreen Campground.', 'new'),
(1, 21, 'Illegal Parking', 'Vehicles have been parked in restricted areas at Lakeview Campground.', 'open'),
(2, 29, 'Blocked Road', 'A fallen tree is blocking the main road to Pine Ridge Campground.', 'resolved'),
(3, 28, 'Malfunctioning Shower', 'The shower at Riverside Campground is not working.', 'open'),
(4, 22, 'Campground Theft', 'Several personal items have been reported stolen at Hilltop Campground.', 'stalled'),
(5, NULL, 'Broken Playground Equipment', 'Playground equipment at Evergreen Campground needs repair.', 'new');


-- Inserting 20 Support Comments by issue creator or assigned user
INSERT INTO `support_comments` (`issue_id`, `user_id`, `content`)
VALUES
(1, 1, 'I also noticed this issue. It seems to be getting worse.'),
(2, 27, 'Thanks for reporting this! I''ll check it out tomorrow.'),
(3, 25, 'Is there any update on this issue?'),
(5, 5, 'The maintenance team should be notified about this.'),
(6, 28, 'Thanks for reporting! We''ll look into it soon.'),
(7, 2, 'Any estimated time for fixing this?'),
(8, 21, 'This problem has been around for a while.'),
(9, 4, 'I suggest adding more signs to prevent confusion.'),
(10, 22, 'Has anyone else experienced this issue?'),
(12, 23, 'Maybe a temporary fix could work for now.'),
(13, 3, 'This area has had similar issues in the past.'),
(14, 27, 'We need to raise this with the management.'),
(15, 26, 'Please update us when this is resolved.'),
(16, 21, 'Is there a way to prevent this from happening again?'),
(17, 2, 'The situation seems to be improving slightly.'),
(18, 28, 'I suggest putting up some warning signs.'),
(19, 4, 'More people should be aware of this issue.'),
(20, 24, 'Let''s make sure this is handled quickly.');
