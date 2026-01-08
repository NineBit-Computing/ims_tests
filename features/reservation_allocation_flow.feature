@reservation_flow
Feature: Reservation to inventory allocation flow
  Ensures reservation intent is correctly translated into daily inventory allocations.

  @FLOW-01
  Scenario: Reservation item requires a valid reservation
    Given no reservation exists
    When a reservation item is created
    Then the operation must be rejected

  @FLOW-02
  Scenario: Reservation item quantity must be greater than zero
    Given a reservation exists
    When a reservation item is created with quantity zero or less
    Then the operation must be rejected

  @FLOW-03
  Scenario: Reservation item end date must be after start date
    Given a reservation exists
    When a reservation item is created with an end date before the start date
    Then the operation must be rejected

  @ALLOC-01
  Scenario: Create daily inventory allocations from reservation item
    Given an inventory item exists with sufficient quantity
    And a reservation exists
    When a reservation item is created with quantity 3 from January 10 to January 12
    Then inventory allocations must be created for January 10 with quantity 3
    And inventory allocations must be created for January 11 with quantity 3
    And inventory allocations must be created for January 12 with quantity 3

  @ALLOC-02
  Scenario: Aggregate allocations for overlapping reservation items
    Given two reservation items exist for the same inventory item with overlapping dates
    When inventory allocations are calculated
    Then allocations must be aggregated per item per day

  @ALLOC-03
  Scenario: Update reservation item date range updates allocations
    Given a reservation item exists with inventory allocations
    When the reservation item date range is updated
    Then old inventory allocations must be removed
    And new inventory allocations must be created

  @ALLOC-04
  Scenario: Cancel reservation removes allocations
    Given a reservation exists with active inventory allocations
    When the reservation is cancelled
    Then all inventory allocations for the reservation must be removed

  @ALLOC-05
  Scenario: Prevent duplicate inventory allocations
    Given inventory allocations already exist for an item on a date
    When allocation generation runs again
    Then no duplicate allocations must be created
