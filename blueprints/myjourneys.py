from flask import Blueprint, render_template,request, redirect, url_for, flash, jsonify, session, make_response
from datetime import datetime,timedelta
from db import getCursor,get_db_cursor, get_db_connection, bcrypt
import os
from werkzeug.utils import secure_filename
import time


# Helper function for file operations
def get_file_path(filename):
    """Converts a stored filename to its absolute path"""
    if not filename:
        return None
    
    # Remove 'static/' prefix if present
    if filename.startswith('static/'):
        filename = filename[7:]
    
    return filename

def remove_photo_file(photo_path):
    """Safely removes a photo file if it exists"""
    if not photo_path:
        return False
    
    # Get the path without 'static/' prefix
    file_path = get_file_path(photo_path)
    
    # Add 'static/' prefix for file system operations
    full_path = os.path.join('static', file_path)
    
    if os.path.exists(full_path):
        try:
            os.remove(full_path)
            return True
        except OSError:
            return False
    return False

# Helper function to delete all events and photos for a journey
def delete_journey_events(cursor, journey_id):
    """Delete all events and their associated photos for a journey"""
    # Get all events for this journey
    cursor.execute("SELECT event_id, event_image FROM events WHERE journey_id = %s", (journey_id,))
    events = cursor.fetchall()
    
    # Delete photos for each event
    for event in events:
        if event['event_image']:
            remove_photo_file(event['event_image'])
    
    # Delete all events for this journey
    cursor.execute("DELETE FROM events WHERE journey_id = %s", (journey_id,))

myjourneys_bp = Blueprint('myjourneys', __name__)  

@myjourneys_bp.route('/myjourneys')
def myjourneys():
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    user_id = session.get('user_id')
    role = session.get('role')
    # status = session.get('status')
    username = session.get('username')
    status = request.args.get('status','All').strip()
    search = request.args.get ('search','').strip()
    connection, cursor = getCursor()
    cursor.execute('''SELECT 
    u.user_id,
    u.username,
    COUNT(DISTINCT j.journey_id) AS total_journeys,  
    COUNT(DISTINCT e.event_id) AS total_events,      
    COUNT(DISTINCT e.event_image) AS total_images   
    FROM users u
    LEFT JOIN journeys j ON u.user_id = j.user_id
    LEFT JOIN events e ON u.user_id = e.user_id
    WHERE u.user_id = %s  
    GROUP BY u.user_id, u.username;''', (user_id,))
    count_result = cursor.fetchone()
    total_journeys=count_result["total_journeys"]
    total_events=count_result["total_events"]
    total_images=count_result["total_images"]
