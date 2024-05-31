@openapi-file=src/test/resources/petstore-openapi.yaml
Feature: Add a new pet to the store
	Add a new pet to the store

Background:
* url baseUrl

@operationId=addPet
Scenario Outline: Test addPet for <status> status code

	* def args = read(<testDataFile>)
	* def result = call read('addPet.feature@operation') args
	* match result.responseStatus == <status>
		Examples:
		| status | testDataFile |
		| 200    | 'test-data/addPet_200.yml' |
		| 400    | 'test-data/addPet_405.yml' |


@operationId=addPet
Scenario: explore addPet inline
	You can use this test to quickly explore your API.
	You can then copy this payload and paste it with Ctrl+Shift+V as an Example row above.
* def payload =
"""
{
  "statusCode": 200,
  "headers": {},
  "params": {},
  "body": {
    "id": 10,
    "name": "doggie",
    "category": {
      "id": 1,
      "name": "Dogs"
    },
    "photoUrls": [
      "string"
    ],
    "tags": [
      {
        "id": 0,
        "name": "string"
      }
    ],
    "status": "available"
  },
  "matchResponse": true
}
"""
* call read('addPet.feature@operation') payload


@ignore
@operation @operationId=addPet @openapi-file=src/test/resources/petstore-openapi.yaml
Scenario: operation PetApi/addPet
* def args = 
"""
{
    auth: #(karate.get('auth')), 
    headers: #(karate.get('headers')), 
    params: #(karate.get('params')), 
    body: #(karate.get('body')), 
    statusCode: #(karate.get('statusCode')), 
    matchResponse: #(karate.get('matchResponse'))
}
"""
* def authHeader = call read('classpath:karate-auth.js') args.auth
* def headers = karate.merge(args.headers || {}, authHeader || {})
Given path '/pet'
And headers headers
And request args.body
When method POST
# validate status code
* if (args.statusCode && responseStatus != args.statusCode) karate.fail(`status code was: ${responseStatus}, expected: ${args.statusCode}`)
# validate response body
* if (args.matchResponse === true) karate.call('addPet.feature@validate')

@ignore @validate
Scenario: validates addPet response

* def responseMatch =
"""
{
  "id": "##number",
  "name": "#string",
  "category": {
    "id": "##number",
    "name": "##string"
  },
  "photoUrls": "#array",
  "tags": "##array",
  "status": "##string"
}
"""
* match  response contains responseMatch

# validate nested array: photoUrls
* def photoUrls_MatchesEach = "##string"
* def photoUrls_Response = response.photoUrls || []
* match each photoUrls_Response contains photoUrls_MatchesEach
# validate nested array: tags
* def tags_MatchesEach = {"id":"##number","name":"##string"}
* def tags_Response = response.tags || []
* match each tags_Response contains tags_MatchesEach
