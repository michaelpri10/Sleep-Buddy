from flask import Flask, request, json, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.exc import SQLAlchemyError

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///sleepbuddy.db"
db = SQLAlchemy()
db.init_app(app)

from models import User

@app.route("/register", methods=["POST"])
def register():
    if request.method == "POST":
        username = request.form["username"]
        email = request.form["email"]
        password = request.form["password"]

        # TODO: Verify username uniquness, email format, and password

        user = User(username, email, password)
        try:
            db.session.add(user)
            db.session.commit()
        except SQLAlchemyError as e:
            print(f"Error registering: {e}")