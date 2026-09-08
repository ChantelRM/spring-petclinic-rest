#!/bin/bash

# Scenario: Create owner with valid data -> expect 201
echo "=== Create owner with valid data ==="
curl -X POST http://localhost:9966/petclinic/api/v1/owners \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Jane","lastName":"Doe","address":"123 Main St","city":"Joburg","telephone":"0821234567"}' \
  -w "\nStatus: %{http_code}\n\n"
