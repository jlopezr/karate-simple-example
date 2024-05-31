@openapi-file=src/test/resources/petstore-openapi.yaml
Feature: Deletes a pet
	

Background:
* url baseUrl

@operationId=deletePet
Scenario Outline: Test deletePet for <status> status code

	* def params = __row
	* def result = call read('deletePet.feature@operation') { statusCode: #(+params.status), params: #(params), matchResponse: #(params.matchResponse) }
	* match result.responseStatus == <status>
		Examples:
		| status | api_key | petId | matchResponse |
		| 200    | fill some value | 0 | false          |


@operationId=deletePet
Scenario: explore deletePet inline
	You can use this test to quickly explore your API.
	You can then copy this payload and paste it with Ctrl+Shift+V as an Example row above.
* def statusCode = 200
* def params = {"api_key":"fill some value","petId":0}
* def matchResponse = true
* call read('deletePet.feature@operation') 


@ignore
@operation @operationId=deletePet @openapi-file=src/test/resources/petstore-openapi.yaml
Scenario: operation PetApi/deletePet
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
Given path '/pet/', args.params.petId
And headers headers
When method DELETE
# validate status code
* if (args.statusCode && responseStatus != args.statusCode) karate.fail(`status code was: ${responseStatus}, expected: ${args.statusCode}`)
