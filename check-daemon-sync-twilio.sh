#!/bin/bash

CYCLE_TEST=0

while true
do
    CHAIN_STATUS=$(lotus-miner info | grep Chain | awk '{print $3}' | tr -d ']')
    TIME=$(date +"%T")

    if [[ "$CHAIN_STATUS" == *ok* ]]
    then
        echo "Chain status ok"
        CYCLE_TEST=0  # reset the cycle count if the chain is ok
    elif ((CYCLE_TEST < 3))
    then
        echo "CYCLE_TEST: $CYCLE_TEST"
        ((CYCLE_TEST++))
    else
        curl -X POST https://api.twilio.com/2010-04-01/Accounts/ACdf214d604d06abf1405d39cbc4183bba/Messages.json \ # example
            --data-urlencode 'To=whatsapp:+31xxxxxxxxxxx' \
            --data-urlencode 'From=whatsapp:+32xxxxxxxxxxx' \
            --data-urlencode $'Body=Daemon not in sync' \
            -u ACdf214d604d06abf1405d39cbc4183bba:90dda72f6f2781e38f5ea87864136075 #example
        CYCLE_TEST=0  # reset the cycle count after sending the message
    fi

    sleep 120
done
