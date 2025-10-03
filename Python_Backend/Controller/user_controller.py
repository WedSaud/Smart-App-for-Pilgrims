import database as db
from Model import user_model
from flask import jsonify


def Signup(fullname,email,password):
    try:
        session = db.return_session()
        user = user_model.USERS( FULL_NAME=fullname, EMAIL_ADDRESS=email, PASSWORD=password)
      
           
        session.add(user)
        session.commit()
        
    except Exception as e:
        print(e)

def Login(email, password):
    try:
        session = db.return_session()

        # Fetch user from the database
        user = session.query(user_model.USERS).filter_by(EMAIL_ADDRESS=email, PASSWORD=password).first()

        if user:
            print('User login successfully')
            return 200  # Status code for success
        else:
            print("Invalid email or password")
            return 500  # Status code for failure

    except Exception as e:
        print(f"Error: {e}")
        return 500 
