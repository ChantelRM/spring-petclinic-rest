# Add pet to existing owner with valid data → expect 201 (baseline positive case)
# Add pet to a non-existent owner (e.g. owner id 999999) → expect 404
# Add pet with an invalid pet type (petType id that doesn't exist) → expect 400 or 404
# Add pet with a future birth date → note actual behaviour (likely unvalidated — good bug-report candidate)
# Add pet with a missing name field → expect 400
# Get pet with a non-existent id → expect 404
# Update pet with valid data → expect 200

#!/bin/bash

BASE_URL="http://localhost:9966/petclinic/api"

# Pet creation still only happens via the nested owner route, so create an
# owner + pet here first, purely to get a real PET_ID to test the flat
# /api/pets endpoints against.
echo "=== Setup: create owner + pet ==="
OWNER_RESPONSE=$(curl -s -X POST "$BASE_URL/owners" \
  -H "Content-Type: application/json" \
  -d '{"firstName":"MMMMMMe","lastName":"Doe","address":"123 Main St","city":"Joburg","telephone":"0821234567"}')
OWNER_ID=$(echo "$OWNER_RESPONSE" | jq '.id')

PET_RESPONSE=$(curl -s -X POST "$BASE_URL/owners/$OWNER_ID/pets" \
  -H "Content-Type: application/json" \
  -d '{"name":"Rex","birthDate":"2020-01-01","type":{"id":2,"name":"dog"}}')
echo "$PET_RESPONSE"     # <-- add this line
PET_ID=$(echo "$PET_RESPONSE" | jq '.id')
echo ""

# Scenario: Get all pets -> expect 200
echo "=== Get all pets ==="
curl -X GET "$BASE_URL/pets" -w "\nStatus: %{http_code}\n\n"

# Scenario: Get pet by id -> expect 200
echo "=== Get pet by id ==="
curl -X GET "$BASE_URL/pets/$PET_ID" -w "\nStatus: %{http_code}\n\n"

# Scenario: Get pet with non-existent id -> expect 404
echo "=== Get pet with non-existent id ==="
curl -X GET "$BASE_URL/pets/999999" -w "\nStatus: %{http_code}\n\n"

# Scenario: Update pet details via flat route -> expect 200 or 204 (check which)
echo "=== Update pet via flat route ==="
curl -X PUT "$BASE_URL/pets/$PET_ID" \
  -H "Content-Type: application/json" \
  -d '{"name":"Rex Updated","birthDate":"2020-01-01","type":{"id":2,"name":"dog"}}' \
  -w "\nStatus: %{http_code}\n\n"

# Scenario: Update pet with invalid data (missing name) -> expect 400
echo "=== Update pet with missing name ==="
curl -X PUT "$BASE_URL/pets/$PET_ID" \
  -H "Content-Type: application/json" \
  -d '{"birthDate":"2020-01-01","type":{"id":2,"name":"dog"}}' \
  -w "\nStatus: %{http_code}\n\n"

# Scenario: Confirm there's no POST /api/pets (creation should be owner-only)
echo "=== Attempt POST to flat /api/pets (should not be allowed) ==="
curl -X POST "$BASE_URL/pets" \
  -H "Content-Type: application/json" \
  -d '{"name":"NoOwnerPet","birthDate":"2020-01-01","type":{"id":2,"name":"dog"}}' \
  -w "\nStatus: %{http_code}\n\n"

# Scenario: Delete pet by id -> expect 200 or 204
echo "=== Delete pet by id ==="
curl -X DELETE "$BASE_URL/pets/$PET_ID" -w "\nStatus: %{http_code}\n\n"

# Scenario: Delete pet with non-existent id -> expect 404
echo "=== Delete pet with non-existent id ==="
curl -X DELETE "$BASE_URL/pets/999999" -w "\nStatus: %{http_code}\n\n"