# for search bar and filter query
    if status !='All' and search == '':
        cursor.execute('''
        SELECT j.*, 
            (SELECT e.event_image 
            FROM events e 
            WHERE e.journey_id = j.journey_id 
            AND e.event_image IS NOT NULL 
            ORDER BY e.last_edited DESC
            LIMIT 1) AS event_image
        FROM journeys j
        WHERE j.user_id = %s
        AND j.status = %s
        ORDER BY j.start_date DESC, j.last_edited DESC;
        ''', (user_id,status,))
    elif status != 'All' and search !='':
        cursor.execute (''' 
                        SELECT j.*, 
                            (SELECT e.event_image 
                            FROM events e 
                            WHERE e.journey_id = j.journey_id 
                            AND e.event_image IS NOT NULL 
                            ORDER BY e.last_edited DESC 
                            LIMIT 1) AS event_image
                        FROM journeys j
                        WHERE j.user_id = %s
                        AND j.status = %s
                        AND (LOWER(title) LIKE %s OR LOWER(description) LIKE %s)
                        ORDER BY j.start_date DESC, j.last_edited DESC;
                        ''',(user_id,status, f"%{search}%",f"%{search}%",))
    else:
        cursor.execute('''
                       SELECT j.*, 
                            (SELECT e.event_image 
                            FROM events e 
                            WHERE e.journey_id = j.journey_id 
                            AND e.event_image IS NOT NULL 
                            ORDER BY e.last_edited DESC 
                            LIMIT 1) AS event_image
                        FROM journeys j
                        WHERE j.user_id = %s
                        AND (LOWER(title) LIKE %s OR LOWER(description) LIKE %s)
                        ORDER BY j.start_date DESC, j.last_edited DESC;
                       ''', (user_id,f"%{search}%",f"%{search}%",))
    user_journeys = cursor.fetchall() or []
    for journey in user_journeys:
        journey['start_date']=journey['start_date'].strftime('%d-%m-%Y')
    if user_journeys:
        # journey_id=user_journeys[0]['journey_id']
        # cursor.execute('''SELECT event_image FROM events 
        #                 WHERE journey_id =%s
        #                 ORDER by last_edited DESC''', (journey_id,))
        # image_address=cursor.fetchone()
        cursor.close()
        connection.close()
        response =  make_response(render_template ('myjourneys.html', user_id=user_id, role=role, user_journeys=user_journeys, status=status, username=username, total_journeys=total_journeys, total_events=total_events, total_images=total_images,))
        response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '0'
        return response

    else:
        cursor.close()
        connection.close()
        response =  make_response(render_template ('myjourneys.html', user_id=user_id, role=role, user_journeys=[], status=status, username=username, total_journeys=total_journeys, total_events=total_events, total_images=total_images,))
        response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '0'
        return response
    
    # Get total counts
    # with get_db_cursor() as cursor:
    #     cursor.execute("SELECT COUNT(*) FROM journeys WHERE user_id = %s", (user_id,))
    #     total_journeys = cursor.fetchone()['COUNT(*)']
        
    #     cursor.execute("SELECT COUNT(*) FROM events WHERE user_id = %s", (user_id,))
    #     total_events = cursor.fetchone()['COUNT(*)']
        
    #     cursor.execute("SELECT COUNT(*) FROM events WHERE user_id = %s AND event_image != ''", (user_id,))
    #     total_images = cursor.fetchone()['COUNT(*)']
        
    #     # Get user's journeys with event counts
    #     cursor.execute("""
    #         SELECT j.*, 
    #                COUNT(DISTINCT e.event_id) as event_count,
    #                COUNT(DISTINCT CASE WHEN e.event_image != '' THEN e.event_id END) as image_count
    #         FROM journeys j
    #         LEFT JOIN events e ON j.journey_id = e.journey_id
    #         WHERE j.user_id = %s
    #         GROUP BY j.journey_id
    #         ORDER BY j.start_date DESC, j.last_edited DESC
    #     """, (user_id,))
        
    #     user_journeys = cursor.fetchall()
    
    # if user_journeys:
    #     # Format dates for display
    #     for journey in user_journeys:
    #         journey['start_date'] = journey['start_date'].strftime('%d-%m-%Y')
    #         journey['last_edited'] = journey['last_edited'].strftime('%d-%m-%Y')
        
    #     return render_template('myjourneys.html', 
    #                         user_id=user_id, 
    #                         role=role,
    #                         user_journeys=user_journeys,
    #                         status=status,
    #                         username=username,
    #                         total_journeys=total_journeys,
    #                         total_events=total_events,
    #                         total_images=total_images)
    # else:
    #     return render_template('myjourneys.html', 
    #                         user_id=user_id, 
    #                         role=role,
    #                         user_journeys=[],
    #                         status=status,
    #                         username=username,
    #                         total_journeys=total_journeys,
    #                         total_events=total_events,
    #                         total_images=total_images)



@myjourneys_bp.route('/addjourney', methods =['GET','POST'])
def addjourney():
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    current_date= datetime.now().strftime('%Y-%m-%d')
    # fetch all locations from db
    with get_db_cursor() as cursor:
        cursor.execute('''SELECT location from journeys
                    WHERE location is not NULL
                    AND location != '' 
                        ORDER by location ASC; ''')
        locations=cursor.fetchall()
        cursor.close()

    if request.method == "POST":
        user_id = session.get('user_id')
        title = request.form.get('title').capitalize()
        location = request.form.get('location').capitalize()
        description = request.form.get('description') .capitalize()
        start_date = request.form.get('start_date')
        status = request.form.get('status')
        with get_db_cursor() as cursor:
            cursor.execute("SELECT status FROM users WHERE user_id = %s;", (user_id,))
            current_status = cursor.fetchone()
        if current_status['status']=='blocked' and status=='public':
            flash("You are not allowed to post publicly at the moment", "error")
            return redirect(url_for('myjourneys.addjourney'))

        else:
            with get_db_cursor() as cursor:
                cursor.execute('''INSERT INTO journeys
                                (user_id, title, location, description, start_date, status) 
                                VALUES (%s,%s,%s,%s,%s,%s)
                                ''', (user_id, title, location, description, start_date, status))
                
            flash("Journey has been created successfully!", "success")
            return redirect(url_for('myjourneys.myjourneys'))
        
    return render_template('addjourney.html', locations=locations, current_date=current_date)
            

