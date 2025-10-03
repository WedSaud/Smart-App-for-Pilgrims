import database as db
from Model import emergency_model
from flask import jsonify


def AddEmergency(name,contact):
    try:
        session = db.return_session()
        emg = emergency_model.EMERGENCY(COM_NAME=name, CONTACT=contact)
      
           
        session.add(emg)
        session.commit()
        
    except Exception as e:
        print(e)
def GetAllEmergencyContact():
    try:
        session = db.return_session()
        emgs = session.query(emergency_model.EMERGENCY).all()  # Fetch all hospital
        
        if emgs:
            emergency_list = [
                {
                    "id": e.ID,  
                    "name": e.COM_NAME,  
                    "contact": e.CONTACT 
                    
                } 
                for e in emgs
            ]
            return jsonify({"message": "Emergency fetched successfully", "emergency":emergency_list}), 200
        else:
            return jsonify({"message": "No emergency found"}), 404  
        
    except Exception as e:
        print(e)
        return jsonify({"message": "Internal server error"}), 500