# PetClinic QA — Issue Backlog

One package, entity/topic-organized stories, each with nested Gherkin scenarios.
This backlog is designed to cover every objective in the learning plan without
creating a separate issue per "level" — related concerns are bundled so the
issue count stays manageable.

Package for all test code (flat for now):
```
src/test/java/<yourname>/petclinicqa/
```

---

## Issue 1: Owner API validation
**Covers:** manual API testing, positive/negative testing, equivalence partitioning, boundary value analysis

```gherkin
Feature: Owner API validation

  Scenario: Create owner with valid data
    Given valid owner details (first name, last name, address, city, telephone)
    When I send a POST request to /api/v1/owners
    Then the response status should be 201
    And the response body should contain the created owner with an id

  Scenario: Create owner with missing required field
    Given owner details missing the "lastName" field
    When I send a POST request to /api/v1/owners
    Then the response status should be 400
    And the response should indicate which field failed validation

  Scenario: Create owner with empty string values
    Given owner details where "firstName" is an empty string
    When I send a POST request to /api/v1/owners
    Then the response status should be 400

  Scenario: Create owner with null values
    Given owner details where "city" is null
    When I send a POST request to /api/v1/owners
    Then the response status should be 400

  Scenario: Create owner with telephone at boundary length
    Given a telephone number at the maximum allowed length
    When I send a POST request to /api/v1/owners
    Then the response status should be 201

  Scenario: Create owner with telephone exceeding max length
    Given a telephone number one character over the maximum allowed length
    When I send a POST request to /api/v1/owners
    Then the response status should be 400

  Scenario: Create owner with special characters in name fields
    Given a firstName containing special characters (e.g. "Jane<script>")
    When I send a POST request to /api/v1/owners
    Then the response status should be 201 or 400
    And note the actual behaviour for later security testing

  Scenario: Get owner with non-existent id
    Given no owner exists with id 999999
    When I send a GET request to /api/v1/owners/999999
    Then the response status should be 404

  Scenario: Update owner with valid data
    Given an existing owner
    When I send a PUT request to /api/v1/owners/{id} with updated fields
    Then the response status should be 200
    And the response body should reflect the updated values

  Scenario: Delete owner (if endpoint exists)
    Given an existing owner with no pets
    When I send a DELETE request to /api/v1/owners/{id}
    Then the response status should be 204 or 200
```

---

## Issue 2: Pet API validation
**Covers:** manual API testing, positive/negative testing, boundary analysis, relationship testing (Owner → Pet)

```gherkin
Feature: Pet API validation

  Scenario: Add pet to existing owner with valid data
    Given an existing owner
    And valid pet details (name, birth date, type)
    When I send a POST request to /api/v1/owners/{ownerId}/pets
    Then the response status should be 201

  Scenario: Add pet to non-existent owner
    Given no owner exists with the given id
    When I send a POST request to /api/v1/owners/999999/pets
    Then the response status should be 404

  Scenario: Add pet with invalid pet type
    Given pet details with a petType id that does not exist
    When I send a POST request to /api/v1/owners/{ownerId}/pets
    Then the response status should be 400 or 404

  Scenario: Add pet with future birth date
    Given pet details where birthDate is in the future
    When I send a POST request to /api/v1/owners/{ownerId}/pets
    Then note the actual behaviour (validation gap candidate for a bug report)

  Scenario: Add pet with missing name
    Given pet details missing the "name" field
    When I send a POST request to /api/v1/owners/{ownerId}/pets
    Then the response status should be 400

  Scenario: Get pet with non-existent id
    Given no pet exists with id 999999
    When I send a GET request to /api/v1/owners/{ownerId}/pets/999999
    Then the response status should be 404

  Scenario: Update pet with valid data
    Given an existing pet
    When I send a PUT request to /api/v1/owners/{ownerId}/pets/{petId}
    Then the response status should be 200
```

---

## Issue 3: Vet & Specialty API validation
**Covers:** manual API testing, equivalence partitioning, read-only vs write endpoint differences

```gherkin
Feature: Vet API validation

  Scenario: Get all vets
    When I send a GET request to /api/v1/vets
    Then the response status should be 200
    And the response body should be a list of vets

  Scenario: Get vet with non-existent id
    Given no vet exists with id 999999
    When I send a GET request to /api/v1/vets/999999
    Then the response status should be 404

  Scenario: Create vet with valid data
    Given valid vet details (first name, last name)
    When I send a POST request to /api/v1/vets
    Then the response status should be 201

  Scenario: Create vet with a specialty that does not exist
    Given vet details referencing a non-existent specialty id
    When I send a POST request to /api/v1/vets
    Then the response status should be 400 or 404

  Scenario: Get all specialties
    When I send a GET request to /api/v1/specialties
    Then the response status should be 200
```

