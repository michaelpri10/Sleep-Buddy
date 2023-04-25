from flask import Flask, request, json, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.exc import SQLAlchemyError
import json

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///sleepbuddy.db"
db = SQLAlchemy()
db.init_app(app)

class User(db.Model):
    email = db.Column(db.String, primary_key=True, nullable=False)
    name = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)
    watch_id = db.Column(db.String)
    start_date = db.Column(db.String)

class BaselineSurvey(db.Model):
    email = db.Column(db.String, primary_key=True, nullable=False)
    start_date = db.Column(db.String)
    average_sleep = db.Column(db.Integer)
    sleep_happiness = db.Column(db.Integer)
    sleep_deprived = db.Column(db.Integer)
    tracked_sleep = db.Column(db.Boolean)
    sleep_insights = db.Column(db.Text)
    drinking_days_average = db.Column(db.Integer)
    drugs_days_average = db.Column(db.Integer)
    caffeine_days_average = db.Column(db.Integer)
    exercise_days_average = db.Column(db.Integer)
    device_time_average = db.Column(db.Integer)

class DailySurvey(db.Model):
    email = db.Column(db.String, primary_key=True, nullable=False)
    survey_date = db.Column(db.String, primary_key=True)
    sleep_was_tracked = db.Column(db.Boolean)
    estimated_sleep = db.Column(db.Integer)
    minutes_in_bed_before_sleep = db.Column(db.Integer)
    alcohol_before_sleeping = db.Column(db.Boolean)
    number_of_drinks = db.Column(db.Integer)
    length_of_drinking = db.Column(db.Integer)
    caffeine_before_sleeping = db.Column(db.Boolean)
    caffeine_cups = db.Column(db.Integer)
    caffeine_length = db.Column(db.Integer)
    exercise_yesterday = db.Column(db.Boolean)
    length_of_exercise = db.Column(db.Integer)
    stress_yesterday = db.Column(db.Boolean)
    stress_reasons = db.Column(db.Text)


@app.route("/register", methods=["POST"])
def register():
    if request.method == "POST":
        email = request.form["email"]
        name = request.form["name"]
        password = request.form["password"]

        user = User(name=name, email=email, password=password, watch_id="", start_date="")
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
def get_user():
    email = request.form["email"]
    user = User.query.filter_by(email=email).first()
    if not user:
        return jsonify({
            "error": "User not found",
            "email": "",
            "name": "",
            "watch_id": "",
            "start_date": "",
        })
    return jsonify({
        "error": "",
        "email": user.email,
        "name": user.name,
        "watch_id": "",
        "start_date": user.start_date,
    })

@app.route("/save_baseline", methods=["POST"])
def save_baseline():
    data = json.loads(request.form["data"])
    data["email"] = request.form["email"]

    old_baseline = BaselineSurvey.query.filter_by(email=request.form["email"]).first()
    if old_baseline:
        db.session.delete(old_baseline)
        db.session.commit()

    baseline = BaselineSurvey(**data)
    user = User.query.filter_by(email=request.form["email"]).first()
    try:
        db.session.add(baseline)
        user.start_date = baseline.start_date
        db.session.commit()
    except SQLAlchemyError as e:
        print(e)
        return jsonify(["survey_error"])
    print("HERE")
    return jsonify(["survey_success"])

@app.route("/get_baseline", methods=["POST"])
def get_baseline():
    email = request.form["email"]
    baseline = BaselineSurvey.query.filter_by(email=email).first()
    if not baseline:
        return jsonify({
            "error": "Baseline survey not found",
            "email": "",
            "start_date": "",
            "average_sleep": 0,
            "sleep_happiness": 0,
            "sleep_deprived": 0,
            "tracked_sleep": False,
            "sleep_insights": "",
            "drinking_days_average": 0,
            "drugs_days_average": 0,
            "caffeine_days_average": 0,
            "exercise_days_average": 0,
            "device_time_average": 0,
        })

    return jsonify({
        "error": "",
        "email": baseline.email,
        "start_date": baseline.start_date,
        "average_sleep": baseline.average_sleep,
        "sleep_happiness": baseline.sleep_happiness,
        "sleep_deprived": baseline.sleep_deprived,
        "tracked_sleep": baseline.tracked_sleep,
        "sleep_insights": baseline.sleep_insights,
        "drinking_days_average": baseline.drinking_days_average,
        "drugs_days_average": baseline.drugs_days_average,
        "caffeine_days_average": baseline.caffeine_days_average,
        "exercise_days_average": baseline.exercise_days_average,
        "device_time_average": baseline.device_time_average,
    })

@app.route("/save_daily", methods=["POST"])
def save_daily():
    data = json.loads(request.form["data"])
    data["email"] = request.form["email"]

    old_daily = DailySurvey.query.filter_by(email=request.form["email"], survey_date=data["survey_date"]).first()
    if old_daily:
        db.session.delete(old_daily)
        db.session.commit()

    daily = DailySurvey(**data)
    try:
        db.session.add(daily)
        db.session.commit()
    except SQLAlchemyError as e:
        print(e)
        return jsonify(["survey_error"])
    return jsonify(["survey_success"])

@app.route("/get_daily", methods=["POST"])
def get_daily():
    email = request.form["email"]
    date = request.form["date"]
    print(date)
    print(email)
    dailies = DailySurvey.query.all()
    print("HERE")
    print(dailies)
    print(date)
    daily = DailySurvey.query.filter_by(email=email, survey_date=date).first()
    if not daily:
        return jsonify({
            "error": "Daily survey not found",
            "email": "",
            "survey_date": "",
            "sleep_was_tracked": False,
            "estimated_sleep": -1,
            "minutes_in_bed_before_sleep": -1,
            "alcohol_before_sleeping": False,
            "number_of_drinks": -1,
            "length_of_drinking": -1,
            "caffeine_before_sleeping": False,
            "caffeine_cups": -1,
            "caffeine_length": -1,
            "exercise_yesterday": False,
            "length_of_exercise": -1,
            "stress_yesterday": False,
            "stress_reasons": "",
        })

    return jsonify({
        "error": "",
        "email": daily.email,
        "survey_date": daily.survey_date,
        "sleep_was_tracked": daily.sleep_was_tracked,
        "estimated_sleep": daily.estimated_sleep,
        "minutes_in_bed_before_sleep": daily.minutes_in_bed_before_sleep,
        "alcohol_before_sleeping": daily.alcohol_before_sleeping,
        "number_of_drinks": daily.number_of_drinks,
        "length_of_drinking": daily.length_of_drinking,
        "caffeine_before_sleeping": daily.caffeine_before_sleeping,
        "caffeine_cups": daily.caffeine_cups,
        "caffeine_length": daily.caffeine_length,
        "exercise_yesterday": daily.exercise_yesterday,
        "length_of_exercise": daily.length_of_exercise,
        "stress_yesterday": daily.stress_yesterday,
        "stress_reasons": daily.stress_reasons,
    })

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(debug=True)