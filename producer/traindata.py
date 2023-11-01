import numpy as np
import csv
import time
from datetime import datetime, timedelta

INTERVAL_S = 1

np.random.seed(0)

start = datetime.now() - timedelta(days=20)
interval = timedelta(seconds=INTERVAL_S)
value_time = start

data = [["id", "event", "t1", "t2", "t3", "timestamp"]]
es = 0
for count in range(50_000):
    a, b, c = np.random.randint(0, 100, 3)
    event = 1 if b - a > 50 and b - c > 50 and abs(a - c) < 20 else 0
    es += event
    value_time = (
        start
        + timedelta(seconds=count)
        + timedelta(milliseconds=np.random.randint(100))
    )
    count += 1
    data.append([count, event, a, b, c, str(value_time)])


with open("./data.csv", "w", newline="") as myfile:
    wr = csv.writer(myfile)
    wr.writerows(data)
print(es)