@myjourneys_bp.route('/journey/<int:journey_id>', methods=['GET'])
def view_journey(journey_id):
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    from_page = request.args.get('from', '/myjourneys')

    with get_db_cursor() as cursor:
        # Get journey information
        cursor.execute("SELECT * FROM journeys WHERE journey_id = %s", (journey_id,))
        journey = cursor.fetchone()
        
        if journey:
            # convert date to NZ format
            journey['start_date'] = journey['start_date'].strftime('%d-%m-%Y')
            
            # Get all events for this journey
            cursor.execute("""
                SELECT * FROM events 
                WHERE journey_id = %s 
                ORDER BY start_date ASC, last_edited DESC
            """, (journey_id,))
            events = cursor.fetchall()
            
            for event in events:
                # Format dates to include both date and time
                event['start_date'] = event['start_date'].strftime('%d-%m-%Y %H:%M')
                event['end_date'] = event['end_date'].strftime('%d-%m-%Y %H:%M')
                # Add has_photos flag for template
                event['has_photos'] = bool(event['event_image'] and event['event_image'].strip())
        else:
            flash("Journey not found", "error")
            return redirect(url_for('myjourneys.myjourneys'))
    
    # Get all events for this journey
    # cursor.execute("""
    #     SELECT * FROM events 
    #     WHERE journey_id = %s 
    #     ORDER BY start_date DESC
    # """, (journey_id,))
    # events = cursor.fetchall()
    # for event in events:
    #     event['start_date'] = event['start_date'].strftime('%d-%m-%Y')
    #     event['end_date']= event['end_date'].strftime('%d-%m-%Y')
    # cursor.close()

    response =  make_response(render_template('journey_detail.html', journey=journey, events=events,from_page=from_page))
    response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response


@myjourneys_bp.route('/journey/<int:journey_id>/add_event', methods=['GET', 'POST'])
def add_event(journey_id):
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    from_page = request.args.get('from', '/myjourneys')
    current_date = datetime.now().strftime('%Y-%m-%d')

    try:
        with get_db_cursor() as cursor:
            # Get all existing locations for the datalist
            cursor.execute('''SELECT DISTINCT location from events
                   WHERE location is not NULL
                   AND location != '' 
                    ORDER by location ASC; ''')
            locations = cursor.fetchall()

            # Verify journey exists and belongs to current user
            cursor.execute("SELECT * FROM journeys WHERE journey_id = %s AND user_id = %s", 
                        (journey_id, session['user_id']))
            journey = cursor.fetchone()
            
            if not journey:
                flash("Journey not found or access denied", "danger")
                return redirect(url_for('myjourneys.myjourneys'))
            
            if request.method == 'POST':
                # Get form data
                title = request.form.get('title')
                location = request.form.get('location')
                description = request.form.get('description')
                start_date = request.form.get('start_date')
                start_time = request.form.get('start_time', '00:00')
                end_date = request.form.get('end_date')
                end_time = request.form.get('end_time', '00:00')
                
                # Validate required fields
                if not title or not start_date or not location:
                    flash("Title, start date, and location are required", "danger")
                    return render_template('addevent.html', journey=journey, 
                                        form_data={'title': title, 'location': location, 
                                                'description': description, 'start_date': start_date,
                                                'start_time': start_time, 'end_date': end_date,
                                                'end_time': end_time}, 
                                        locations=locations,
                                        current_date=current_date)
                
                # Validate date format
                try:
                    # Parse date and time inputs
                    start_datetime = datetime.strptime(f"{start_date} {start_time}", "%Y-%m-%d %H:%M")
                    current_time = datetime.now()
                    
                    # Validate start date is not in the future
                    if start_datetime > current_time:
                        flash("Event start date cannot be in the future", "danger")
                        return render_template('addevent.html', journey=journey, 
                                            form_data={'title': title, 'location': location, 
                                                    'description': description, 'start_date': start_date,
                                                    'start_time': start_time, 'end_date': end_date,
                                                    'end_time': end_time}, 
                                            locations=locations,
                                            current_date=current_date)
                    
                    # Validate start date is not earlier than journey start date (date only)
                    journey_date = journey['start_date']
                    if isinstance(journey_date, str):
                        journey_date = datetime.strptime(journey_date, "%Y-%m-%d")
                    
                    if start_datetime.date() < journey_date.date():
                        flash("Event start date cannot be earlier than journey start date", "danger")
                        return render_template('addevent.html', journey=journey, 
                                            form_data={'title': title, 'location': location, 
                                                    'description': description, 'start_date': start_date,
                                                    'start_time': start_time, 'end_date': end_date,
                                                    'end_time': end_time}, 
                                            locations=locations,
                                            current_date=current_date)
                        
                    if end_date:
                        end_datetime = datetime.strptime(f"{end_date} {end_time}", "%Y-%m-%d %H:%M")
                        if end_datetime < start_datetime:
                            flash("End date/time cannot be earlier than start date/time", "danger")
                            return render_template('addevent.html', journey=journey, 
                                                form_data={'title': title, 'location': location, 
                                                        'description': description, 'start_date': start_date,
                                                        'start_time': start_time, 'end_date': end_date,
                                                        'end_time': end_time}, 
                                                locations=locations,
                                                current_date=current_date)
                    else:
                        # If no end date is provided, set it to start date plus 1 hour
                        end_datetime = start_datetime + timedelta(hours=1)
                        
                    # Format dates for database
                    db_start_date = start_datetime.strftime("%Y-%m-%d %H:%M:%S")
                    db_end_date = end_datetime.strftime("%Y-%m-%d %H:%M:%S")
                        
                    # Insert event into database
                    cursor.execute("""
                        INSERT INTO events 
                        (journey_id, user_id, title, location, description, start_date, end_date, event_image) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                    """, (journey_id, session['user_id'], title, location, description, 
                        db_start_date, db_end_date, ''))
                    
                    flash("Event added successfully", "success")
                    return redirect(url_for('myjourneys.view_journey', journey_id=journey_id))
                    
                except ValueError as e:
                    flash(f"Invalid date format: {str(e)}", "danger")
                    return render_template('addevent.html', journey=journey,
                                        form_data={'title': title, 'location': location, 
                                                'description': description, 'start_date': start_date,
                                                'start_time': start_time, 'end_date': end_date,
                                                'end_time': end_time}, 
                                        locations=locations,
                                        current_date=current_date)
            
            return render_template('addevent.html', journey=journey, from_page=from_page, 
                                locations=locations, current_date=current_date)

    except Exception as e:
        flash(f"An error occurred: {str(e)}", "danger")
        return redirect(url_for('myjourneys.myjourneys'))

