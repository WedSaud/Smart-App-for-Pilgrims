import database as db
from Model import clinic_model
from flask import request, jsonify
from utils.Distance_helper import calculate_distance
from flask import Blueprint
clinic_routes = Blueprint('clinic_routes', __name__)

# def GetAllClinic():
#     try:
#         session = db.return_session()
#         clinics = session.query(clinic_model.CLINIC).all()  # Fetch all clinics
        
#         if clinics:
#             clinic_list = [
#                 {
#                     "id": clinic.ID,  
#                     "name": clinic.C_NAME,  
#                     "contact": clinic.CONTACT
                   
#                 } 
#                 for clinic in clinics
#             ]
#             return jsonify({"message": "clinics fetched successfully", "clinics": clinic_list}), 200
#         else:
#             return jsonify({"message": "No clinics found"}), 404  
        
#     except Exception as e:
#         print(e)
#         return jsonify({"message": "Internal server error"}), 500
@clinic_routes.route('/nearest_clinics', methods=['POST'])
def GetNearestClinics():
    try:
        data = request.get_json()
        user_lat = float(data['latitude'])
        user_lon = float(data['longitude'])

        session = db.return_session()
        clinics = session.query(clinic_model.CLINIC).all()

        if not clinics:
            return jsonify({"message": "No clinics found"}), 404

        clinic_list = []
        for clinic in clinics:
            distance = calculate_distance(user_lat, user_lon, clinic.latitude, clinic.longitude)
            clinic_list.append({
                "id": clinic.ID,
                "name": clinic.C_NAME,
                "contact": clinic.CONTACT,
                "latitude": clinic.latitude,
                "longitude": clinic.longitude,
                "distance": distance
            })

        clinic_list.sort(key=lambda x: x['distance'])
        return jsonify(clinic_list), 200

    except Exception as e:
        print(e)
        return jsonify({"message": "Internal server error"}), 500


clinic_routes.route('/nearest_clinics', methods=['POST'])(GetNearestClinics)
