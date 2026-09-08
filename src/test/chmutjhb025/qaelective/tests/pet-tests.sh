Add pet to existing owner with valid data → expect 201 (baseline positive case)
Add pet to a non-existent owner (e.g. owner id 999999) → expect 404
Add pet with an invalid pet type (petType id that doesn't exist) → expect 400 or 404
Add pet with a future birth date → note actual behaviour (likely unvalidated — good bug-report candidate)
Add pet with a missing name field → expect 400
Get pet with a non-existent id → expect 404
Update pet with valid data → expect 200
