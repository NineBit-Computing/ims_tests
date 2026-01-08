@inventory
Feature: Inventory availability and overselling prevention
  Ensures inventory is never oversold under any condition.

  @INV-01
  Scenario: Validate availability per day
    Given inventory availability varies by date
    When a reservation is evaluated
    Then availability must be checked for each individual date

  @INV-02
  Scenario: Prevent total allocated quantity exceedingch from exceeding inventory
    Given an inventory item has a total quantity of 10
    And existing allocations total 10 units on a date
    When another reservation is attempted on that date
    Then the reservation must be rejected

  @INV-03
  Scenario: Aggregate overlapping reservations correctly
    Given overlapping reservations exist
    When inventory availability is calculated
    Then allocated quantities must be aggregated correctly

  @INV-04
  Scenario: Handle partial date overlaps correctly
    Given reservations overlap on some but not all dates
    When availability is checked
    Then only overlapping dates must be validated

  @INV-05
  Scenario: Prevent overselling
    Given existing allocations nearly exhaust inventory
    When a reservation exceeds available quantity
    Then the reservation must be rejected
    And no allocations must be created

  @INV-06
  Scenario: Prevent overselling during reservation update
    Given inventory is fully allocated on a date
    When a reservation quantity is increased
    Then the update must be rejected
