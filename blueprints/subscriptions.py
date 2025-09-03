from flask import Blueprint, render_template,request, redirect, url_for, flash, jsonify, session,make_response
from datetime import datetime,timedelta
from db import getCursor,get_db_cursor, get_db_connection, bcrypt
import os
from werkzeug.utils import secure_filename
import time
from xhtml2pdf import pisa
import io
from io import BytesIO


subscriptions_bp = Blueprint('subscriptions', __name__)  

#biling address check
def set_gst_included(biling_address):
    # Check if the address contains NZ or New Zealand (case insensitive)
    if 'nz' in biling_address.lower() or 'new zealand' in biling_address.lower():
        return 'Yes-15%'
    else:
        return 'No'
#All subscription records
@subscriptions_bp.route('/subscription',methods=["POST","GET"])
def subscription ():
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    user_id = session.get('user_id')
    with get_db_cursor() as cursor:
        cursor.execute(""" SELECT s.*,p.* 
                       FROM wanderlog.subscriptions as s
                        join subscription_plans as p on s.plan_id=p.plan_id
                       WHERE s.user_id = %s
                       """, (user_id,))
        user_subscription = cursor.fetchall() or []
        
    return render_template ('user_subscription.html', user_subscription=user_subscription,
                      user_id =user_id)

# generate receipt
@subscriptions_bp.route ('/generate_receipt/<int:subscription_id>')
def generate_receipt (subscription_id):
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    user_id = session.get ('user_id')
    with get_db_cursor() as cursor:
        cursor.execute("""SELECT s.*,
                        p.type, p.price_ex_gst, p.price_inc_gst, p.discount_percent,p.is_trial, 
                        u.first_name, u.last_name 
                        FROM subscriptions as s
                        join subscription_plans as p on p.plan_id =s. plan_id
                        join users as u on u.user_id =s.user_id
                        WHERE s.subscription_id =%s
                        ;""",(subscription_id,))
        subscription_record =cursor.fetchone()
        if not subscription_record:
            return "Subscription not found",404
        html=render_template('invoice_template.html', subscription_record=subscription_record)
        # create PDF using xhtml2pdf
        result = io.BytesIO()
        pisa_status = pisa.CreatePDF(html, dest=result, encoding='UTF-8', landscape=True)
          # Send the PDF as a response
        if pisa_status.err:
            return "Error generating PDF", 500
        #allow PDF to be downloaded
        response = make_response(result.getvalue())
        response.headers['Content-Type'] = 'application/pdf'
        response.headers['Content-Disposition'] = f'attachment; filename=receipt_{subscription_id}.pdf'
        return response