@myjourneys_bp.route('/event/<int:event_id>/add_photo', methods=['GET', 'POST'])
def add_photo(event_id):
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    try:
        with get_db_cursor() as cursor:
            # Verify event exists and belongs to current user
            cursor.execute("""
                SELECT e.*, j.title as journey_title 
                FROM events e 
                JOIN journeys j ON e.journey_id = j.journey_id 
                WHERE e.event_id = %s AND e.user_id = %s
            """, (event_id, session['user_id']))
            event = cursor.fetchone()
            
            if not event:
                flash("Event not found or access denied", "danger")
                return redirect(url_for('myjourneys.myjourneys'))
            
            if request.method == 'POST':
                # Check if photo already exists
                if event['event_image'] and event['event_image'] != '':
                    flash("This event already has a photo. You can only have one photo per event.", "warning")
                    return redirect(url_for('myjourneys.view_journey', journey_id=event['journey_id']))

                # Process photo upload
                if 'photo' not in request.files:
                    flash('No photo uploaded', 'danger')
                    return redirect(request.url)
                
                photo = request.files['photo']
                if photo.filename == '':
                    flash('No photo selected', 'danger')
                    return redirect(request.url)
                
                if photo:
                    # Validate file type
                    if not photo.filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
                        flash('Invalid file type. Only PNG, JPG, JPEG, and GIF files are allowed.', 'danger')
                        return redirect(request.url)
                    
                    # Create unique filename
                    timestamp = int(time.time())
                    filename = f"event_{event_id}_{timestamp}_{secure_filename(photo.filename)}"
                    
                    # Save file in events subdirectory
                    upload_folder = os.path.join('static', 'images', 'events')
                    if not os.path.exists(upload_folder):
                        os.makedirs(upload_folder)
                        
                    photo_path = os.path.join(upload_folder, filename)
                    try:
                        print(f"Saving photo to: {photo_path}")
                        photo.save(photo_path)
                        
                        # Update database with photo path (store relative path without 'static/')
                        stored_path = os.path.join('images', 'events', filename)
                        cursor.execute("""
                            UPDATE events 
                            SET event_image = %s, last_edited = NOW()
                            WHERE event_id = %s
                        """, (stored_path, event_id))
                        
                        flash('Photo uploaded successfully!', 'success')
                        return redirect(url_for('myjourneys.view_journey', journey_id=event['journey_id']))
                        
                    except Exception as e:
                        flash(f'Error saving photo: {str(e)}', 'danger')
                        return redirect(request.url)
            
            return render_template('add_photo.html', event=event)
            
    except Exception as e:
        flash(f"An error occurred: {str(e)}", "danger")
        return redirect(url_for('myjourneys.myjourneys'))

