# Importing the necessary libraries
# from flask import Flask, render_template, request, redirect, url_for, flash, jsonify, session
from flask import Flask, request, session, redirect, url_for, flash
from db import Bcrypt
from blueprints.auth import auth_bp
from blueprints.discover import discover_bp
from blueprints.myjourneys import myjourneys_bp
from blueprints.profile import profile_bp
from blueprints.users import users_bp
from blueprints.home import home_bp
from blueprints.subscriptions import subscriptions_bp



# import mysql.connector
# import mysql.connector.pooling
# import connect
# import os
# from datetime import datetime,timedelta
# from db import getCursor,connection

# Initializing the Flask application
app = Flask(__name__)
bcrypt = Bcrypt(app)

# Setting a secret key for the session
app.secret_key = "random12345"

@app.before_request
def require_login():
    allowed_routes = [
        "auth.login", 
        "auth.signup", 
        "home.publichome",  
        "static"
    ]
    if request.endpoint is None: 
        return

    if request.endpoint not in allowed_routes and not session.get("user_id"):
        # session["login_required"] = True
        flash("Please log in to continue.", "warning")
        return redirect(url_for("auth.login"))

app.register_blueprint(auth_bp)
app.register_blueprint(discover_bp)
app.register_blueprint(myjourneys_bp)
app.register_blueprint(profile_bp)
app.register_blueprint(users_bp)
app.register_blueprint(home_bp)
app.register_blueprint(subscriptions_bp)
# Setting Debug mode to get detailed error logs
if __name__ == "__main__":
    # Change to app.run(debug=False) for final production hosting 
    app.run(debug=True)

# Setting up the Database Connection
# dbconn = None
# connection_pool = mysql.connector.pooling.MySQLConnectionPool(pool_name="Wanderlog", user=connect.dbuser,
#     password=connect.dbpass, host=connect.dbhost,
#     database=connect.dbname, autocommit=True)
# connection = None

# Defining the Cursor Function
# def getCursor():
#     global dbconn
#     global connection
#     if connection is None:
#         connection = connection_pool.get_connection()
#     if dbconn is None:
#         dbconn = connection.cursor(dictionary=True)
#     return dbconn


# Function to check if a user is logged in and has the required role
# def check_login(role=None):
#     if 'user_id' not in session:
#         # Not logged in
#         return False 
#     if role and session.get('role') != role:
#         # Not authorized for this role
#         return False 
#     return True

#Function to check is a username is unique
# @app.route("/check-username", methods=["POST"])
# def checkusername():
#     data = request.get_json()
#     username = data.get("username")
#     cursor = getCursor()
#     cursor.execute("SELECT * FROM users WHERE username = %s;", (username,))
#     check = cursor.fetchone()
#     if check:
#         return jsonify({"is_unique": False, "message": "Username is already taken"})
#     return jsonify({"is_unique": True})

#Function to check is an email is unique
# @app.route("/check-email", methods=["POST"])
# def checkemail():
#     data = request.get_json()
#     email = data.get("email")
#     cursor = getCursor()
#     cursor.execute("SELECT * FROM users WHERE email = %s;", (email,))
#     check = cursor.fetchone()
#     if check:
#         return jsonify({"is_unique": False, "message": "Email is already taken"})
#     return jsonify({"is_unique": True})

#Function to check if old password is correct
# @app.route("/check-oldpassword", methods=["POST"])
# def checkoldpassword():
#     data = request.get_json()
#     oldpassword = data.get("oldpassword")
#     cursor = getCursor()
#     cursor.execute("SELECT password_hash FROM users WHERE username = %s;", (session['username'],))
#     stored_hashed_password = cursor.fetchone()
#     if bcrypt.check_password_hash(stored_hashed_password['password_hash'], oldpassword):
#         return jsonify({"Correct_Password": True, "message": "Old Password Matches"})
#     return jsonify({"Correct_Password": False, "message": "Old Password is Incorrect"})
    

# Login route
# @app.route("/login", methods=["GET", "POST"])
# def login():
#     if request.method == "POST":
#         username = request.form['username']
#         password = request.form['password']

#         cursor = getCursor()
#         cursor.execute("SELECT * FROM users WHERE username = %s;", (username,))
#         user = cursor.fetchone()

#         # Checking if the entered password is the same as the one stored in the DB
#         if user and bcrypt.check_password_hash(user['password_hash'], password):
#             # Storing user details in session
#             session['user_id'] = user['user_id']
#             session['username'] = user['username']
#             session['role'] = user['role'] 
 
