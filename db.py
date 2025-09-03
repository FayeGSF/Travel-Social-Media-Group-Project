import mysql.connector
import mysql.connector.pooling
import connect
from flask_bcrypt import Bcrypt
from contextlib import contextmanager
import os

bcrypt = Bcrypt()

# Setting up the Database Connection
connection_pool = mysql.connector.pooling.MySQLConnectionPool(
    pool_name="Wanderlog",
    pool_size=3,
    pool_reset_session=True,
    user=connect.dbuser,
    password=connect.dbpass,
    host=connect.dbhost,
    database=connect.dbname,
    autocommit=True
)

@contextmanager
def get_db_connection():
    """Context manager for database connections"""
    connection = None
    try:
        connection = connection_pool.get_connection()
        yield connection
    finally:
        if connection:
            connection.close()

@contextmanager
def get_db_cursor():
    """Context manager for database cursors"""
    with get_db_connection() as connection:
        cursor = None
        try:
            cursor = connection.cursor(dictionary=True)
            yield cursor
        finally:
            if cursor:
                cursor.close()

# Defining the Cursor Function - Legacy support
def getCursor():
    """
    Legacy function for backward compatibility.
    Note: This should be replaced with get_db_cursor() in new code.
    """
    try:
        connection = connection_pool.get_connection()
        cursor = connection.cursor(dictionary=True)
        return connection, cursor
    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        if connection_pool.pool_size > 0:
            connection_pool._remove_connections()
            try:
                connection = connection_pool.get_connection()
                cursor = connection.cursor(dictionary=True)
                return connection, cursor
            except:
                if connection:
                    connection.close()
                raise
        raise  # Re-raise the error if we can't recover

