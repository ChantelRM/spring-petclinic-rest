#!/bin/bash

BASE_URL="http://localhost:9966/petclinic/api"

# Scenario: Create owner with valid data -> expect 201
echo "=== Create owner with valid data ==="
CREATE_RESPONSE=$(curl -s -X POST "$BASE_URL/owners" \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Jane","lastName":"Doe","address":"123 Main St","city":"Joburg","telephone":"0821234567"}')
echo "$CREATE_RESPONSE"

OWNER_ID=$(echo "$CREATE_RESPONSE" | jq '.id')
echo "Created owner id: $OWNER_ID"
echo ""

# Scenario: Retrieve owner by id -> expect 200
echo "=== Retrieve owner by id ==="
curl -X GET "$BASE_URL/owners/$OWNER_ID" -w "\nStatus: %{http_code}\n\n"

# Scenario: Update owner's details -> expect 200
echo "=== Update owner details ==="
curl -X PUT "$BASE_URL/owners/$OWNER_ID" \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Jane","lastName":"Doe","address":"456 New St","city":"Joburg","telephone":"0821234567"}' \
  -w "\nStatus: %{http_code}\n\n"

# Scenario: Add pet to existing owner with valid data -> expect 201
echo "=== Add pet to owner ==="
PET_RESPONSE=$(curl -s -X POST "$BASE_URL/owners/$OWNER_ID/pets" \
  -H "Content-Type: application/json" \
  -d '{"name":"Rex","birthDate":"2020-01-01","type":{"id":2,"name":"dog"}}')
echo "$PET_RESPONSE"
PET_ID=$(echo "$PET_RESPONSE" | jq '.id')
echo "Pet id: $PET_ID"
echo ""

# Scenario: Get owner's pet details -> expect 200
echo "=== Get owner's pet ==="
curl -X GET "$BASE_URL/owners/$OWNER_ID/pets/$PET_ID" -w "\nStatus: %{http_code}\n\n"

# Scenario: Update pet with valid data -> expect 200 or 204 (verify which, like we did for Owner)
echo "=== Update pet details ==="
curl -X PUT "$BASE_URL/owners/$OWNER_ID/pets/$PET_ID" \
  -H "Content-Type: application/json" \
  -d '{"name":"Rex","birthDate":"2020-01-01","type":{"id":2,"name":"dog"}}' \
  -w "\nStatus: %{http_code}\n\n"

# Scenario: Schedule a visit for the pet -> expect 201
echo "=== Schedule visit for pet ==="
curl -X POST "$BASE_URL/owners/$OWNER_ID/pets/$PET_ID/visits" \
  -H "Content-Type: application/json" \
  -d '{"date":"2026-09-09","description":"Routine checkup"}' \
  -w "\nStatus: %{http_code}\n\n"

# Scenario: Delete owner by id -> expect 204 or 200
echo "=== Delete owner by id ==="
curl -X DELETE "$BASE_URL/owners/$OWNER_ID" -w "\nStatus: %{http_code}\n\n"
