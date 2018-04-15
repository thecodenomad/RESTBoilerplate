#!/bin/bash

PROJECT_NAME=`basename "$PWD"`

# Establish base directories
mkdir -p ./{templates,static,views,scripts}

##############################
# Make sure shit's installed #
##############################
pip install flask sqlalchemy flask-sqlalchemy flask-restful flask-migrate flask_script

############################
# Create boilerplate files #
############################

# Base
touch __init__.py

# Application scripts
touch scripts/manage.py
touch scripts/__init__.py

# Establish base settings
cat << EOF > settings.py
SQLALCHEMY_DATABASE_URI = 'sqlite:///flask_app.db'
SQLALCHEMY_TRACK_MODIFICATIONS = False
EOF

# Create a simple model
cat << EOF > models.py
from app import db

# Example - Remove according to project
class Car(db.Model):
    __tablename__ = 'car'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    color = db.Column(db.String(100))
EOF

# Views
cat << EOF > views/__init__.py
from app import app

@app.route('/')
@app.route('/index')
def index():
    return "Hello, World!"
EOF

# Setup Main App
cat << EOF > ./app.py
from flask import Flask
from flask_restful import Api
from settings import SQLALCHEMY_DATABASE_URI, SQLALCHEMY_TRACK_MODIFICATIONS
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = SQLALCHEMY_DATABASE_URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = SQLALCHEMY_TRACK_MODIFICATIONS
db = SQLAlchemy(app)
api = Api(app)

import views
from models import Car
EOF

# Setup control

cat << EOF > scripts/start.py
from flask_script import Manager

from app import app

manager = Manager(app)

if __name__ == "__main__":
    manager.run()
EOF