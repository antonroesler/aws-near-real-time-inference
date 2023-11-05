# AWS Near Real Time ML Inference Demo
AWS project to demonstrate near realtime machine learning inference using a cloud native and serverless approach. 

# Architecture
![realtimestream drawio](https://github.com/antonroesler/aws-near-real-time-inference/assets/45258920/b45d177c-d6d9-41fe-b1c9-b09fe3116a58)

In the AWS Demo Architecture, a signal producer sends data to an HTTP API. For the purpose of resource conservation and the simplicity nature of this demo, the producer is a Python script that produces a random short numeric sequence every 0-1 seconds. It's important to note that in a broader context, the producer could exemplify any device, such as a robot that monitors an assembly line by recording images, preassure, vibration measurements etc.

Each incoming request triggers the execution of a Step Functions Workflow. Within this workflow, the data is send to a machine learning model that is hosted as a Sagemaker endpoint. The model's prediction, classified either as a failure or non-failure, along with the prediction's probability, is preserved in DynamoDB.

Subsequently, a Kinesis Data Stream streams the prediction data, via Kinesis Firehose, to an S3 Bucket. During this transmission, the prediction data undergoes a transformation and conversion to parquet format. An observer analyzes the data through a QuickSight dashboard, which is fed by Athena queries on the parquet files stored in the S3 bucket.

# Use Case 
This setup allows for the constant observation of multiple  continuous data-producing processes for which machine learning models can be used to predict certain events or conditions.  Thanks to the modular structure, new models can be trained on an ongoing basis. These can be deployed and used without having to adapt the infrastructure or components. This means that engineers can develop new models in AWS SageMaker and make them available via a new serverless endpoint (by using a certain name prefix). The signal producers, for which the new model is intended, can from now on ingest data by specifying the model name in the HTTP request body. 

The data, including the model predictions, are stored persistently in DynamoDB and are available for further use. Furthermore, the data are streamed in near real-time in parquet format into an S3 bucket and can be queried from there using Athena. The Athena queries might be visualized with QuickSight for an observer to monitor the proceses in real time.

![athena](https://github.com/antonroesler/aws-near-real-time-inference/assets/45258920/61e8b38b-a437-4191-9489-07522580cb64)

# Demo Use Case

For the demo, a script (producer.py) creates random short numeric sequence every 0-1 seconds that are send via HTTP. Each request body contains the sequence, the sensor name and the model which is used to make a prediction (failure / no failure). 
