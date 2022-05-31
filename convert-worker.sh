#!/bin/bash
SQSQUEUE=%SQSQUEUE%

FILELOG=logs.txt

touch $FILELOG

while sleep 5; do

  JSON=$(aws sqs --output=json get-queue-attributes \
    --queue-url $SQSQUEUE \
    --attribute-names ApproximateNumberOfMessages)
  MESSAGES=$(echo "$JSON" | jq -r '.Attributes.ApproximateNumberOfMessages')

  printf $MESSAGES >> $FILELOG

  if [ $MESSAGES -eq 0 ]; then
    echo 'Sin mensajes'
    continue

  fi

  JSON=$(aws sqs --output=json receive-message --queue-url $SQSQUEUE)
  RECEIPT=$(echo "$JSON" | jq -r '.Messages[] | .ReceiptHandle')
  BODY=$(echo "$JSON" | jq -r '.Messages[] | .Body')

  if [ -z "$RECEIPT" ]; then

    printf "Empty receipt. Something went wrong." >> $FILELOG
    continue

  fi

  printf $BODY >> $FILELOG

done