#!/bin/bash
curl -X GET -H "Authorization: 7460df7e664ca9511fc3c698381e0115" https://www.papercall.io/api/v1/submissions | 
jq --arg type `date +%Y%m%d%H%M` -c '
.[] |
{ index: { _index: "submissions", _type: $type }}, 
  .' 
