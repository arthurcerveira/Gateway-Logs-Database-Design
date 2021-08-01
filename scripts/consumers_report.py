import os

from sqlalchemy import func
from database.engine import session, Solicitation


REPORTS = "../reports"

if not os.path.isdir(REPORTS):
    os.mkdir(REPORTS)

OUTPUT = f"{REPORTS}/Requests-Per-Consumer.csv"
HEADER = "Consumer ID, Requests\n"

with open(OUTPUT, 'w') as output:
    output.write(HEADER)

results = session.query(Solicitation.consumer_id,
                        func.count(Solicitation.request_id)) \
    .group_by(Solicitation.consumer_id)  \
    .all()

with open(OUTPUT, 'a') as output:
    for result in results:
        consumer_id, requests = result
        output.write(f"{consumer_id},{requests}\n")
