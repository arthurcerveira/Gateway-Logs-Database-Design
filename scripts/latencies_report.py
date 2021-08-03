import os

from sqlalchemy import func
from database.engine import session, Solicitation, Service, Latencies


REPORTS = "../reports"

if not os.path.isdir(REPORTS):
    os.mkdir(REPORTS)

OUTPUT = f"{REPORTS}/Latencies-Per-Service.csv"
HEADER = "Service ID, Service, Request time, Proxy time, Kong time\n"

with open(OUTPUT, 'w') as output:
    output.write(HEADER)

results = session.query(Service.id,
                        Service.name,
                        func.avg(Latencies.request),
                        func.avg(Latencies.proxy),
                        func.avg(Latencies.kong)) \
    .filter(Solicitation.service_id == Service.id &
            Latencies.id == Solicitation.latencies_id) \
    .group_by(Service.id, Service.name)  \
    .all()

with open(OUTPUT, 'a') as output:
    for result in results:
        service_id, service_name, request, proxy, kong = result
        output.write(f"{service_id},{service_name},"
                     + f"{request},{proxy},{kong}\n")
