import numpy as np
import time
import random
import requests
from datetime import datetime, timedelta

SENSORS = ["sensor-xy", "kate-sens", "sensor-34"]
INTERVAL_S = 1
URL = "https://s5vyew1gd4.execute-api.eu-central-1.amazonaws.com/dev/pipeline"
np.random.seed(42)

start = datetime.now() - timedelta(days=20)
interval = timedelta(seconds=INTERVAL_S)
value_time = start
count = 0

while True:
    value = list(np.random.randint(0, 100, 3))
    last_time = value_time
    value_time = int(datetime.now().timestamp() * 10**3)
    print(f"{value_time}:\t {value}")
    soll = start + interval * count
    request_body = {
        "input": '{"timestamp": '
        + str(value_time)
        + ', "sensor": "'
        + random.choice(SENSORS)
        + '","model": "serverlessendpoint","data":'
        + str(value)
        + "}",
        "stateMachineArn": "arn:aws:states:eu-central-1:847994532797:stateMachine:MyStateMachine-ehd5niai3",
    }
    requests.post(URL, json=request_body)
    time.sleep(np.random.rand())
