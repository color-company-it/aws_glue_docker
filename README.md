# aws_glue_docker

An AWS Glue Docker Container with PySpark for Local Development and Testing.

Start by building the Docker Image:

```commandline
docker build -t awsglue .
```

This may take a while when the GLue Libraries are being set up. Next, start the container:

```commandline
docker run --name awsglue -v ~/.aws:/home/app/.aws/credentials:ro -t -d awsglue
```

You will be in the `aws-glue-libs` working directory where Glue is available to you.
Run your scripts using:

```commandline
spark-submit main.py
```

ONce complete, remember to remove the contaier:

```commandline
docker stop awsglue
docker rm awsglue
```