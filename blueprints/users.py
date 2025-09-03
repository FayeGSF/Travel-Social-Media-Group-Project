from flask import Blueprint, render_template,request, redirect, url_for, flash, jsonify, session, make_response
from db import getCursor, bcrypt,get_db_cursor
from blueprints.auth import check_login
from datetime import datetime,timedelta

import os

users_bp = Blueprint('users', __name__)  

# Function to check if a user is logged in and has the required role
def check_login(role=None):
    if 'user_id' not in session:
        # Not logged in
        return False 
    if role and session.get('role') != role:
        # Not authorized for this role
        return False 
    return True

from flask import request, render_template, make_response

@users_bp.route("/users")
def homepage():
    if check_login('admin'):
        connection, cursor = getCursor()

        filter_status = request.args.get('filter', 'all')
        search_query = request.args.get('search', '').strip()

        # Base query
        qstr = "SELECT * FROM users"
        params = []
        conditions = []  

        # Add role filter if it dosent include all 
        if filter_status != 'all':
            conditions.append("role = %s")
            params.append(filter_status)

        # search condition for user management 
        if search_query:
            conditions.append("(username LIKE %s OR email LIKE %s OR first_name LIKE %s OR last_name LIKE %s)")
            params.extend([f"%{search_query}%", f"%{search_query}%", f"%{search_query}%", f"%{search_query}%"])

       
        if conditions:
            qstr += " WHERE " + " AND ".join(conditions)

      
        cursor.execute(qstr, params)
        users_filtered = cursor.fetchall()

        cursor.execute("""SELECT role, COUNT(role) AS count
                        FROM users
                        GROUP BY role;
                        """)
        roles_num=cursor.fetchall()
        roles_num={row['role']: row['count'] for row in roles_num}


        cursor.close()
        connection.close()
        response =  make_response(render_template("users.html",users_filtered=users_filtered,roles_num=roles_num))
        response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '0'
        return response
    else:
        return render_template("access_denied.html")


# Profile route (only for logged-in users)
@users_bp.route('/userprofile',methods=["POST","GET"])
def userprofile():
    if not check_login('admin') or check_login('editor'):
        return redirect(url_for('accessdenied'))
    
    # Getting fields from the url
    user_id = request.args.get("userid", "").strip() 
    role = request.args.get("role", "").strip() 
    status = request.args.get("status", "").strip() 
    connection, cursor = getCursor()

    if role != "":
        qstr = """
                UPDATE users
                SET role = %s
                WHERE user_id = %s
            """
        cursor.execute(qstr, (role, user_id,))
        flash("Successfully Changed User Role to " + role + " !", "success")

    if status != "":
        qstr = """
            UPDATE users
            SET status = %s
            WHERE user_id = %s
        """
        cursor.execute(qstr, (status, user_id,))
        flash("Successfully Changed User Status to " + status + " !", "success")
        if status.lower() in ['blocked', 'banned']:
            username=session.get('username')
            append_action_history(user_id, status, username)

    cursor.execute("SELECT * FROM users WHERE user_id = %s;", (user_id,))
    user = cursor.fetchone() 

    if not user:
        flash("User not found", "error")
        return redirect(url_for('login'))
        
    # Creating the profile dictionary to send to the frontend
    profile = {
        'userid': user['user_id'],
        'username': user['username'],
        'email': user['email'],
        'role': user['role'],
        'status': user['status'],
        'location': user['location'],
        'first_name': user['first_name'] ,
        'last_name': user['last_name'] ,
        'profile_image': user['profile_image'] ,
        'description': user['description'] ,
        'action_history':user['action_history']

    }

    cursor.close()
    connection.close()

    response =  make_response(render_template('userprofile.html', profile=profile,selected_value=user['role'],selected_status=user['status']))
    response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response



@users_bp.route('/edit_profile',methods=["POST"])
def edit_profile():
    if session.get('role') not in ['admin']:
        return redirect(url_for('home.accessdenied'))
    
    user_id=request.form['user_id']

    # if request.method=="POST":
    username = request.form['username']
    description = request.form['description']
    useremail = request.form['useremail']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    location = request.form['location']
    with get_db_cursor() as cursor:
            qstr = """
                UPDATE users
                SET username = %s,
                    description = %s,
                    email = %s,
                    first_name = %s,
                    last_name = %s,
                    location = %s
                WHERE user_id = %s
            """
            cursor.execute(qstr, (username, description, useremail, first_name, last_name, location, user_id))

            cursor.execute("SELECT description FROM users WHERE user_id = %s", (user_id,))
            result = cursor.fetchone()
    
    if result != description:
        username=session.get('username')
        append_action_history(user_id, 'Changed description', username)

    flash("Successfully Updated Profile!", 'success')
    return redirect(url_for('users.userprofile') + f"?userid={user_id}") 


    # with get_db_cursor() as cursor:
    #     cursor.execute("SELECT * FROM users WHERE user_id = %s;", (user_id,))
    #     user = cursor.fetchone()  

    # if not user:
    #     flash("User not found", "error")
    #     return redirect(url_for('auth.login'))
    
    # profile = {
    #     'username': user['username'],
    #     'description': user['description'],
    #     'email': user['email'],
    #     'role': user['role'],
    #     'status': user['status'],
    #     'location': user['location'],
    #     'first_name': user['first_name'] ,
    #     'last_name': user['last_name'] ,
    #     'profile_image': user['profile_image'] 
    # }
    # role = request.args.get("role", "").strip() 
    # status = request.args.get("status", "").strip() 

    # cursor.close()


    # response =  make_response(render_template('userprofile.html', profile=profile,selected_value=user['role'],selected_status=user['status']))
    # response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
    # response.headers['Pragma'] = 'no-cache'
    # response.headers['Expires'] = '0'
    # return response

def append_action_history(user_id, action_text, admin_name):
    now = datetime.now().strftime("%Y-%m-%d %H:%M")
    new_entry = f"{action_text} by {admin_name} at {now}"
    
    with get_db_cursor() as cursor:
        cursor.execute("SELECT action_history FROM users WHERE user_id = %s", (user_id,))
        result = cursor.fetchone()

    if result and result['action_history']:
        old_history = result['action_history']
        updated_history = old_history + ", " + new_entry
    else:
        updated_history = new_entry 

    with get_db_cursor() as cursor:
        cursor.execute("UPDATE users SET action_history = %s WHERE user_id = %s", (updated_history, user_id))
