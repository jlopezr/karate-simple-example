@openapi-file=src/test/resources/petstore-openapi.yaml
Feature: Finds Pets by status
	Multiple status values can be provided with comma separated strings

Background:
* url baseUrl

@operationId=findPetsByStatus
Scenario Outline: Test findPetsByStatus for <status> status code

	* def params = __row
	* def result = call read('findPetsByStatus.feature@operation') { statusCode: #(+params.status), params: #(params), matchResponse: #(params.matchResponse) }
	* match result.responseStatus == <status>
		Examples:
		| status | status | matchResponse |
		| 200    | available | true          |
		| 400    | available | false          |


@operationId=findPetsByStatus
Scenario: explore findPetsByStatus inline
	You can use this test to quickly explore your API.
	You can then copy this payload and paste it with Ctrl+Shift+V as an Example row above.
* def statusCode = 200
* def params = {"status":"available"}
* def matchResponse = true
* call read('findPetsByStatus.feature@operation') 


@ignore
@operation @operationId=findPetsByStatus @openapi-file=src/test/resources/petstore-openapi.yaml
Scenario: operation PetApi/findPetsByStatus
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
Given path '/pet/findByStatus'
And param status = args.params.status
And headers headers
When method GET
# validate status code
* if (args.statusCode && responseStatus != args.statusCode) karate.fail(`status code was: ${responseStatus}, expected: ${args.statusCode}`)
# validate response body
* if (args.matchResponse === true) karate.call('findPetsByStatus.feature@validate')

@ignore @validate
Scenario: validates findPetsByStatus response

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
* match each response contains responseMatch

# validate nested array: photoUrls
* def photoUrls_MatchesEach = "##string"
* match each response[*].photoUrls contains photoUrls_MatchesEach
# validate nested array: tags
* def tags_MatchesEach = {"id":"##number","name":"##string"}
* match each response[*].tags contains tags_MatchesEach
