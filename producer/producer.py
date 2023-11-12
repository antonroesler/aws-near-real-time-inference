# Signal Producer

import numpy as np
import time
import random
import requests
from datetime import datetime, timedelta

SENSORS = ["sensor-x", "sensor-1", "sensor-34"]
INTERVAL_S = 1
URL = "<API GATEWAY ENDPOINT>"

start = datetime.now() - timedelta(days=20)
interval = timedelta(seconds=INTERVAL_S)
value_time = start
count = 0

while True:
    values = list(np.random.randint(0, 100, 3))
    last_time = value_time
    value_time = int(datetime.now().timestamp() * 10**3)
    print(f"{value_time}:\t {values}")
    soll = start + interval * count
    request_body = {
        "timestamp": int(value_time),
        "sensor": random.choice(SENSORS),
        "model": "serverlessendpoint",
        "data": [int(x) for x in values],
    }
    requests.post(URL, json=request_body)
    time.sleep(np.random.rand())
