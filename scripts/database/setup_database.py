import os

import sqlalchemy
from sqlalchemy.orm import Session


MYSQL_PASSWORD = os.environ.get('MYSQL_ROOT_PASSWORD')
CATEGORIES_PATH = "./database/categories.json"

engine = sqlalchemy.create_engine(
    f'mysql+mysqlconnector://root:{MYSQL_PASSWORD}@localhost:3306',
    # echo=True   # Setting echo as True prints the database logs
)

session = Session(engine)

with open("../../database-schema/ddl.sql") as ddl:
    session.execute(ddl.read())
