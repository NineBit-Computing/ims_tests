@error_handling
Feature: Error handling and rollback safety
  Ensures system consistency during failures.

  @ERR-01
  Scenario: Failed reservation leaves no allocations
    Given inventory availability is insufficient
    When a reservation attempt fails
    Then no inventory allocations must be created

  @ERR-02
  Scenario: Failed update does not corrupt allocations
    Given a reservation exists
    When an invalid update is attempted
    Then existing allocations must remain unchanged

  @ERR-03
  Scenario: Foreign key violations return meaningful errors
    Given an operation violates a foreign key constraint
    When the operation is attempted
    Then a meaningful error must be returned