@myjourneys_bp.route('/event/<int:event_id>/edit', methods=['GET', 'POST'])
def edit_event(event_id):
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    current_date = datetime.now().strftime('%Y-%m-%d')
    
    try:
        with get_db_cursor() as cursor:
            # Get all existing locations for the datalist
            cursor.execute('''SELECT DISTINCT location from events
                   WHERE location is not NULL
                   AND location != '' 
                    ORDER by location ASC; ''')
            locations = cursor.fetchall()

            # Get event and journey information
            cursor.execute("""
                SELECT e.*, j.title as journey_title, j.status as journey_status, j.user_id as journey_user_id
                FROM events e 
                JOIN journeys j ON e.journey_id = j.journey_id 
                WHERE e.event_id = %s
            """, (event_id,))
            event = cursor.fetchone()

            if not event:
                flash("Event not found", "danger")
                return redirect(url_for('myjourneys.myjourneys'))
            
            # Check if user has permission to edit
            is_owner = session.get('user_id') == event['user_id']
            is_journey_owner = session.get('user_id') == event['journey_user_id']
            is_staff = session.get('role') in ['editor', 'admin']
            is_public = event['journey_status'] == 'public'
            can_edit = is_owner or is_journey_owner or (is_staff and is_public)
            
            if not can_edit:
                flash("You don't have permission to edit this event.", "danger")
                return redirect(url_for('myjourneys.view_journey', journey_id=event['journey_id']))
            
            if request.method == 'POST':
                title = request.form.get('title')
                location = request.form.get('location')
                description = request.form.get('description')
                start_date = request.form.get('start_date')
                start_time = request.form.get('start_time', '00:00')
                end_date = request.form.get('end_date')
                end_time = request.form.get('end_time', '00:00')
                
                # Validate required fields
                if not title or not start_date or not location:
                    flash("Title, location, and start date are required fields.", "danger")
                    return render_template('edit_event.html', event=event, form_data=request.form, 
                                        locations=locations, current_date=current_date)
                
                # Validate date format
                try:
                    # Parse date and time inputs
                    start_datetime = datetime.strptime(f"{start_date} {start_time}", "%Y-%m-%d %H:%M")
                    current_time = datetime.now()
                    
                    # Validate start date is not in the future
                    if start_datetime > current_time:
                        flash("Event start date cannot be in the future", "danger")
                        return render_template('edit_event.html', event=event, form_data=request.form, 
                                            locations=locations, current_date=current_date)
                    
                    if end_date:
                        end_datetime = datetime.strptime(f"{end_date} {end_time}", "%Y-%m-%d %H:%M")
                        if end_datetime < start_datetime:
                            flash("End date/time cannot be earlier than start date/time", "danger")
                            return render_template('edit_event.html', event=event, form_data=request.form, 
                                                locations=locations, current_date=current_date)
                    else:
                        # If no end date is provided, set it to start date plus 1 hour
                        end_datetime = start_datetime + timedelta(hours=1)
                    
                    # Format dates for database
                    db_start_date = start_datetime.strftime("%Y-%m-%d %H:%M:%S")
                    db_end_date = end_datetime.strftime("%Y-%m-%d %H:%M:%S")
                        
                    # Update event in database
                    cursor.execute("""
                        UPDATE events 
                        SET title = %s, location = %s, description = %s, 
                            start_date = %s, end_date = %s, last_edited = NOW()
                        WHERE event_id = %s
                    """, (title, location, description, db_start_date, db_end_date, event_id))
                    
                    flash("Event updated successfully", "success")
                    return redirect(url_for('myjourneys.view_journey', journey_id=event['journey_id']))
                    
                except ValueError as e:
                    flash(f"Invalid date format: {str(e)}", "danger")
                    return render_template('edit_event.html', event=event, form_data=request.form, 
                                        locations=locations, current_date=current_date)
            
            # Format dates for the form
            if isinstance(event['start_date'], str):
                start_datetime = datetime.strptime(event['start_date'], "%Y-%m-%d %H:%M:%S")
            else:
                start_datetime = event['start_date']
            event['start_date'] = start_datetime.strftime('%Y-%m-%d')
            event['start_time'] = start_datetime.strftime('%H:%M')
            
            if isinstance(event['end_date'], str):
                end_datetime = datetime.strptime(event['end_date'], "%Y-%m-%d %H:%M:%S")
            else:
                end_datetime = event['end_date']
            event['end_date'] = end_datetime.strftime('%Y-%m-%d')
            event['end_time'] = end_datetime.strftime('%H:%M')
            
            return render_template('edit_event.html', 
                                event=event, 
                                is_owner=is_owner,
                                is_journey_owner=is_journey_owner,
                                is_staff=is_staff,
                                is_public=is_public,
                                locations=locations,
                                current_date=current_date)
                                
    except Exception as e:
        flash(f"An error occurred: {str(e)}", "danger")
        return redirect(url_for('myjourneys.myjourneys'))