#             # Redirecting According to role
#             if user['role'] == 'traveller':
#                 return redirect(url_for('travellerhome'))
#             elif user['role'] == 'editor':
#                 return redirect(url_for('editorhome'))
#             elif user['role'] == 'admin':
#                 return redirect(url_for('adminhome'))
#             else:
#                 flash("Invalid role", "error")
#                 return redirect(url_for('login'))
#         else:
#             flash("Invalid username or password", "error")
#             return render_template('login.html',username=username)
#     return render_template("login.html")

# SignUp route
# @app.route("/signup", methods=["GET", "POST"])
# def signup():
#     if request.method == 'POST':
#         cursor = getCursor()
#         username = request.form['username']
#         password = request.form['password']
#         # Hashing the password
#         password_hash = bcrypt.generate_password_hash(password).decode('utf-8')
#         email = request.form['email']
#         first_name = request.form['first_name']
#         last_name = request.form['last_name']
#         location = "Empty"
#         # Setting up a Default placeholder image
#         profile_image = "static/images/profileplaceholder.jpg"
#         role = "traveller"
#         status = "active"
#         description = ""
#         cursor.execute(
#             "INSERT INTO users (username, password_hash, email, first_name, last_name, location, profile_image, description, role, status) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);",
#             (username, password_hash, email, first_name, last_name, location, profile_image, description, role, status)
#         )
#         flash("Account created successfully! Please login.", "success")
#         return redirect(url_for('login'))

#     return render_template("signup.html")

# Logout route
# @app.route("/logout")
# def logout():
#     # Clearing the session data
#     session.clear()  
#     return redirect(url_for('login'))

# Profile route (only for logged-in users)
# @app.route('/profile',methods=["POST","GET"])
# def profile():
#     cursor = getCursor()
#     if session['role'] not in ['traveller','editor','admin']:
#         return redirect(url_for('accessdenied'))
    
#     if request.method=="POST":
#         username = request.form['username']
#         useremail = request.form['useremail']
#         first_name = request.form['first_name']
#         last_name = request.form['last_name']
#         location = request.form['location']
#         profile_picture = request.files['profile_picture']
#         print(profile_picture)
#         if profile_picture.filename != "":
#             # for python anywhere
#             # user_folder = os.path.join('wanderlog/static/images', str(session['user_id']))
#             # for local running
#             user_folder = os.path.join('static/images', str(session['user_id']))
#             # Creating the folder if it does not exists
#             os.makedirs(user_folder, exist_ok=True) 
#             file_path = os.path.join(user_folder, profile_picture.filename)
#             print(file_path)
#             # Saving the file
#             profile_picture.save(file_path) 
#             # for python anywhere
#             # file_path = f"static/images/{session['user_id']}/{profile_picture.filename}"

#         qstr = """
#             UPDATE users
#             SET username = %s,
#                 email = %s,
#                 first_name = %s,
#                 last_name = %s,
#                 location = %s,
#                 profile_image = %s
#             WHERE user_id = %s
#         """

#         # Setting a default placeholder image if no image is provided by user
#         if profile_picture.filename != "":
#             cursor.execute(qstr, (username, useremail, first_name, last_name, location, file_path, session['user_id']))
#         else:
#             cursor.execute(qstr, (username, useremail, first_name, last_name, location, 'static/images/profileplaceholder.jpg', session['user_id']))

#         connection.commit()
#         flash("Successfully Updated Your Profile!", 'success')

    
#     user_id = session['user_id']
#     cursor.execute("SELECT * FROM users WHERE user_id = %s;", (user_id,))
#     user = cursor.fetchone()  

#     if not user:
#         flash("User not found", "error")
#         return redirect(url_for('login'))
    
    # Creating the profile dictionary to send to the frontend
    # profile = {
    #     'username': user['username'],
    #     'email': user['email'],
    #     'role': user['role'],
    #     'status': user['status'],
    #     'location': user['location'],
    #     'first_name': user['first_name'] ,
    #     'last_name': user['last_name'] ,
    #     'profile_image': user['profile_image'] 
    # }

    # return render_template('profile.html', profile=profile)

# Change password route 
# @app.route('/change_password', methods=["POST","GET"])
# def changepassword():
#     return render_template('changepassword.html')

