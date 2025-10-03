import database as db
from Model import doctor_model
from flask import jsonify


def AddDoctor(name,contact,speciality):
    try:
        session = db.return_session()
        user = doctor_model.DOCTOR( DR_NAME=name, CONTACT=contact, SPECIALITY=speciality)
      
           
        session.add(user)
        session.commit()
        
    except Exception as e:
        print(e)
def GetAllDoctor():
    try:
        session = db.return_session()
        doctors = session.query(doctor_model.DOCTOR).all()  # Fetch all doctors
        
        if doctors:
            doctor_list = [
                {
                    "id": doctor.ID,  
                    "name": doctor.DR_NAME,  
                    "contact": doctor.CONTACT,  
                    "speciality": doctor.SPECIALITY
                } 
                for doctor in doctors
            ]
            return jsonify({"message": "Doctors fetched successfully", "doctors": doctor_list}), 200
        else:
            return jsonify({"message": "No doctors found"}), 404  
        
    except Exception as e:
        print(e)
        return jsonify({"message": "Internal server error"}), 500