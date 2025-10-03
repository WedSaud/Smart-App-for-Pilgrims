import database as db
from Model import hospital_model
from flask import request, jsonify, Blueprint
from utils.Distance_helper import calculate_distance


hospital_routes = Blueprint('hospital_routes', __name__)

@hospital_routes.route('/nearest_hospitals', methods=['POST'])
def GetNearestHospitals():
    try:
        data = request.get_json()
        user_lat = float(data['latitude'])
        user_lon = float(data['longitude'])

        session = db.return_session()
        hospitals = session.query(hospital_model.HOSPITAL).all()

        if not hospitals:
            return jsonify({"message": "No hospitals found"}), 404

        hospital_list = []
        for hospital in hospitals:
            if hospital.latitude is not None and hospital.longitude is not None:
                distance = calculate_distance(user_lat, user_lon, hospital.latitude, hospital.longitude)
                hospital_list.append({
                    "id": hospital.ID,
                    "name": hospital.HOS_NAME,
                    "contact": hospital.CONTACT,
                    "latitude": hospital.latitude,
                    "longitude": hospital.longitude,
                    "distance": distance
                })

        hospital_list.sort(key=lambda x: x['distance'])
        return jsonify(hospital_list), 200

    except Exception as e:
        import traceback
        print("🔥 ERROR in GetNearestHospitals:", e)
        traceback.print_exc()
        return jsonify({"message": "Internal server error"}), 500


# def AddHospital(name,contact):
#     try:
#         session = db.return_session()
#         hospital = hospital_model.HOSPITAL(HOS_NAME=name, CONTACT=contact)
      
           
#         session.add(hospital)
#         session.commit()
        
#     except Exception as e:
#         print(e)
# def GetAllHospital():
#     try:
#         session = db.return_session()
#         hospital = session.query(hospital_model.HOSPITAL).all()  # Fetch all hospital
        
#         if hospital:
#             hospital_list = [
#                 {
#                     "id": hospital.ID,  
#                     "name": hospital.HOS_NAME,  
#                     "contact": hospital.CONTACT 
                    
#                 } 
#                 for hospital in hospital
#             ]
#             return jsonify({"message": "hospital fetched successfully", "hospital": hospital_list}), 200
#         else:
#             return jsonify({"message": "No hospital found"}), 404  
        
#     except Exception as e:
#         print(e)
#         return jsonify({"message": "Internal server error"}), 500