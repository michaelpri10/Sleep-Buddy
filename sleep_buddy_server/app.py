from flask import Flask, request, json, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.exc import SQLAlchemyError

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///sleepbuddy.db"
db = SQLAlchemy()
db.init_app(app)

class User(db.Model):
    email = db.Column(db.String, primary_key=True, nullable=False)
    name = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)

@app.route("/register", methods=["POST"])
def register():
    if request.method == "POST":
        email = request.form["email"]
        name = request.form["name"]
        password = request.form["password"]

        # TODO: Verify email format and uniqueness, and password

        user = User(name=name, email=email, password=password)
        try:
            db.session.add(user)
            db.session.commit()
        except SQLAlchemyError as e:
            return jsonify(["register_error"])
        return jsonify(["register_success"])

@app.route("/login", methods=["POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]

        user = User.query.filter_by(email=email).first()
        print(user)
        if not user or user.password != password:
            return jsonify(["login_error"])
        return jsonify(["login_success"])
    
@app.route("/get_user", methods=["POST"])
def getUser():
    email = request.form["email"]
    user = User.query.filter_by(email=email).first()
    if not user:
        return jsonify({
            "error": "User not found",
            "email": "",
            "name": "",
        })
    return jsonify({
        "error": "",
        "email": user.email,
        "name": user.name,
    })


if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(debug=True)