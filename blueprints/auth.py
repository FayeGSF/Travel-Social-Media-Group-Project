from flask import Blueprint, render_template,request, redirect, url_for, flash, jsonify, session
from db import get_db_cursor, bcrypt 

auth_bp = Blueprint('auth', __name__)  

# Function to check if a user is logged in and has the required role
def check_login(role=None):
    if 'user_id' not in session:
        # Not logged in
        return False 
    if role and session.get('role') != role:
        # Not authorized for this role
        return False 
    return True

#Function to check is a username is unique
@auth_bp.route("/check-username", methods=["POST"])
def checkusername():
    data = request.get_json()
    username = data.get("username")
    with get_db_cursor() as cursor:
        cursor.execute("SELECT * FROM users WHERE username = %s;", (username,))
        check = cursor.fetchone()
    if check:
        return jsonify({"is_unique": False, "message": "Username is already taken"})
    return jsonify({"is_unique": True})

#Function to check is an email is unique
@auth_bp.route("/check-email", methods=["POST"])
def checkemail():
    data = request.get_json()
    email = data.get("email")
    with get_db_cursor() as cursor:
        cursor.execute("SELECT * FROM users WHERE email = %s;", (email,))
        check = cursor.fetchone()
    if check:
        return jsonify({"is_unique": False, "message": "Email is already taken"})
    return jsonify({"is_unique": True})

#Function to check if old password is correct
@auth_bp.route("/check-oldpassword", methods=["POST"])
def checkoldpassword():
    data = request.get_json()
    oldpassword = data.get("oldpassword")
    with get_db_cursor() as cursor:
        cursor.execute("SELECT password_hash FROM users WHERE username = %s;", (session['username'],))
        stored_hashed_password = cursor.fetchone()
    if bcrypt.check_password_hash(stored_hashed_password['password_hash'], oldpassword):
        return jsonify({"Correct_Password": True, "message": "Old Password Matches"})
    return jsonify({"Correct_Password": False, "message": "Old Password is Incorrect"})


# Login route
@auth_bp.route("/login", methods=["GET", "POST"])
def login():
    user_id = session.get('user_id')
    if user_id:
        return redirect(url_for("myjourneys.myjourneys"))    
    elif request.method == "POST":
        username = request.form['username']
        password = request.form['password']

        with get_db_cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE username = %s;", (username,))
            user = cursor.fetchone()

        # Checking if the entered password is the same as the one stored in the DB
        if user and bcrypt.check_password_hash(user['password_hash'], password):
            
            if user['status']=='banned':
                flash("Your account has been banned, Please contact the admin first", "error")
                return render_template("login.html")
            else :
                # Storing user details in session
                session['user_id'] = user['user_id']
                session['username'] = user['username']
                session['role'] = user['role'] 
                # Redirecting According to role
                if user['role'] :
                    return redirect(url_for('myjourneys.myjourneys'))
                else:
                    flash("Invalid role", "error")
                    return redirect(url_for('auth.login'))
        else:
            flash("Invalid username or password", "error")
            return render_template('login.html',username=username)
    else:
        return render_template("login.html")

# SignUp route
@auth_bp.route("/signup", methods=["GET", "POST"])
def signup():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        # Hashing the password
        password_hash = bcrypt.generate_password_hash(password).decode('utf-8')
        email = request.form['email']
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        location = "Empty"
        # Setting up a Default placeholder image
        profile_image = "static/images/profileplaceholder.png"
        role = "traveller"
        status = "active"
        description = ""
        
        with get_db_cursor() as cursor:
            cursor.execute(
                "INSERT INTO users (username, password_hash, email, first_name, last_name, location, profile_image, description, role, status) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);",
                (username, password_hash, email, first_name, last_name, location, profile_image, description, role, status)
            )
        flash("Account created successfully! Please login.", "success")
        return redirect(url_for('auth.login'))

    return render_template("signup.html")

# Logout route
@auth_bp.route("/logout")
def logout():
    # Clearing the session data
    session.clear()  
    return redirect(url_for('home.publichome'))


