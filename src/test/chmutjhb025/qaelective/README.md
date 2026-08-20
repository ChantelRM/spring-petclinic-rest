# PetClinic QA Project — Learning Objectives & Structure

## verification code 
WTC-5ZVLKCH3 

## Learning Objectives

By the end of this project, I should be comfortable with:

- Understanding an existing software system (Spring Boot, REST APIs, HTTP methods, status codes, JSON)
- Reading API documentation and explaining what an endpoint does, expects, and returns
- Manual API testing — positive testing, negative testing, input validation
- Using Postman (collections, requests, environments, variables, assertions, scripts)
- Designing test cases systematically:
  - Equivalence partitioning
  - Boundary value analysis
  - Decision tables
  - State transition testing
  - Pairwise testing
- Database testing — verifying that API actions are correctly persisted (SELECT, INSERT, UPDATE, DELETE, JOINs, referential integrity)
- Test automation with JUnit (assertions, setup/teardown, parameterized tests) and REST Assured (Given/When/Then)
- Integration testing — testing how components (Controller → Service → Repository → Database) work together, not just in isolation
- Regression testing — building a suite that confirms old functionality still works after changes, and running it with Newman
- Performance testing with JMeter (load, stress, spike, endurance testing; response time, throughput, bottlenecks)
- Security testing basics — authentication, authorization, role-based access, SQL injection, XSS
- CI/CD testing — understanding how automated tests fit into a pipeline (build → test → report → pass/fail)
- QA documentation — test plans, test strategy, traceability, risk analysis
- Writing clear bug reports (steps to reproduce, expected vs actual result, severity vs priority, evidence)
- Investigating test failures, not just reporting them

**Overall aim:** Take an existing system, understand its behaviour, design meaningful tests, automate the right ones, verify data, evaluate performance and security, and communicate defects clearly.

---

## Suggested Project Structure

```text
petclinic-qa/
│
├── test-plan/
│   ├── test-plan.md
│   ├── test-strategy.md
│   └── risk-analysis.md
│
├── manual-tests/
│   └── test-cases.md
│
├── api-tests/
│   └── postman/
│
├── automated-tests/
│   ├── unit/
│   ├── integration/
│   └── api/
│
├── database-tests/
│   └── sql/
│
├── performance-tests/
│   └── jmeter/
│
├── security-tests/
│   └── findings.md
│
├── bug-reports/
│   └── ...
│
└── reports/
    └── ...
```

This structure keeps the QA work separate from the PetClinic application code itself, and can evolve as the project develops.
