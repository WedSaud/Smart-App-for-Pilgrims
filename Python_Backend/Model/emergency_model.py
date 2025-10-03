from sqlalchemy import Column, Integer, String, ForeignKey, Float
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

class EMERGENCY(Base):
    __tablename__ = 'EMERGENCY'

    ID = Column(Integer, primary_key=True, autoincrement=True)
    COM_NAME = Column(String(50), nullable=False)
    CONTACT = Column(String(50), nullable=False)
   
    