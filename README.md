# CSE1_final_labdrill

# Hospice Patient Care 

## Description
This is a Conceptual Data Model for a Hospice Care System. It helps manage patient information, medical conditions, treatments, staff details to make care easier and more organized.

## Installation
```cmd
pip install -r requirements.txt
```
## Configuration
To set up the database:

1. Create a MySQL database called hospice_patient_care.
2. Update the database details in the Flask app.

Environment variables you need:

MYSQL_HOST: MySQL server (e.g., localhost).
MYSQL_USER: Your MySQL username (e.g., root).
MYSQL_PASSWORD: Your MySQL password.
MYSQL_DB: Database name (e.g., hospice_patient_care).
SECRET_KEY: A secret key for the app (e.g., crishel).

Or set these directly in the code:
```cmd
app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = "root"
app.config["MYSQL_DB"] = "hospice_patient_care"
app.config["SECRET_KEY"] = "crishel"
```

## API Endpoints (markdown table)
| Endpoint                                      | Method   | Description                                                               |
|-----------------------------------------------|----------|---------------------------------------------------------------------------|
| `/`                                           | `GET`    | Returns a welcome message.                                                |
| `/patients`                                   | `GET`    | Retrieves all patients.                                                   |
| `/patients`                                   | `POST`   | Adds a new patient.                                                       |
| `/patientadmissions/<int:patient_id>`         | `GET`    | Retrieves patient admission details for a specific patient ID.            |
| `/patientadmissions`                          | `POST`   | Adds a new admission record for a patient.                                |
| `/healthprofessionals/<int:staff_id>/patients`| `GET`    | Retrieves all patients treated by a specific health professional.         |
| `/treatments/<int:patient_id>`                | `GET`    | Retrieves treatment history for a specific patient.                       |
| `/treatments`                                 | `POST`   | Adds a treatment record for a patient.                                    |
| `/treatments/<int:treatment_id>`              | `PUT`    | Updates the status of a specific treatment.                               |
| `/patients/<int:patient_id>`                  | `DELETE` | Deletes a specific patient record.                                        |
| `/treatments/<int:treatment_id>`              | `DELETE` | Deletes a specific treatment record.                                      |

## Testing
 To test the app, run:
 ```cmd
pytest
```

## Git Commit Guidelines

Use conventional commits:
```bash
feat: add user authentication
fix: resolve database connection issue
docs: update API documentation
test: add user registration tests