---

## Issue 4: Visit API validation
**Covers:** manual API testing, state/relationship testing (Owner → Pet → Visit), boundary analysis on dates

```gherkin
Feature: Visit API validation

  Scenario: Add visit to existing pet with valid data
    Given an existing owner and pet
    And valid visit details (date, description)
    When I send a POST request to /api/v1/owners/{ownerId}/pets/{petId}/visits
    Then the response status should be 201

  Scenario: Add visit to non-existent pet
    Given no pet exists with the given id
    When I send a POST request to /api/v1/owners/{ownerId}/pets/999999/visits
    Then the response status should be 404

  Scenario: Add visit with missing description
    Given visit details missing the "description" field
    When I send a POST request to /api/v1/owners/{ownerId}/pets/{petId}/visits
    Then the response status should be 400

  Scenario: Add visit with a future date
    Given visit details where the date is in the future
    When I send a POST request to /api/v1/owners/{ownerId}/pets/{petId}/visits
    Then note the actual behaviour (validation gap candidate)

  Scenario: Get all visits for a pet
    Given a pet with existing visits
    When I send a GET request to /api/v1/owners/{ownerId}/pets/{petId}/visits
    Then the response status should be 200
    And the response body should list all visits for that pet
```

---

## Issue 5: Database verification — Owner, Pet, Visit persistence
**Covers:** database testing, CRUD verification, referential integrity

```gherkin
Feature: Database verification

  Scenario: Created owner is persisted correctly
    Given I create an owner via POST /api/v1/owners
    When I query the owners table by the returned id
    Then the database record should match the API response fields

  Scenario: Updated owner reflects in database
    Given an existing owner
    When I update the owner via PUT /api/v1/owners/{id}
    And I query the owners table
    Then the database record should reflect the updated values

  Scenario: Deleted owner is removed from database
    Given an existing owner with no pets
    When I delete the owner via DELETE /api/v1/owners/{id}
    And I query the owners table
    Then no record should exist for that id

  Scenario: Pet is linked to correct owner in database
    Given I add a pet to an existing owner
    When I query the pets table by the pet id
    Then the owner_id foreign key should match the owner's id

  Scenario: Deleting an owner with pets is handled correctly
    Given an existing owner with at least one pet
    When I attempt to delete the owner via DELETE /api/v1/owners/{id}
    Then note whether the API blocks deletion, cascades, or errors
    And verify the actual database state afterward

  Scenario: Visit is linked to correct pet in database
    Given I add a visit to an existing pet
    When I query the visits table by the visit id
    Then the pet_id foreign key should match the pet's id
```

---

## Issue 6: Automated test suite (JUnit + REST Assured)
**Covers:** test automation, converting manual tests to repeatable automated tests, test isolation/fixtures

```gherkin
Feature: Automate core API tests

  Scenario: Automate Owner creation positive/negative tests
    Given the manual test cases from Issue 1
    When converted to REST Assured tests
    Then each test should run independently and clean up its own test data

  Scenario: Automate Pet creation positive/negative tests
    Given the manual test cases from Issue 2
    When converted to REST Assured tests
    Then each test should run independently and clean up its own test data

  Scenario: Parameterize boundary value tests
    Given the telephone length boundary scenarios
    When converted to a JUnit parameterized test
    Then all boundary values should run as a single test method with multiple inputs

  Scenario: Automated suite runs standalone via Maven
    Given the automated test classes exist
    When I run `mvn test` (or a dedicated test profile)
    Then all automated tests should execute and report pass/fail
```

*Note: this issue only makes sense once Issues 1-2 have been manually explored — automating tests you haven't designed yet just automates guesses.*

---

## Issue 7: Integration testing across layers
**Covers:** unit vs integration testing, component interaction, Testcontainers

```gherkin
Feature: Integration testing

  Scenario: Owner creation flows correctly through all layers
    Given a POST request to create an owner
    When the request passes through Controller -> Service -> Repository -> Database
    Then the final database state should match what the API returned
    And this should be verified using a real (or Testcontainers) database, not a mock

  Scenario: Invalid data is rejected before reaching the database
    Given an invalid owner payload
    When the request is processed
    Then it should fail at validation (Controller/DTO layer)
    And no record should be written to the database

  Scenario: A component passes its own unit tests but fails when integrated
    Given a scenario where mocked unit tests pass
    When the same flow is tested with real components
    Then document any mismatch between unit-test assumptions and real behaviour
```

---

## Issue 8: Regression suite
**Covers:** regression testing, smoke/sanity testing, Newman

