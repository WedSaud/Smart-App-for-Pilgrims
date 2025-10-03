from flask import Flask, request, jsonify,send_from_directory,abort
from Controller import user_controller,doctor_controller,hospital_controller,emergency_controller,clinic_controller
import smtplib
import random
import string
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os
from ultralytics import YOLO
import io
from PIL import Image
import numpy as np
app = Flask(__name__)

model = YOLO('yolov8s.pt')  # This is the model for AR guidance 


# Step 1: Signup
@app.route('/SignupPerson', methods=['POST'])
def SignupPerson(): #get information from  frontend
    fullname = request.form.get('FULL_NAME')
    email = request.form.get('EMAIL_ADDRESS')
    password = request.form.get('PASSWORD')

    
    try:
        response = user_controller.Signup(fullname, email, password)
    except Exception as e:
        return jsonify({"success": False, "message": f"Failed to register user: {str(e)}"}), 500

    return jsonify({"success": True, "message": "User registered successfully"}), 200

SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587
SENDER_EMAIL = "0000" 
SENDER_PASSWORD = "0000"
def generate_otp(length=6):
    otp = ''.join(random.choices(string.digits, k=length))
    return otp

# Function to send OTP via email
def send_otp_email(to_email, otp):
    try:
        # Create message
        message = MIMEMultipart()
        message["From"] = SENDER_EMAIL
        message["To"] = to_email
        message["Subject"] = otp
        
        # Body of the email
        body = f"Your OTP code is: {otp}"
        message.attach(MIMEText(body, "plain"))

        # Connect to the SMTP server this is when the code try to enter the sender email
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()  # Secure the connection
        server.login(SENDER_EMAIL, SENDER_PASSWORD)
        server.sendmail(SENDER_EMAIL, to_email, message.as_string())
        server.quit()

        return True
    except Exception as e:
        print(f"Failed to send OTP: {str(e)}")
        return False
@app.route('/send_otp', methods=['POST'])
def send_otp():
  
    email = request.form.get('email')
    
    if not email:
        return jsonify({"error": "Email is required"}), 400
    
    # Generate OTP
    otp = generate_otp()

    # Send OTP email
    if send_otp_email(email, otp):
        return jsonify({"message": f"OTP sent to {email}", "otp": otp}), 200
    else:
        return jsonify({"error": "Failed to send OTP"}), 500  
    
# login code 

@app.route('/LoginPerson', methods=['GET'])
def LoginPerson():
    email = request.form.get('EMAIL_ADDRESS')
    password = request.form.get('PASSWORD')

    try:
        status_code = user_controller.Login(email, password)  # Call the Login function

        if status_code == 200:  # Login success
            return jsonify({"success": True, "message": "User login successfully"}), 200
        else:  # Login failure
            return jsonify({"success": False, "message": "Invalid email or password"}), 500

    except Exception as e:
        return jsonify({"success": False, "message": f"An error occurred: {str(e)}"}), 500


@app.route('/AddDoctor', methods=['POST'])
def AddDoctor():
   
    name = request.form.get('DR_NAME')
    contact = request.form.get('CONTACT')
    speciality = request.form.get('SPECIALITY')
    
    try:
        response = hospital_controller.AddHospital( name,contact,speciality)
    except Exception as e:
        return jsonify({"success": False, "message": f"Failed to ADD DOCTOR: {str(e)}"}), 500

    return jsonify({"success": True, "message": "DOCTOR ADD successfully"}), 200

@app.route('/GetAllDoctors', methods=['GET'])
def GetAllDoctors():
    try:
        response = doctor_controller.GetAllDoctor()
    except Exception as e:
        return jsonify({"success": False, "message": f"Failed to get doctors: {str(e)}"}), 500

    return response

@app.route('/AddHospital', methods=['POST'])
def AddHospital():
   
    name = request.form.get('HOS_NAME')
    contact = request.form.get('CONTACT')
    
    
    try:
        response = hospital_controller.AddHospital(name,contact)
    except Exception as e:
        return jsonify({"success": False, "message": f"Failed to ADD HOSPITAL: {str(e)}"}), 500

    return jsonify({"success": True, "message": "HOSPITAL ADD successfully"}), 200


@app.route('/GetAllHospitals', methods=['GET'])
def GetAllHospitals():
    try:
        response = hospital_controller.GetAllHospital()
    except Exception as e:
        return jsonify({"success": False, "message": f"Failed to get hospital: {str(e)}"}), 500

    return response
from Controller.hospital_controller import hospital_routes
app.register_blueprint(hospital_routes)


@app.route('/AddEmergency', methods=['POST'])
def AddEmergency():
   
    name = request.form.get('COM_NAME')
    contact = request.form.get('CONTACT')
    
    
    try:
        response = emergency_controller.AddEmergency(name,contact)
    except Exception as e:
        return jsonify({"success": False, "message": f"Failed to ADD Emergency: {str(e)}"}), 500

    return jsonify({"success": True, "message": "Emergency ADD successfully"}), 200


@app.route('/GetAllEmergency', methods=['GET'])
def GetAllEmergency():
    try:
        response = emergency_controller.GetAllEmergencyContact()
    except Exception as e:
        return jsonify({"success": False, "message": f"Failed to get Emergency: {str(e)}"}), 500

    return response

@app.route('/GetAllClinic', methods=['GET'])
def GetAllClinic():
    try:
        response = clinic_controller.GetAllClinic()
    except Exception as e:
        return jsonify({"success": False, "message": f"Failed to get Clinic: {str(e)}"}), 500

    return response
from Controller.clinic_controller import clinic_routes
app.register_blueprint(clinic_routes)

# for agumented reality
@app.route('/detect_humans', methods=['POST'])
def detect_humans():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    file = request.files['image']
    image = Image.open(io.BytesIO(file.read())).convert('RGB')  # Always convert to RGB
    img_array = np.array(image)

    # Run detection - class 0 = person
    results = model(img_array)
    boxes = results.xyxy[0]  # xyxy bounding boxes
    num_persons = sum(1 for box in boxes if int(box[-1]) == 0)  # Class 0 is person

    print(f"Number of humans detected: {num_persons}")

    if num_persons > 9:
        traffic = 'heavy'
        instruction = "Heavy Traffic: Move Back"
    elif 4 <= num_persons <= 9:
        traffic = 'medium'
        instruction = "Medium Traffic: Turn Left or Right"
    else:
        traffic = 'low'
        instruction = "Low Traffic: Move Forward"

    return jsonify({
        'traffic': traffic,
        'instruction': instruction,
        'num_humans': num_persons
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

# def get_traffic_condition():
#     return random.choice(['high', 'low'])

# Endpoint for traffic conditions
@app.route('/traffic', methods=['GET'])
def traffic_conditions():
    condition = get_traffic_condition()
    return jsonify({'traffic': condition})

# Endpoint for AR image data (virtual objects)
IMAGES_FOLDER = os.path.join(app.root_path, 'images')

@app.route('/ar-object', methods=['GET'])
def ar_object():
    # Provide 2D image URLs for Kaaba and Haram
    image_url = '/images/kaaba.png'  # Local image URL
    ar_data = {
        'object_name': 'Kaaba',
        'image_url': image_url,  # Image URL that can be used in the app
        'position': {'x': 0, 'y': 0, 'z': -1},  # Example position for the image overlay
    }
    return jsonify(ar_data)

@app.route('/images/<image_name>')
def serve_image(image_name):
    try:
        # Construct the full path for the requested image
        return send_from_directory(IMAGES_FOLDER, image_name)
    except FileNotFoundError:
        # If image is not found, return a 404 error
        abort(404, description="Image not found")


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
