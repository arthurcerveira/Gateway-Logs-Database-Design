import json
from pprint import pprint


LOGS = "data/logs.txt"


def add_log_to_database(log):
    pass


if __name__ == "__main__":
    with open(LOGS) as logs:
        for line in logs:
            log = json.loads(line)
            add_log_to_database(log)
