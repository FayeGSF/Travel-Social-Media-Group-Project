from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify, session, make_response
from db import getCursor, get_db_cursor,bcrypt

discover_bp = Blueprint('discover', __name__)

@discover_bp.route("/discover", methods=["GET"])
def homepage():
    """Fetch and display public journeys with search functionality."""
    user_id = session.get('user_id')  
    search = request.args.get('search', '').strip()
    # status_filter = request.args.get('status', 'public').strip().lower()

    with get_db_cursor() as cursor:
        query = '''
                SELECT j.*, 
                    (SELECT e.event_image 
                    FROM events e 
                    WHERE e.journey_id = j.journey_id 
                    AND e.event_image != ''
                    ORDER BY e.last_edited DESC
                    LIMIT 1) AS event_image
                FROM journeys j
                WHERE status = 'public'
            '''
        params = []

        if search:

            query += " AND (LOWER(title) LIKE %s OR LOWER(description) LIKE %s)"
            params.extend((f"%{search.lower()}%", f"%{search.lower()}%"))
        

        query += " ORDER BY last_edited DESC"
        cursor.execute(query, tuple(params))
        public_journeys = cursor.fetchall()

    # if search:
    #     query += " AND (LOWER(title) LIKE %s OR LOWER(description) LIKE %s)"
    #     params.extend((f"%{search.lower()}%", f"%{search.lower()}%"))

    # if status_filter in ['public', 'private']:
    #     query += " AND status = %s"
    #     params.append(status_filter)

    # query += " ORDER BY last_edited DESC"


    
    # Manually close cursor and connection
    # cursor.close()
    response =  make_response(render_template("discover.html", user_id=user_id, public_journeys=public_journeys))
    response.headers['Cache-Control'] = 'no-store, no-cache, must revalidate, postcheck=0, pre-check=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response

@discover_bp.route('/update_journey_status', methods=['POST'])
def update_journey_status():
    """Allow a user to update the status of their journey."""
    user_id = session.get('user_id')  
    if not user_id:
        return jsonify({'error': 'Unauthorized'}), 403

    journey_id = request.json.get('journey_id')
    new_status = request.json.get('status')

    if new_status not in ['Public', 'Private']:
        return jsonify({'error': 'Invalid status'}), 400

    with get_db_cursor() as cursor:
        # Check if user owns the journey
        qstr_check = "SELECT journey_id FROM journeys WHERE journey_id = %s AND user_id = %s"
        cursor.execute(qstr_check, (journey_id, user_id))
        if not cursor.fetchone():
            return jsonify({'error': 'Journey not found or unauthorized'}), 404

        # Update journey status
        qstr_update = "UPDATE journeys SET status = %s WHERE journey_id = %s AND user_id = %s"
        cursor.execute(qstr_update, (new_status, journey_id, user_id))

    return jsonify({'message': 'Status updated successfully'})

@discover_bp.route("/toggle_visibility", methods=["POST"])
def toggle_visibility():
    if 'user_id' not in session:
        return jsonify({"error": "Please log in first"}), 401

    data = request.get_json()
    journey_id = data.get('journey_id')
    new_status = data.get('new_status', '').lower()

    if not journey_id or new_status not in ['public', 'private']:
        return jsonify({"error": "Invalid request parameters"}), 400

    with get_db_cursor() as cursor:
        # First check if the user owns this journey
        cursor.execute("""
            SELECT user_id 
            FROM journeys 
            WHERE journey_id = %s
        """, (journey_id,))
        
        journey = cursor.fetchone()
        
        if not journey or journey['user_id'] != session['user_id']:
            return jsonify({"error": "You don't have permission to modify this journey"}), 403

        try:
            cursor.execute("""
                UPDATE journeys 
                SET status = %s 
                WHERE journey_id = %s AND user_id = %s
            """, (new_status, journey_id, session['user_id']))
            
            return jsonify({"message": "Journey status updated successfully"}), 200
        except Exception as e:
            return jsonify({"error": str(e)}), 500
