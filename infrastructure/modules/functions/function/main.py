import boto3
import logging

logging.basicConfig()
logging.getLogger().setLevel(logging.DEBUG)


def lambda_handler(event, context):
    logging.info(event)
    sagemaker_client = boto3.client("sagemaker-runtime")

    ENDPOINT_NAME = event.get("model")
    logging.info(ENDPOINT_NAME)

    data = event.get("data")
    timestamp = event.get("timestamp")
    sensor = event.get("sensor")

    body = (
        '{"data":{"features":{"values":'
        + str([timestamp, *data, str(timestamp)])
        + "}}}"
    )

    response = sagemaker_client.invoke_endpoint(
        EndpointName=ENDPOINT_NAME,
        Body=bytes(body, "utf-8"),
        ContentType="application/json",
    )

    body = response.get("Body")
    data = body.read().decode("utf-8")
    is_event, prob = (
        str(data)
        .replace("(", "")
        .replace(")", "")
        .replace("[", "")
        .replace("]", "")
        .split(",")
    )
    logging.info(data)

    return {
        "statusCode": 200,
        "body": {
            "timestamp": str(timestamp),
            "sensor": str(sensor),
            "prediction": str(int(is_event)),
            "probability": str(float(prob)),
        },
    }