@myjourneys_bp.route('/event/<int:event_id>/remove_photo', methods=['POST'])
def remove_event_photo(event_id):
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    try:
        with get_db_cursor() as cursor:
            # Get event information
            cursor.execute("""
                SELECT e.*, j.status as journey_status, j.user_id as journey_user_id
                FROM events e 
                JOIN journeys j ON e.journey_id = j.journey_id 
                WHERE e.event_id = %s
            """, (event_id,))
            event = cursor.fetchone()
            
            if not event:
                flash("Event not found", "danger")
                return redirect(url_for('myjourneys.myjourneys'))
            
            # Check if user has permission
            is_owner = session.get('user_id') == event['journey_user_id']
            is_event_owner = session.get('user_id') == event['user_id']
            is_staff = session.get('role') in ['editor', 'admin']
            can_edit = is_owner or is_event_owner or (is_staff and event['journey_status'] == 'public')
            
            if not can_edit:
                flash("You don't have permission to remove this photo.", "danger")
                return redirect(url_for('myjourneys.view_journey', journey_id=event['journey_id']))
            
            try:
                # Remove photo file if it exists
                remove_photo_file(event['event_image'])
                
                # Update database
                if not is_owner and is_staff:
                    # Add notification for admin/editor removal
                    notification = "[Photo was removed by site staff for content review. ]"
                    new_description = notification + (event['description'] or '')
                    cursor.execute("""
                        UPDATE events 
                        SET event_image = '', description = %s, last_edited = NOW()
                        WHERE event_id = %s
                    """, (new_description, event_id))
                else:
                    cursor.execute("""
                        UPDATE events 
                        SET event_image = '', last_edited = NOW()
                        WHERE event_id = %s
                    """, (event_id,))
                
                flash("Photo removed successfully", "success")
                return redirect(url_for('myjourneys.edit_event', event_id=event_id))
                
            except OSError as e:
                flash(f"Error removing photo file: {str(e)}", "danger")
                return redirect(url_for('myjourneys.edit_event', event_id=event_id))
                
    except Exception as e:
        flash(f"An error occurred: {str(e)}", "danger")
        return redirect(url_for('myjourneys.myjourneys'))

@myjourneys_bp.route('/delete_photo/<int:event_id>', methods=['POST'])
def delete_photo(event_id):
    if 'user_id' not in session:
        return jsonify({"error": "Please log in first"}), 401

    try:
        with get_db_cursor() as cursor:
            # Get event and journey information
            cursor.execute("""
                SELECT e.*, j.user_id as journey_owner_id, j.status
                FROM events e
                JOIN journeys j ON e.journey_id = j.journey_id
                WHERE e.event_id = %s
            """, (event_id,))
            
            event = cursor.fetchone()
            
            if not event:
                return jsonify({"error": "Event not found"}), 404

            # Check permissions
            is_owner = session['user_id'] == event['journey_owner_id']
            is_event_owner = session['user_id'] == event['user_id']
            is_staff = session.get('role') in ['editor', 'admin']
            is_public = event['status'] == 'public'

            if not (is_owner or is_event_owner or (is_staff and is_public)):
                return jsonify({"error": "Permission denied"}), 403

            try:
                # Remove physical file if it exists
                remove_photo_file(event['event_image'])

                # If admin/editor deletes the photo, add a notification in the description
                if not is_owner and is_staff:
                    notification = "[Photo was removed by site staff for content review. ]"
                    new_description = notification + (event['description'] or '')
                    cursor.execute("""
                        UPDATE events 
                        SET event_image = '', description = %s, last_edited = NOW()
                        WHERE event_id = %s
                    """, (new_description, event_id))
                else:
                    cursor.execute("""
                        UPDATE events 
                        SET event_image = '', last_edited = NOW()
                        WHERE event_id = %s
                    """, (event_id,))

                return jsonify({"message": "Photo deleted successfully"}), 200

            except OSError as e:
                print(f"Error removing file: {e}")
                # Continue even if file deletion fails, update database
                return jsonify({"error": str(e)}), 500

    except Exception as e:
        print(f"Error in delete_photo: {e}")
        return jsonify({"error": str(e)}), 500

