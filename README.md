# Wanderlog - Travel Journal Web Application

A Flask-based web application for creating and sharing travel journals with features for both free and premium users.

## Project Setup Guide

### Prerequisites

- Python 3.8 or higher
- MySQL 8.0 or higher
- pip (Python package manager)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/COMP639_Project_2_CHC.git
   cd COMP639_Project_2_CHC
   ```

2. Create a virtual environment (optional but recommended):
   ```bash
   python -m venv venv
   
   # Activate on Windows
   venv\Scripts\activate
   
   # Activate on macOS/Linux
   source venv/bin/activate
   ```

3. Install required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Configure the database connection:
   - Create the `connect.py` file and update the database credentials:
     ```python
     dbhost = "localhost"
     dbuser = "your_mysql_username"
     dbpass = "your_mysql_password"
     dbname = "Wanderlog"
     ```

5. Create the database:
   ```bash
   # Log into MySQL
   mysql -u your_mysql_username -p
   
   # Create database
   CREATE DATABASE Wanderlog;
   EXIT;
   
   # Import the database schema
   mysql -u your_mysql_username -p Wanderlog < sql/create_database.sql
   
   # Import sample data
   mysql -u your_mysql_username -p Wanderlog < sql/populate_database.sql
   ```

6. Run the application:
   ```bash
   python app.py
   ```

7. Access the application:
   - Open a web browser and navigate to `http://localhost:5000`

## Logging Configuration

Logging can be controlled via environment variables:

1. **Enable/Disable Logging**:
   ```bash
   # Enable logging (default is true)
   export ENABLE_LOGGING=true
   
   # Disable logging
   export ENABLE_LOGGING=false
   ```

2. **Set Log Level**:
   ```bash
   # Available levels: DEBUG, INFO, WARNING, ERROR
   export LOG_LEVEL=INFO
   ```

3. **Enable Journey View Debug**:
   ```bash
   # Enable detailed debugging for journey view
   export DEBUG_JOURNEY_VIEW=true
   ```

4. **Log File Locations**:
   - Application logs: `logs/app.log`
   - Access logs: `logs/access.log`

## Test User Accounts

### Regular Users (Free/Trial Plan)
These users have the basic trial plan (plan_id=1, "1 month trial"):
- Username: `traveller01` to `traveller20` (20 total traveller users)
- Password: `traveller123`

### Premium Users (1 Month Plan)
These users have the premium 1-month plan (plan_id=5, "1 month"):
- Username: `traveller03`, `traveller04`, `traveller08`
- Password: `traveller123`

### Premium Users (3 Month Plan)
These users have the premium 3-month plan (plan_id=6, "3 months"):
- Username: `traveller05`, `traveller06`, `traveller09`
- Password: `traveller123`

### Editor Accounts (6 total)
- Username: `editor01` to `editor06`
- Password: `editor123`

### Admin Accounts (3 total)
- Username: `admin01` to `admin03`
- Password: `admin123`

## License
This project was developed by a team of 5 student developers including Shu Fen Goh at Lincoln University NZ.

## How to use
### Users
- Once logged in with the credentials provided, add a journey. Within each journey, a collection of events
can be created to logg travel memories and upload photos and location tagging. 
- Users can share their journals and events publicly or keep it as private. 
- Users have access to subscriptions which allows them privileges - gamification, notifications, commenting and responding to chats with other user. 

### Editors and Admin
- Editors and admin have added privileges like helpdesk support, escalating comments etc. 
- Admins have a added level of user modification where they can block or ban a user, resolve helpdesk tickets etc. 