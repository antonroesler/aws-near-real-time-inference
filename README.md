# AWS Near Real Time ML Inference Demo
AWS project to demonstrate near realtime machine learning inference using a cloud native approach. 

# Architecture
![realtimestream drawio](https://github.com/antonroesler/aws-near-real-time-inference/assets/45258920/b45d177c-d6d9-41fe-b1c9-b09fe3116a58)

In the AWS Demo Architecture, a signal producer sends data to an HTTP API. For the purpose of resource conservation and the simplicity nature of this demo, the producer is a Python script that produces a random short numeric sequence every 0-1 seconds. It's important to note that in a broader context, the producer could exemplify any device, such as a robot that monitors an assembly line by recording images, preassure, vibration measurements etc.

Each incoming request triggers the execution of a Step Functions Workflow. Within this workflow, the data is send to a machine learning model that is hosted as a Sagemaker endpoint. The model's prediction, classified either as a failure or non-failure, along with the prediction's probability, is preserved in DynamoDB.

Subsequently, a Kinesis Data Stream streams the prediction data, via Kinesis Firehose, to an S3 Bucket. During this transmission, the prediction data undergoes a transformation and conversion to parquet format. An observer analyzes the data through a QuickSight dashboard, which is fed by Athena queries on the parquet files stored in the S3 bucket.
