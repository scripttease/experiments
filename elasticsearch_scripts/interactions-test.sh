#!/bin/sh
SCRIPT='{ 
  "script": {
  "inline": "if (ctx._source.interaction instanceof ArrayList) { ctx._source.interaction.push(new_interaction) } else { (ctx._source.interaction = [ctx._source.interaction, new_interaction]) }",
    "params": {
      "new_interaction": {
        "atomid": "louis" 
      }
    }
  },
  "upsert": {
    "interaction": [
        {
          "atomid": "louis" 
        }
      ]
    }
  }
}'

CT="Content-Type: application/json"

echo "Delete-ing /customer/"
curl -s -XDELETE 'http://localhost:9200/customer/' | jq

echo "\nPut-ing mapping (data.json) to /customer"
curl -s -XPUT 'http://localhost:9200/customer' -H "$CT" -d '@data.json' | jq

echo "\nPost-ing object to /customer/pageview/1"
curl -s -XPOST 'localhost:9200/customer/pageview/1' -H "$CT" -d '{ 
  "interaction": 
    {
      "atomid": "alice" 
    }
}' | jq

echo "\nPost-ing to array /customer/pageview/2"
curl -s -XPOST 'localhost:9200/customer/pageview/2' -H "$CT" -d '{ 
  "interaction": [
    {
      "atomid": "alice" 
    }
  ]
}' | jq

echo "\nUpdating to /customer/pageview/1"
curl -s -XPOST 'localhost:9200/customer/pageview/1/_update' -H "$CT" -d "$SCRIPT" | jq

echo "\nUpdating to /customer/pageview/2 (array)"
curl -s -XPOST 'localhost:9200/customer/pageview/2/_update' -H "$CT" -d "$SCRIPT" | jq

echo "\nUpdating to /customer/pageview/3 (doesn't exist)"
curl -s -XPOST 'localhost:9200/customer/pageview/3/_update' -H "$CT" -d "$SCRIPT" | jq

echo "\nGet-ing /customer/pageview/1"
curl -s 'localhost:9200/customer/pageview/1' | jq

echo "\nGet-ing /customer/pageview/2 (array)"
curl -s 'localhost:9200/customer/pageview/2' | jq

echo "\nGet-ing /customer/pageview/3 (doesn't exist)"
curl -s 'localhost:9200/customer/pageview/3' | jq



# TEST="curl http://127.0.0.1 -H $CT"
# echo $TEST

# RESPONSE=`$TEST`
# echo $RESPONSE
