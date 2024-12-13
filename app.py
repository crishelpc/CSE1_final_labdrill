from flask import Flask, jsonify, request, make_response
from flask_mysqldb import MySQL
from flask_bcrypt import Bcrypt
from http import HTTPStatus
import jwt, json, datetime
import re

app = Flask(__name__)
bcrypt = Bcrypt(app)

app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = "root"
app.config["MYSQL_DB"] = "hospice_patient_care"
app.config["SECRET_KEY"] = "crishel"

mysql = MySQL(app)

# token validation
def validate_token():
    token = request.headers.get("x-access-token")

    if not token:
        return None, handle_error("Token is missing!", 401)

    try:
        data = jwt.decode(token, app.config["SECRET_KEY"], algorithms=["HS256"])
        current_user = {"user_id": data["user_id"], "role": data["role"]}
        return current_user, None
    except Exception:
        return None, handle_error("Token is invalid!", 401)

# role validation
def validate_role(current_user, valid_roles):
    if isinstance(valid_roles, str):
        valid_roles = [valid_roles]
    
    if current_user["role"] not in valid_roles:
        return jsonify({"error": "Unauthorized access"}), 403
    return None

# users.json
users_data = {
    "users": []
}

def save_to_json():
    with open("users.json", "w") as f:
        json.dump(users_data, f)

def load_from_json():
    global users_data
    try:
        with open("users.json", "r") as f:
            users_data = json.load(f)
    except FileNotFoundError:
        save_to_json() 

# user registration
@app.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    if not data or not data.get("username") or not data.get("password") or not data.get("role"):
        return handle_error("Missing required fields: username, password, and role are mandatory", 400)

    username = data["username"]
    password = bcrypt.generate_password_hash(data["password"]).decode("utf-8")
    role = data["role"]

    load_from_json()

    for user in users_data["users"]:
        if user["username"] == username:
            return handle_error("Username already exists", 400)

    new_user = {"username": username, "password": password, "role": role}
    users_data["users"].append(new_user)
    save_to_json()

    return jsonify({"message": "User registered successfully"}), 201

# user login
@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    if not data or not data.get("username") or not data.get("password"):
        return handle_error("Missing required fields: username and password are mandatory", 400)

    username = data["username"]
    password = data["password"]

    load_from_json()

    for user in users_data["users"]:
        if user["username"] == username and bcrypt.check_password_hash(user["password"], password):
            token = jwt.encode(
                {
                    "user_id": username,
                    "role": user["role"],
                    "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1),
                },
                app.config["SECRET_KEY"],
                algorithm="HS256",
            )
            return jsonify({"token": token}), 200

    return handle_error("Invalid credentials", 401)


@app.route("/")
def index_page():
    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hospice Patient Care API</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100">
        <div class="container mx-auto px-4 py-8">
            <!-- Outer Container -->
            <div class="bg-white shadow-md rounded-lg p-8">
               <h1 class="text-3xl font-bold text-green-600 text-center mb-4">
                    WELCOME TO HOSPICE PATIENT CARE
                </h1>

                <p class="text-gray-700 text-center text-lg mb-6">
                    This is the main page of the Hospice Patient Care Database API.
                </p>
                <p class="text-gray-800 text-center text-md mb-6">
                    Below is the list of available <span class="font-bold">GET</span> methods:
                </p>

                <!-- Grid Container with 2 columns and 2 rows -->
                <div class="grid grid-cols-2 gap-4">
                    <!-- GET Method Card -->
                    <div class="bg-gray-50 border border-gray-200 rounded-lg px-4 py-2 shadow-sm text-center">
                        <h2 class="text-green-600 font-semibold">
                            <a href="/patients" class="hover:underline">
                                /patients
                            </a>
                        </h2>
                        <p class="text-gray-700 text-sm">
                            Get all patients in the system.
                        </p>
                    </div>

                    <!-- GET Method Card -->
                    <div class="bg-gray-50 border border-gray-200 rounded-lg px-4 py-2 shadow-sm text-center">
                        <h2 class="text-green-600 font-semibold">
                            <a href="/patientadmissions/1" class="hover:underline">
                                /patientadmissions/&lt;int:patient_id&gt;
                            </a>
                        </h2>
                        <p class="text-gray-700 text-sm">
                            Get admission details of a specific patient.
                        </p>
                    </div>

                    <!-- GET Method Card -->
                    <div class="bg-gray-50 border border-gray-200 rounded-lg px-4 py-2 shadow-sm text-center">
                        <h2 class="text-green-600 font-semibold">
                            <a href="/healthprofessionals/1/patients" class="hover:underline">
                                /healthprofessionals/&lt;int:staff_id&gt;/patients
                            </a>
                        </h2>
                        <p class="text-gray-700 text-sm">
                            Get all patients assigned to a specific health professional.
                        </p>
                    </div>

                    <!-- GET Method Card -->
                    <div class="bg-gray-50 border border-gray-200 rounded-lg px-4 py-2 shadow-sm text-center">
                        <h2 class="text-green-600 font-semibold">
                            <a href="/treatments/1" class="hover:underline">
                                /treatments/&lt;int:patient_id&gt;
                            </a>
                        </h2>
                        <p class="text-gray-700 text-sm">
                            Get treatment history of a specific patient.
                        </p>
                    </div>
                </div>

                <p class="text-gray-500 text-sm mt-6 text-center">
                    Powered by Flask
                </p>
            </div>
        </div>
    </body>
