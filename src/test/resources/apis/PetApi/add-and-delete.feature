@openapi-file=src/test/resources/petstore-openapi.yaml
Feature: apis PetApi add-and-delete

Background:
* url baseUrl

@business-flow 
@operationId=addPet @operationId=deletePet
Scenario: apis PetApi add-and-delete

* def auth = { username: '', password: '' }

# addPet 
# Add a new pet to the store
Given def body =
"""
{
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
}
"""
When call read('classpath:apis/PetApi/addPet.feature@operation')
Then match responseStatus == 200
Then match response contains {"category":{"id":1,"name":"Dogs"},"name":"doggie","photoUrls":["string"],"tags":[{"id":0,"name":"string"}],"status":"available"}
* def addPetResponse = response

# deletePet 
# Deletes a pet
Given def params = {"api_key":"fill some value","petId":10}
When call read('classpath:apis/PetApi/deletePet.feature@operation')
Then match responseStatus == 200
* def deletePetResponse = response

