import base64
import json

print("Loading function")


def lambda_handler(event, context):
    output = []

    for record in event["records"]:
        print(record)
        payload = base64.b64decode(record["data"]).decode("utf-8")
        print(payload)
        payload = json.loads(payload)
        db_entry = payload["dynamodb"]
        print(db_entry)

        sensor = db_entry["NewImage"]["sensor"]["S"]
        timestamp = db_entry["NewImage"]["timestamp"]["N"]
        prediction = db_entry["NewImage"]["failure-prediction"]["N"]
        probability = db_entry["NewImage"]["probability"]["N"]

        new_data = {
            "timestamp": int(timestamp),
            "sensor": str(sensor),
            "probability": float(probability),
            "failure-prediction": int(prediction),
        }

        payload = json.dumps(new_data)
        print(payload)

        output_record = {
            "recordId": record["recordId"],
            "result": "Ok",
            "data": base64.b64encode(payload.encode("utf-8")).decode("utf-8"),
        }
        output.append(output_record)

    print("Successfully processed {} records.".format(len(event["records"])))

    return {"records": output}