@myjourneys_bp.route('/edit_journey/<int:journey_id>', methods=['GET', 'POST'])
def edit_journey(journey_id):
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    current_date= datetime.now().strftime('%Y-%m-%d')
    try:
        # retrieve all locations from db for dropdown filter
        with get_db_cursor() as cursor:
            cursor.execute('''SELECT location from journeys
                   WHERE location is not NULL
                   AND location != '' 
                    ORDER by location ASC; ''')
            locations=cursor.fetchall()

        with get_db_cursor() as cursor:
            # Get journey information
            cursor.execute("""
                SELECT j.*, u.username
                FROM journeys j 
                JOIN users u ON j.user_id = u.user_id
                WHERE j.journey_id = %s
            """, (journey_id,))
            journey = cursor.fetchone()
            
            if not journey:
                flash("Journey not found", "danger")
                return redirect(url_for('myjourneys.myjourneys'))
            
            # Check if user has permission to edit
            is_owner = session.get('user_id') == journey['user_id']
            is_staff = session.get('role') in ['editor', 'admin']
            is_public = journey['status'] == 'public'
            can_edit = is_owner or (is_staff and is_public)
            
            if not can_edit:
                flash("You don't have permission to edit this journey.", "danger")
                return redirect(url_for('myjourneys.view_journey', journey_id=journey_id))
            
            if request.method == 'POST':
                title = request.form.get('title')
                description = request.form.get('description')
                location = request.form.get('location').capitalize() or journey['location']
                description = request.form.get('description')
                start_date = request.form.get('start_date')
                status = request.form.get('status')
            # update journey
                with get_db_cursor() as cursor:
                    cursor.execute('''UPDATE journeys
                                    SET title = %s, location = %s, 
                                    description = %s, start_date = %s, status = %s
                                    WHERE journey_id = %s       
                                    ''',( title, location,description,start_date,
                                        status,journey_id,))
                    flash ("Journey has been modified successfully!","success")
                    return redirect (url_for('myjourneys.view_journey',
                                 journey_id=journey_id))
                
                # Validate required fields
                if not title:
                    flash('Title is required.', 'danger')
                    return render_template('edit_journey.html', journey=journey, form_data=request.form)
                elif not description:
                    flash('Description is required.', 'danger')
                    return render_template('edit_journey.html', journey=journey, form_data=request.form)
                    
                try:
                    # Only journey owner can edit these fields
                    if is_owner:
                        location = request.form.get('location')
                        start_date = request.form.get('start_date')
                        status = request.form.get('status')
                        
                        if not location or not start_date or not status:
                            flash('All fields are required.', 'danger')
                            return render_template('edit_journey.html', journey=journey, form_data=request.form)
                        
                        # Validate date format
                        try:
                            datetime.strptime(start_date, "%Y-%m-%d")
                        except ValueError:
                            flash("Invalid date format", "danger")
                            return render_template('edit_journey.html', journey=journey, form_data=request.form)
                        
                        cursor.execute("""
                            UPDATE journeys
                            SET title = %s, description = %s, location = %s, 
                                start_date = %s, status = %s, last_edited = NOW()
                            WHERE journey_id = %s
                        """, (title, description, location, start_date, status, journey_id))
                    else:
                        # Editors and admins can only edit title and description
                        cursor.execute("""
                            UPDATE journeys
                            SET title = %s, description = %s, last_edited = NOW()
                            WHERE journey_id = %s
                        """, (title, description, journey_id))
                    
                    flash('Journey updated successfully!', 'success')
                    return redirect(url_for('myjourneys.view_journey', journey_id=journey_id))
                    
                except Exception as e:
                    flash(f"Error updating journey: {str(e)}", "danger")
                    return render_template('edit_journey.html', journey=journey, form_data=request.form)
            
            # Format date for the form
            journey['start_date'] = journey['start_date'].strftime('%Y-%m-%d')
            
            return render_template('edit_journey.html', 
                                journey=journey, 
                                is_owner=is_owner,
                                is_staff=is_staff,
                                is_public=is_public, 
                                locations=locations,
                                current_date=current_date)
                                
    except Exception as e:
        flash(f"An error occurred: {str(e)}", "danger")
        return redirect(url_for('myjourneys.myjourneys'))

@myjourneys_bp.route('/event/<int:event_id>/delete', methods=['POST'])
def delete_event(event_id):
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    try:
        with get_db_cursor() as cursor:
            # Get event and journey information
            cursor.execute("""
                SELECT e.*, j.status as journey_status, j.user_id as journey_user_id
                FROM events e 
                JOIN journeys j ON e.journey_id = j.journey_id 
                WHERE e.event_id = %s
            """, (event_id,))
            event = cursor.fetchone()
            
            if not event:
                flash("Event not found", "danger")
                return redirect(url_for('myjourneys.myjourneys'))
            
            # Check if user has permission
            is_owner = session.get('user_id') == event['journey_user_id']
            is_event_owner = session.get('user_id') == event['user_id']
            is_staff = session.get('role') in ['editor', 'admin']
            can_delete = is_owner or is_event_owner or (is_staff and event['journey_status'] == 'public')
            
            if not can_delete:
                flash("You don't have permission to delete this event.", "danger")
                return redirect(url_for('myjourneys.view_journey', journey_id=event['journey_id']))
            
            journey_id = event['journey_id']
            
            try:
                # Remove photo file if it exists
                remove_photo_file(event['event_image'])
                
                # Delete event from database
                cursor.execute("DELETE FROM events WHERE event_id = %s", (event_id,))
                
                flash("Event deleted successfully", "success")
                return redirect(url_for('myjourneys.view_journey', journey_id=journey_id))
                
            except OSError as e:
                flash(f"Error removing photo file: {str(e)}", "danger")
                # Continue with event deletion even if photo removal fails
                cursor.execute("DELETE FROM events WHERE event_id = %s", (event_id,))
                flash("Event deleted but there was an error removing the photo file", "warning")
                return redirect(url_for('myjourneys.view_journey', journey_id=journey_id))
                
    except Exception as e:
        flash(f"An error occurred: {str(e)}", "danger")
        return redirect(url_for('myjourneys.myjourneys'))


