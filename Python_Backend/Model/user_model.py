from sqlalchemy import Column, Integer, String, ForeignKey, Float
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

class USERS(Base):
    __tablename__ = 'USERS'

    ID = Column(Integer, primary_key=True, autoincrement=True)
    FULL_NAME = Column(String(50), nullable=False)
    EMAIL_ADDRESS = Column(String(50), nullable=False)
    PASSWORD = Column(String(50), nullable=False)
    