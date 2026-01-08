@relational_integrity
Feature: Relational integrity and deletion safety
  Ensures critical business data cannot be deleted accidentally.

  @RINT-01
  Scenario: Prevent deletion of tenant with business data
    Given a tenant exists with customers, inventory items, reservations, and transactions
    When an attempt is made to delete the tenant
    Then the deletion must be rejected
    And an error indicating existing dependent records must be returned

  @RINT-02
  Scenario: Allow deletion of tenant with only users
    Given a tenant exists with users but no business data
    When the tenant is deleted
    Then the tenant must be deleted successfully
    And all users belonging to the tenant must be deleted

  @RINT-03
  Scenario: Prevent orphan records after tenant deletion
    Given a tenant deletion is attempted
    Then no orphan records must exist in any table

  @RINT-04
  Scenario: Prevent deletion of customer with reservations
    Given a customer exists with one or more reservations
    When an attempt is made to delete the customer
    Then the deletion must be rejected
    And the customer record must remain unchanged
