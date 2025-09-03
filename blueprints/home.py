from flask import Blueprint, render_template,request, redirect, url_for, flash, jsonify, session, make_response
from db import getCursor, bcrypt

home_bp = Blueprint('home', __name__)  

# Function to check if a user is logged in and has the required role
def check_login(role=None):
    if 'user_id' not in session:
        # Not logged in
        return False 
    if role and session.get('role') != role:
        # Not authorized for this role
        return False 
    return True

# Home route
@home_bp.route("/")
def publichome():   
    return render_template('public_home.html')

# Access Denied route
@home_bp.route("/access-denied")
def accessdenied():
    return render_template("access_denied.html")

# Traveller Home route
@home_bp.route("/traveller/home")
def travellerhome():
    if check_login('traveller'):
        response =  make_response(render_template("travellerhome.html"))
        response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '0'
        return response
    else:
        return render_template("access_denied.html")

# Editor Home route
@home_bp.route("/editor/home")
def editorhome():
    if check_login('editor'):
        response =  make_response(render_template("editorhome.html"))
        response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '0'
        return response
    else:
        return render_template("access_denied.html")

# Admin Home route
@home_bp.route("/admin/home")
def adminhome():
    if check_login('admin'):
        response =  make_response(render_template("adminhome.html"))
        response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '0'
        return response
    else:
        return render_template("access_denied.html")
