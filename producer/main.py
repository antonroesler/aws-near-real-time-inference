import numpy as np
import time
from datetime import datetime, timedelta

INTERVAL_S = 1

np.random.seed(42)

start = datetime.now() - timedelta(days=20)
interval = timedelta(seconds=INTERVAL_S)
value_time = start
count = 0

while True:
    value = np.random.randint(0, 100)
    last_time = value_time
    value_time = datetime.now()
    print(f"{value_time}:\t {value}\t{(value_time-last_time).total_seconds()}")
    soll = start + interval * count
    # offset = value_time - soll
    # count += 1
    # time.sleep(INTERVAL_S - offset.total_seconds())