# Update Password route
# @app.route("/updatepassword", methods=["GET","POST"])
# def updatepassword():
#     if request.method=="POST":
#         cursor = getCursor()
#         password = request.form['password']
#         userid = session['user_id']
#         # Hashing the password
#         password_hash = bcrypt.generate_password_hash(password).decode('utf-8')
#         cursor.execute("UPDATE users SET password_hash = %s WHERE user_id = %s", (password_hash, userid))
#         connection.commit() 
#         flash("Successfully Updated Password!", "success")

#     return render_template("changepassword.html")


# Access Denied route
# @app.route("/access-denied")
# def accessdenied():
#     return render_template("access_denied.html")

# Traveller Home route
# @app.route("/traveller/home")
# def travellerhome():
#     if check_login('traveller'):
#         return render_template("travellerhome.html")
#     else:
#         return render_template("access_denied.html")

# Editor Home route
# @app.route("/editor/home")
# def editorhome():
#     if check_login('editor'):
#         return render_template("editorhome.html")
#     else:
#         return render_template("access_denied.html")

# Admin Home route
# @app.route("/admin/home")
# def adminhome():
#     if check_login('admin'):
#         return render_template("adminhome.html")
#     else:
#         return render_template("access_denied.html")

# Example Function Format
# @app.route("/example")
# By splitting the user roles, a single function can be reused and we can avoid 
# having to use multiple redundant copies of a single route to the same page.
# def example():
    # If no one is logged in redirect to access_denied
    # if session['role'] != '':
    #     return render_template('access_denied.html')
    # If logged in user is admin
    # elif session['role'] == 'admin':
    #     print('Admin Functionality for the page')
    # If logged in user is editor
    # elif session['role'] == 'editor':
    #     print('Editor Functionality for the page')
    # If logged in user is traveller
    # elif session['role'] == 'traveller':
    #     print('Traveller Functionality for the page')

# Example format for using getCursor
# def cursorExample():
    # Call the get cursor function
    # cursor = getCursor()
    # Set up the Query
    # qstr = """
    #    INSERT INTO Tables (col1, col2, col3) 
    #    VALUES (%s, %s, %s)
    # """
    # To execute the sql query 
    # cursor.execute(qstr, (value1, value2, value3))
    

# Add the Functions under your section to avoid confusion
# Tasks can be split to make sure that no two of us will be
# working on the same function (This will make it easier to merge later)


# Siva's Functions


# Shaun's Functions


# Faye's Functions
# @app.route('/myjourneys', methods =['GET'])
# def myjourneys():
#     user_id = session.get('user_id')
#     role = session.get('role')
#     status = request.args.get('status','All').strip()
#     search = request.args.get ('search','').strip()
#     cursor= getCursor()
#     if status !='All' and search == '':
#         cursor.execute('''SELECT * FROM journeys 
#                         WHERE user_id =%s
#                         AND status =%s
#                         ORDER by start_date DESC''', (user_id,status,))
#     elif status != 'All' and search !='':
#         cursor.execute (''' SELECT * FROM journeys
#                         WHERE user_id =%s
#                         AND status =%s
#                         AND description LIKE %s''',(user_id,status, f"%{search}%",))
#     else:
#         cursor.execute('''SELECT * FROM journeys 
#                         WHERE user_id =%s
#                         AND description LIKE %s
#                         ORDER by start_date DESC''', (user_id,f"%{search}%",))
#     user_journeys = cursor.fetchall()
#     return render_template ('myjourneys.html', 
#                             user_id=user_id, 
#                             role=role,
#                             user_journeys=user_journeys,
#                             status=status)

# @app.route('/addjourney', methods =['GET','POST'])
# def addjourney():
#     current_date= datetime.now().strftime('%Y-%m-%d')
#     if request.method == "POST":
#         role=session.get('role')
#         user_id= session.get('user_id')
#         title=request.form.get('title')
#         location= request.form.get('location')
#         description=request.form.get('description')
#         start_date= request.form.get('start_date')
#         # last_edited=datetime.datetime.now().strftime("%d-%m-%Y %X")
#         # need to validate for manual date entry
#         status= request.form.get('status')
#         cursor = getCursor()
#         cursor.execute('''INSERT INTO journeys
#                         (`user_id`, `title`, 
#                        `location`, `description`, `start_date`, 
#                        `status`) VALUES (%s,%s,%s,%s,%s,%s)
#                         ''',(user_id, title, location,description,start_date,
#                               status,))
#         new_journey_id=cursor.lastrowid
#         flash ("Journey has been created successfully!","success")
#         return redirect (url_for('myjourneys'))
#     return render_template('addjourney.html', 
#                            current_date=current_date)

# Junwen's Functions


# Rowans's Functions


