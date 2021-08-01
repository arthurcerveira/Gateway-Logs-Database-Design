import os
import json

import sqlalchemy
from sqlalchemy.orm import Session
from sqlalchemy.ext.automap import automap_base

MYSQL_PASSWORD = os.environ.get('MYSQL_ROOT_PASSWORD')
CATEGORIES_PATH = "./database/categories.json"

Base = automap_base()

engine = sqlalchemy.create_engine(
    f'mysql+mysqlconnector://root:{MYSQL_PASSWORD}@localhost:3306',
    # echo=True   # Setting echo as True prints the database logs
)

Base.prepare(engine, reflect=True, schema="melhorenvio")

Solicitation = Base.classes.solicitation
Latencies = Base.classes.latencies
Service = Base.classes.service
Response = Base.classes.response
ResponseHeader = Base.classes.response_header
Request = Base.classes.request
RequestHeader = Base.classes.request_header
RequestQueryString = Base.classes.request_query_string
Route = Base.classes.route
RouteMethod = Base.classes.route_method
RoutePath = Base.classes.route_path
RouteProtocol = Base.classes.route_protocol
Method = Base.classes.method
Protocol = Base.classes.protocol

session = Session(engine)

# Add predefined categories to database
with open(CATEGORIES_PATH) as categories:
    CATEGORIES = json.load(categories)

METHODS = CATEGORIES["methods"]
PROTOCOLS = CATEGORIES["protocols"]

methods = session.query(Method).all()

# Add methods if they are not defined
if len(methods) == 0:
    for method in METHODS:
        method_id = METHODS[method]
        session.add(Method(
            id=method_id, name=method
        ))

protocols = session.query(Protocol).all()

# Add protocols if they are not defined
if len(protocols) == 0:
    for protocol in PROTOCOLS:
        protocol_id = PROTOCOLS[protocol]
        session.add(Protocol(
            id=protocol_id, name=protocol
        ))

session.commit()
