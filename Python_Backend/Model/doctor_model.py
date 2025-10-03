from sqlalchemy import Column, Integer, String, ForeignKey, Float
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

class DOCTOR(Base):
    __tablename__ = 'DOCTOR'

    ID = Column(Integer, primary_key=True, autoincrement=True)
    DR_NAME = Column(String(50), nullable=False)
    CONTACT = Column(String(50), nullable=False)
    SPECIALITY = Column(String(50), nullable=False)
    