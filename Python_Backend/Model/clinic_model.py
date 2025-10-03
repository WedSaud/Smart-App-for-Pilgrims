from sqlalchemy import Column, Integer, String, ForeignKey, Float
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

class CLINIC(Base):
    __tablename__ = 'CLINIC'

    ID = Column(Integer, primary_key=True, autoincrement=True)
    C_NAME = Column(String(50), nullable=False)
    CONTACT = Column(String(50), nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    