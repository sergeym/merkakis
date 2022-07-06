#!/usr/bin/env bash

echo "Waiting for LocalStack to launch..."

while ! nc -z localstack 4566; do
  sleep 1
done

echo -e "\tLocalStack launched\n"

pip install -r requirements.txt

echo -e "Testing s3_lambda\n\n"
pwd
cd ./s3_lambda/
pytest -s .
echo