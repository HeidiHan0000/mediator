# Hub Router APIs

### Invitation API - HTTP GET /didcomm/invitation
Returns mediator DIDComm [Out-Of-Band invitation](https://github.com/hyperledger/aries-rfcs/tree/master/features/0434-outofband#invitation-httpsdidcommorgout-of-bandverinvitation).

#### Response 
``` json
{
   "invitation":{ <oob_invitation> }
}
```

##### Sample Response
``` json
{
   "invitation":{
      "@id":"4fb5bb1d-705b-4be2-9fe3-0a406232ac8f",
      "@type":"https://didcomm.org/out-of-band/1.0/invitation",
      "label":"mediator",
      "service":[
         {
            "ID":"58fe0316-ea25-4db4-b4b2-946a9b75cb3e",
            "Type":"did-communication",
            "Priority":0,
            "RecipientKeys":[
               "8XQawExAm8s2N1U9i4zBWEUmeqBDW3rfDLnqoSn92acc"
            ],
            "ServiceEndpoint":"wss://mediator.example.com:10202"
         }
      ],
      "protocols":[
         "https://didcomm.org/didexchange/1.0"
      ]
   }
}
```

