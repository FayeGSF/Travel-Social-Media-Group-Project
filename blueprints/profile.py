from flask import Blueprint, render_template,request, redirect, url_for, flash, jsonify, session, make_response
from db import getCursor, bcrypt, get_db_cursor
from blueprints.users import append_action_history
import os

profile_bp = Blueprint('profile', __name__)  

# Remove Image Route
@profile_bp.route('/remove_image', methods=["POST","GET"])
def remove_image():
    print("this is called")
    connection, cursor = getCursor()
    profile_image = "static/images/profileplaceholder.png"
    
    from_page = request.args.get('from', 'profile')
    
    if from_page == 'userprofile':
        user_id = request.args.get('userid')
        qstr = """
                UPDATE users
                    SET profile_image = %s
                WHERE user_id = %s
            """
        cursor.execute(qstr, (profile_image, user_id))
    
        username=session.get('username')
        append_action_history(user_id, 'Changed profile picture ', username)

        cursor.close()
        connection.close() 
        flash("Successfully Removed Profile Image!", "success")

        return redirect(url_for('users.userprofile', userid=user_id))
    else:

        qstr = """
            UPDATE users
                SET profile_image = %s
            WHERE user_id = %s
        """
        cursor.execute(qstr, (profile_image, session['user_id']))
        cursor.close()
        connection.close() 
        flash("Successfully Updated Your Profile Image!", "success")
        return redirect(url_for('profile.profile'))

    
    
    # user_id = session['user_id']
    # cursor.execute("SELECT * FROM users WHERE user_id = %s;", (user_id,))
    # user = cursor.fetchone()  

    # if not user:
    #     flash("User not found", "error")
    #     return redirect(url_for('login'))
    



# Profile route (only for logged-in users)
@profile_bp.route('/profile',methods=["POST","GET"])
def profile():
    if session.get('role') not in ['traveller', 'editor', 'admin']:
        return redirect(url_for('home.accessdenied'))
    
    if request.method=="POST":
        username = request.form['username']
        description = request.form['description']
        print(description)
        useremail = request.form['useremail']
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        location = request.form['location']
        profile_picture = request.files.get('profile_picture')
        print(profile_picture)
        with get_db_cursor() as cursor:

            if profile_picture and profile_picture.filename != "":
                # for python anywhere
                # user_folder = os.path.join('wanderlog/static/images', str(session['user_id']))
                # for local running
                    user_folder = os.path.join('static/images', str(session['user_id']))
                    # Creating the folder if it does not exists
                    os.makedirs(user_folder, exist_ok=True) 
                    file_path = os.path.join(user_folder, profile_picture.filename)
                    print(file_path)
                    # Saving the file
                    profile_picture.save(file_path) 
                    # for python anywhere
                    # file_path = f"static/images/{session['user_id']}/{profile_picture.filename}"

                    qstr = """
                        UPDATE users
                        SET username = %s,
                            description = %s,
                            email = %s,
                            first_name = %s,
                            last_name = %s,
                            location = %s,
                            profile_image = %s
                        WHERE user_id = %s
                    """
                
                    cursor.execute(qstr, (username, description, useremail, first_name, last_name, location, file_path, session['user_id']))

            else:
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
                cursor.execute(qstr, (username, description, useremail, first_name, last_name, location, session['user_id']))
            
        flash("Successfully Updated Your Profile!", 'success')

    user_id = session['user_id']
    with get_db_cursor() as cursor:
        cursor.execute("SELECT * FROM users WHERE user_id = %s;", (user_id,))
        user = cursor.fetchone()  

    if not user:
        flash("User not found", "error")
        return redirect(url_for('login'))
    
    # Creating the profile dictionary to send to the frontend
    profile = {
        'username': user['username'],
        'description': user['description'],
        'email': user['email'],
        'role': user['role'],
        'status': user['status'],
        'location': user['location'],
        'first_name': user['first_name'] ,
        'last_name': user['last_name'] ,
        'profile_image': user['profile_image'] 
    }

    cursor.close()


    response =  make_response(render_template('profile.html', profile=profile))
    response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response




# Change password route 
@profile_bp.route('/change_password', methods=["POST","GET"])
def changepassword():
    response =  make_response(render_template('changepassword.html'))
    response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response


# Update Password route
@profile_bp.route("/updatepassword", methods=["GET","POST"])
def updatepassword():
    if request.method=="POST":
        password = request.form['password']
        userid = session['user_id']
        # Hashing the password
        password_hash = bcrypt.generate_password_hash(password).decode('utf-8')
        
        with get_db_cursor() as cursor:
            cursor.execute("UPDATE users SET password_hash = %s WHERE user_id = %s", (password_hash, userid))
            flash("Successfully Updated Password!", "success")

    response =  make_response(render_template("changepassword.html"))
    response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response

