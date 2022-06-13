#!/usr/bin/bash

response_json=curl -X GET https://catfact.ninja/fact
touch api_response.csv
response="$response_json | jq .fact"
echo $response_json | jq .name >api_response.csv
echo `date` >> api_response.csv
echo `df -k /dev/sda1` | awk '{print $4}'>> api_response.csv