```gherkin
Feature: Regression suite

  Scenario: Build a Postman collection covering core flows
    Given the Owner, Pet, Vet, and Visit endpoints
    When key positive and negative cases are added to one collection
    Then the collection should represent the critical paths of the application

  Scenario: Run the regression suite via Newman
    Given the Postman collection
    When executed with newman run <collection>
    Then a pass/fail report should be generated

  Scenario: Detect a regression after a code change
    Given a deliberately introduced change (e.g. removing a validation rule)
    When the regression suite is run again
    Then at least one test should fail, confirming the suite catches real regressions
```

---

## Issue 9: Performance testing
**Covers:** load/stress testing, JMeter, response time and throughput

```gherkin
Feature: Performance testing

  Scenario: Baseline response time for GET /api/v1/owners
    Given a JMeter Thread Group with 1 user
    When the request runs
    Then record the baseline response time

  Scenario: Response time under moderate load
    Given a JMeter Thread Group with 50 concurrent users
    When the request runs
    Then compare response time against the baseline
    And note any significant degradation

  Scenario: Identify the slowest endpoint
    Given Thread Groups covering Owner, Pet, and Vet GET endpoints
    When run under the same load
    Then compare results to identify the slowest endpoint

  Scenario: Behaviour under heavy/spike load
    Given a sudden increase to 200 concurrent users
    When the request runs
    Then note error rates, timeouts, or failures
```

---

## Issue 10: Security testing (basic)
**Covers:** authentication, authorization, input validation, SQL injection, XSS

```gherkin
Feature: Basic security testing

  Scenario: Access protected endpoint without authentication
    Given no authentication token
    When I send a request to a protected endpoint
    Then the response status should be 401

  Scenario: Access endpoint with invalid/expired token
    Given an invalid authentication token
    When I send a request to a protected endpoint
    Then the response status should be 401

  Scenario: Attempt SQL injection via a text field
    Given owner details where "lastName" contains a SQL injection-style payload
    When I send a POST request to /api/v1/owners
    Then the request should be rejected or safely handled
    And no unintended database behaviour should occur

  Scenario: Attempt a script-tag payload via a text field
    Given owner details where "address" contains a script tag payload
    When I send a POST request to /api/v1/owners
    Then verify the data is stored/returned safely (escaped, not executed)

  Scenario: Access another user's resource without permission (if roles exist)
    Given a user without permission to a given owner's data
    When I attempt to access it
    Then the response status should be 403
```

---

## Issue 11: CI/CD integration
**Covers:** CI pipelines, quality gates, automated execution

```gherkin
Feature: CI/CD integration

  Scenario: Automated tests run on every push
    Given a GitHub Actions workflow
    When code is pushed to the repository
    Then the automated test suite (Issue 6) should run automatically

  Scenario: Regression suite runs as part of the pipeline
    Given the Newman regression suite (Issue 8)
    When the pipeline runs
    Then it should execute after the build/unit test stage

  Scenario: Pipeline fails on test failure
    Given a test is deliberately broken
    When the pipeline runs
    Then the pipeline should report FAIL and block merge (if configured)

  Scenario: Test report is published as a pipeline artifact
    Given the test suite has run
    When the pipeline completes
    Then a test report should be available as a downloadable artifact
```

---

## Issue 12: QA documentation & bug reporting
**Covers:** test plan/strategy, traceability, bug reports, severity vs priority

```gherkin
Feature: QA documentation

  Scenario: Write the test plan
    Given the scope of this project
    When documented in test-plan/test-plan.md
    Then it should cover objectives, scope, approach, and tools used

  Scenario: Write the test strategy
    Given the testing levels covered (API, DB, automation, performance, security)
    When documented in test-plan/test-strategy.md
    Then it should explain the approach for each level

  Scenario: File a bug report for a discovered defect
    Given a defect found during any testing issue above (e.g. missing future-date validation)
    When documented in bug-reports/
    Then it should include title, environment, preconditions, steps to reproduce,
      expected result, actual result, severity, priority, and evidence

  Scenario: Distinguish severity from priority on a real bug
    Given a documented bug
    When assessed
    Then severity (technical impact) and priority (urgency to fix) should be assigned separately
```

---

## Suggested order

1. Issues 1-4 (API validation, by resource) — this is where most of your manual testing + test design technique learning happens
2. Issue 5 (DB verification) — once you're confident in the API behaviour
3. Issue 12 can run alongside everything else — file bug reports as you find issues, don't save documentation for the end
4. Issue 6 (automation) — only after 1-2 are manually explored
5. Issue 7 (integration) — natural follow-on from automation
6. Issue 8 (regression) — once you have a stable set of automated + Postman tests to bundle
7. Issue 9 & 10 (performance, security) — can run in parallel once core CRUD is well understood
8. Issue 11 (CI/CD) — last, since it wires together everything above
