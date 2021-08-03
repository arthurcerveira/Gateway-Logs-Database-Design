import json
import argparse
from datetime import datetime

from database.engine import *


parser = argparse.ArgumentParser(description='Add logs to database.')
parser.add_argument("log", metavar="Logs path")
parser.add_argument("-n", metavar="Number of insertions", type=int)
args = parser.parse_args()

LOGS = args.log
INSERTIONS = args.n if args.n is not None else float("inf")

def insert_data(table, data):
    # Format data according to database style
    formatted_data = dict()

    for field in data:
        value = data[field]

        # Convert string to boolean
        if value == "true":
            value = True

        if value == "false":
            value = False

        formatted_field = field.lower().replace('-', '_')
        formatted_data[formatted_field] = value

    entity = table(**formatted_data)

    session.add(entity)
    session.commit()  # Commit to get object id

    return entity.id


def add_log_to_database(log):
    # Add latencies to DB
    latencies = log["latencies"]
    latencies_id = insert_data(Latencies, latencies)

    # Add service to DB
    service = log["service"]
    service_id = service["id"]

    protocol = service.pop('protocol')
    service["protocol_id"] = PROTOCOLS[protocol]

    if not session.query(Service).get(service_id):
        insert_data(Service, service)

    # Add response header to DB
    reponse_header = log["response"]["headers"]

    # Convert content lenght to int
    reponse_header["Content-Length"] = int(
        reponse_header["Content-Length"])

    response_header_id = insert_data(ResponseHeader, reponse_header)

    # Add response to DB
    reponse = log["response"]
    reponse["header_id"] = response_header_id

    del reponse["headers"]

    response_id = insert_data(Response, reponse)

    # Add request header to DB
    request_header = log["request"]["headers"]

    request_header_id = insert_data(RequestHeader, request_header)

    # Add request to DB
    request = log["request"]

    # Get method id
    request["method_id"] = METHODS[request["method"]]
    request["header_id"] = request_header_id

    del request["method"]
    del request["headers"]

    query_strings = request.pop("querystring")

    request_id = insert_data(Request, request)

    # Add query string to table
    for query_string in query_strings:
        session.add(RequestQueryString(
            request_id=request_id,
            query_string=query_string
        ))

    session.commit()

    # Add route to DB
    route = log["route"]

    route["service_id"] = route["service"]["id"]
    del route["service"]

    methods = route.pop("methods")
    paths = route.pop("paths")
    protocols = route.pop("protocols")

    route_id = route["id"]

    if not session.query(Route).get(route_id):
        insert_data(Route, route)

        # Add route methods to DB
        for method in methods:
            method_id = METHODS[method]

            session.add(RouteMethod(
                route_id=route_id,
                method_id=method_id
            ))

        # Add route paths to DB
        for path in paths:
            session.add(RoutePath(
                route_id=route_id,
                path=path
            ))

        # Add route protocols to DB
        for protocol in protocols:
            protocol_id = PROTOCOLS[protocol]

            session.add(RouteProtocol(
                route_id=route_id,
                protocol_id=protocol_id
            ))

    session.commit()

    # Add solicitation
    solicitation = dict()

    solicitation["consumer_id"] = log["authenticated_entity"]["consumer_id"]["uuid"]
    solicitation["client_ip"] = log["client_ip"]
    solicitation["started_at"] = log["started_at"]
    solicitation["upstream_uri"] = log["upstream_uri"]

    solicitation["request_id"] = request_id
    solicitation["response_id"] = response_id
    solicitation["route_id"] = route_id
    solicitation["service_id"] = service_id
    solicitation["latencies_id"] = latencies_id

    insert_data(Solicitation, solicitation)


if __name__ == "__main__":
    progress = 0
    print(f"[{datetime.now():%H:%M:%S}] Starting to add logs to database...")

    with open(LOGS) as logs:
        for line in logs:
            log = json.loads(line)

            add_log_to_database(log)

            progress += 1
            if progress % 250 == 0:
                print(f"[{datetime.now():%H:%M:%S}] {progress} logs processed...")

            if progress >= INSERTIONS:
                break