@myjourneys_bp.route('/api/event/<int:event_id>/delete', methods=['POST'])
def api_delete_event(event_id):
    """API endpoint for deleting events via AJAX"""
    if 'user_id' not in session:
        return jsonify({"error": "Please log in first"}), 401

    try:
        with get_db_cursor() as cursor:
            # Get event and journey information
            cursor.execute("""
                SELECT e.*, j.status as journey_status, j.user_id as journey_user_id
                FROM events e 
                JOIN journeys j ON e.journey_id = j.journey_id 
                WHERE e.event_id = %s
            """, (event_id,))
            event = cursor.fetchone()
            
            if not event:
                return jsonify({"error": "Event not found"}), 404
            
            # Check if user has permission
            is_owner = session.get('user_id') == event['journey_user_id']
            is_event_owner = session.get('user_id') == event['user_id']
            is_staff = session.get('role') in ['editor', 'admin']
            can_delete = is_owner or is_event_owner or (is_staff and event['journey_status'] == 'public')
            
            if not can_delete:
                return jsonify({"error": "Permission denied"}), 403
            
            journey_id = event['journey_id']
            
            try:
                # Remove photo file if it exists
                remove_photo_file(event['event_image'])
                
                # Delete event from database
                cursor.execute("DELETE FROM events WHERE event_id = %s", (event_id,))
                
                return jsonify({
                    "message": "Event deleted successfully",
                    "journey_id": journey_id
                }), 200
                
            except OSError as e:
                # Continue with event deletion even if photo removal fails
                cursor.execute("DELETE FROM events WHERE event_id = %s", (event_id,))
                return jsonify({
                    "message": "Event deleted but there was an error removing the photo file",
                    "journey_id": journey_id
                }), 200
                
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@myjourneys_bp.route('/journey/<int:journey_id>/delete', methods=['POST'])
def delete_journey(journey_id):
    """Delete a journey and all its associated events and photos"""
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    try:
        with get_db_cursor() as cursor:
            # Get journey information
            cursor.execute("""
                SELECT j.*, u.username
                FROM journeys j 
                JOIN users u ON j.user_id = u.user_id
                WHERE j.journey_id = %s
            """, (journey_id,))
            journey = cursor.fetchone()
            
            if not journey:
                flash("Journey not found", "danger")
                return redirect(url_for('myjourneys.myjourneys'))
            
            # Check if user has permission to delete
            is_owner = session.get('user_id') == journey['user_id']
            is_staff = session.get('role') in ['editor', 'admin']
            is_public = journey['status'] == 'public'
            can_delete = is_owner or (is_staff and is_public)
            
            if not can_delete:
                flash("You don't have permission to delete this journey.", "danger")
                return redirect(url_for('myjourneys.view_journey', journey_id=journey_id))
            
            try:
                # Delete all events and their photos for this journey
                delete_journey_events(cursor, journey_id)
                
                # Delete the journey
                cursor.execute("DELETE FROM journeys WHERE journey_id = %s", (journey_id,))
                
                flash("Journey and all its events have been deleted successfully", "success")
                return redirect(url_for('myjourneys.myjourneys'))
                
            except Exception as e:
                flash(f"Error deleting journey: {str(e)}", "danger")
                return redirect(url_for('myjourneys.view_journey', journey_id=journey_id))
                
    except Exception as e:
        flash(f"An error occurred: {str(e)}", "danger")
        return redirect(url_for('myjourneys.myjourneys'))

@myjourneys_bp.route('/api/journey/<int:journey_id>/delete', methods=['POST'])
def api_delete_journey(journey_id):
    """API endpoint for deleting journeys via AJAX"""
    if 'user_id' not in session:
        return jsonify({"error": "Please log in first"}), 401

    try:
        with get_db_cursor() as cursor:
            # Get journey information
            cursor.execute("""
                SELECT j.*, u.username
                FROM journeys j 
                JOIN users u ON j.user_id = u.user_id
                WHERE j.journey_id = %s
            """, (journey_id,))
            journey = cursor.fetchone()
            
            if not journey:
                return jsonify({"error": "Journey not found"}), 404
            
            # Check if user has permission to delete
            is_owner = session.get('user_id') == journey['user_id']
            is_staff = session.get('role') in ['editor', 'admin']
            is_public = journey['status'] == 'public'
            can_delete = is_owner or (is_staff and is_public)
            
            if not can_delete:
                return jsonify({"error": "Permission denied"}), 403
            
            try:
                # Delete all events and their photos for this journey
                delete_journey_events(cursor, journey_id)
                
                # Delete the journey
                cursor.execute("DELETE FROM journeys WHERE journey_id = %s", (journey_id,))
                
                return jsonify({"message": "Journey deleted successfully"}), 200
                
            except Exception as e:
                return jsonify({"error": f"Error deleting journey: {str(e)}"}), 500
                
    except Exception as e:
        return jsonify({"error": str(e)}), 500