</html>
"""

def validate_patient_input(data):
    required_fields = ['patientFirstName', 'patientLastName', 'patientHomePhone', 'patientEmailAddress']
    for field in required_fields:
        if field not in data or not data[field]:
            return f"'{field}' is required", HTTPStatus.BAD_REQUEST
    return None, None

def validate_admission_input(data):
    required_fields = ['patientID', 'dateOfAdmission', 'dateOfDischarge']
    for field in required_fields:
        if field not in data or not data[field]:
            return f"'{field}' is required", HTTPStatus.BAD_REQUEST
    try:
        datetime.datetime.strptime(data["dateOfAdmission"], "%Y-%m-%d")
        datetime.datetime.strptime(data["dateOfDischarge"], "%Y-%m-%d")
    except ValueError:
        return "'dateOfAdmission' and 'dateOfDischarge' must be in 'YYYY-MM-DD' format", HTTPStatus.BAD_REQUEST
    return None, None

def validate_treatment_input(data):
    required_fields = ['staffID', 'patientID', 'treatmentDescription', 'treatmentStatus']
    for field in required_fields:
        if field not in data or not data[field]:
            return f"'{field}' is required", HTTPStatus.BAD_REQUEST
    return None, None

def data_fetch(query, params=None):
    cur = mysql.connection.cursor()
    cur.execute(query, params)
    result = cur.fetchall()
    cur.close()
    return result

@app.route("/Patients", methods=["GET"])
def get_patients():
    data = data_fetch("""SELECT * FROM Patients""")
    return jsonify(data), HTTPStatus.OK

@app.route("/PatientAdmissions/<int:patient_id>", methods=["GET"])
def get_patient_admission(patient_id):
    data = data_fetch("""SELECT * FROM PatientAdmissions WHERE patientID = %s""", (patient_id,))
    if not data:
        return jsonify(
            {
                "error": "Admission not found for the given patient"
            }), HTTPStatus.NOT_FOUND
    
    return jsonify(data), HTTPStatus.OK

@app.route("/HealthProfessionals/<int:staff_id>/patients", methods=["GET"])
def get_patients_info(staff_id):
    data = data_fetch("""
        SELECT DISTINCT Patients.patientID, Patients.patientFirstName, Patients.patientLastName, 
                        Patients.patientHomePhone, Patients.patientEmailAddress
        FROM Treatments
        JOIN Patients ON Treatments.patientID = Patients.patientID
        WHERE Treatments.staffID = %s
    """, (staff_id,))

    if not data:
        return jsonify(
            {
                "error": "No patients found for this health professional"
            }
        ), HTTPStatus.NOT_FOUND

    return jsonify(data), HTTPStatus.OK

@app.route("/Treatments/<int:patient_id>", methods=["GET"])
def get_treatment_history(patient_id):
    data = data_fetch("""SELECT treatmentID, treatmentDescription, treatmentStatus
        FROM Treatments WHERE patientID = %s""", (patient_id,))
    return jsonify(data), HTTPStatus.OK

@app.route("/Patients", methods=["POST"])
def add_patient():
    data = request.get_json()
    error_message, status_code = validate_patient_input(data)
    if error_message:
        return jsonify({"error": error_message}), status_code

    try:
        cursor = mysql.connection.cursor()
        cursor.execute(
            "INSERT INTO Patients (patientFirstName, patientLastName, patientHomePhone, patientEmailAddress) VALUES (%s, %s, %s, %s)",
            (data['patientFirstName'], data['patientLastName'], data['patientHomePhone'], data['patientEmailAddress'])
        )
        mysql.connection.commit()
        cursor.close()
        return jsonify(
            {
                "message": "Patient added successfully"
            }
        ), HTTPStatus.CREATED
    
    except Exception as e:
        return jsonify(
            {
                "error": str(e)
            }
        ), HTTPStatus.BAD_REQUEST

@app.route("/PatientAdmissions", methods=["POST"])
def add_admission():
    current_user, error = validate_token()
    if error:
        return error
    
    role_error = validate_role(current_user, ['staff', 'admin'])
    if role_error:
        return role_error
    
    info = request.get_json()
    error_message, status_code = validate_admission_input(info)
    if error_message:
        return jsonify(
            {
                "error": error_message
            }
        ), status_code

    try:
        cur = mysql.connection.cursor()
        cur.execute(
            """INSERT INTO PatientAdmissions (patientID, dateOfAdmission, dateOfDischarge)
            VALUES (%s, %s, %s)""",
            (info["patientID"], info["dateOfAdmission"], info["dateOfDischarge"])
        )
        mysql.connection.commit()
        rows_affected = cur.rowcount
        cur.close()
        return jsonify(
            {
                "message": "Admission added successfully", "rows_affected": rows_affected
            }
        ), HTTPStatus.CREATED
    
    except Exception as e:
        return jsonify(
            {"error": str(e)
            }
        ), HTTPStatus.BAD_REQUEST

@app.route("/Treatments", methods=["POST"])
def add_treatment():
    current_user, error = validate_token()
    if error:
        return error
    
    role_error = validate_role(current_user, ['staff', 'admin'])
    if role_error:
        return role_error
    
    info = request.get_json()
    error_message, status_code = validate_treatment_input(info)
    if error_message:
        return jsonify(
            {
                "error": error_message
            }
        ), status_code

    try:
        cur = mysql.connection.cursor()
        cur.execute(
            """INSERT INTO Treatments (staffID, patientID, treatmentDescription, treatmentStatus)
            VALUES (%s, %s, %s, %s)""",
            (info['staffID'], info["patientID"], info["treatmentDescription"], info["treatmentStatus"])
        )
        mysql.connection.commit()
        rows_affected = cur.rowcount
        cur.close()
        return jsonify(
            {
                "message": "Treatment of patient added successfully", "rows_affected": rows_affected
            }
        ), HTTPStatus.CREATED
    
    except Exception as e:
        return jsonify(
            {
                "error": str(e)
            }
        ), HTTPStatus.BAD_REQUEST

@app.route("/Treatments/<int:treatment_id>", methods=["PUT"])
def update_treatment(treatment_id):
    current_user, error = validate_token()
    if error:
        return error
    
    role_error = validate_role(current_user, ['staff', 'admin'])
    if role_error:
        return role_error
    info = request.get_json()
    treatmentStatus = info.get("treatmentStatus")
    if not treatmentStatus:
        return jsonify(
            {
                "error": "'treatmentStatus' is required"
            }
            ), HTTPStatus.BAD_REQUEST

    try:
        cur = mysql.connection.cursor()
        cur.execute(
            """UPDATE Treatments SET treatmentStatus = %s WHERE treatmentID = %s""",
            (treatmentStatus, treatment_id),
        )
        mysql.connection.commit()
        rows_affected = cur.rowcount
        cur.close()
        return jsonify(
            {
                "message": "Patient treatment status updated successfully", "rows_affected": rows_affected
            }
        ), HTTPStatus.OK
    
    except Exception as e:
        return jsonify(
            {
                "error": str(e)
            }
        ), HTTPStatus.BAD_REQUEST
    
@app.route('/Patients/<int:patient_id>', methods=['DELETE'])
def delete_patient(patient_id):
    current_user, error = validate_token()
    if error:
        return error
    
    role_error = validate_role(current_user, ['staff', 'admin'])
    if role_error:
        return role_error
    try:
        cur = mysql.connection.cursor()
        cur.execute("""DELETE FROM Patients WHERE patientID = %s""", (patient_id,))
        mysql.connection.commit()
        rows_affected = cur.rowcount
        cur.close()
        return jsonify(
            {
                "message": "Patient record deleted successfully", "rows_affected": rows_affected
            }
        ), HTTPStatus.OK
    
    except Exception as e:
        return jsonify(
            {
                "error": str(e)
            }
        ), HTTPStatus.BAD_REQUEST

@app.route('/Treatments/<int:treatment_id>', methods=['DELETE'])
def delete_treatment(treatment_id):
    current_user, error = validate_token()
    if error:
        return error
    
    role_error = validate_role(current_user, ['staff', 'admin'])
    if role_error:
        return role_error
    
    try:
        cur = mysql.connection.cursor()
        cur.execute("""DELETE FROM Treatments WHERE treatmentID = %s""", (treatment_id,))
        mysql.connection.commit()
        rows_affected = cur.rowcount
        cur.close()
        return jsonify(
            {
                "message": "Treatment record deleted successfully", "rows_affected": rows_affected
            }
        ), HTTPStatus.OK
    
    except Exception as e:
        return jsonify(
            {
                "error": str(e)
            }
        ), HTTPStatus.BAD_REQUEST

def handle_error(error_msg, status_code):
    return jsonify({"error": error_msg}), status_code

if __name__ == "__main__":
    app.run(debug=True)
