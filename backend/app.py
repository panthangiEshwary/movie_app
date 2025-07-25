from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
from datetime import datetime

app = Flask(__name__)
CORS(app)

DB_NAME = "bookings.db"

# Create DB and table
def init_db():
    with sqlite3.connect(DB_NAME) as conn:
        conn.execute('''
            CREATE TABLE IF NOT EXISTS bookings (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                movie TEXT,
                date TEXT,
                time TEXT,
                seats INTEGER,
                booked_at TEXT
            )
        ''')
        conn.commit()

@app.route("/")
def home():
    return "Movie Ticket Booking Backend is running!"

@app.route("/book", methods=["POST"])
def book_ticket():
    data = request.get_json()

    movie = data.get("movie")
    date = data.get("date")
    time = data.get("time")
    seats = data.get("seats")

    if not all([movie, date, time, seats]):
        return jsonify({"error": "Missing fields"}), 400

    booked_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    with sqlite3.connect(DB_NAME) as conn:
        conn.execute(
            "INSERT INTO bookings (movie, date, time, seats, booked_at) VALUES (?, ?, ?, ?, ?)",
            (movie, date, time, seats, booked_at)
        )
        conn.commit()

    return jsonify({"message": "Booking successful!"})

@app.route("/tickets", methods=["GET"])
def get_tickets():
    with sqlite3.connect(DB_NAME) as conn:
        cursor = conn.execute("SELECT * FROM bookings")
        rows = [
            {
                "id": row[0],
                "movie": row[1],
                "date": row[2],
                "time": row[3],
                "seats": row[4],
                "booked_at": row[5]
            }
            for row in cursor.fetchall()
        ]
    return jsonify(rows)

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000)
