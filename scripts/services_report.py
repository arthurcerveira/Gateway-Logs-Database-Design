import os

from sqlalchemy import func
from database.engine import session, Solicitation, Service


REPORTS = "../reports"

if not os.path.isdir(REPORTS):
    os.mkdir(REPORTS)

OUTPUT = f"{REPORTS}/Requests-Per-Service.csv"
HEADER = "Service ID, Service, Requests\n"

with open(OUTPUT, 'w') as output:
    output.write(HEADER)

results = session.query(Solicitation.service_id,
                        Service.name,
                        func.count(Solicitation.request_id)) \
    .filter(Solicitation.service_id == Service.id) \
    .group_by(Solicitation.service_id)  \
    .all()

with open(OUTPUT, 'a') as output:
    for result in results:
        service_id, service_name, requests = result
        output.write(f"{service_id},{service_name},{requests}\n")
