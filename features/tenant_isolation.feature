@tenant_isolation
Feature: Tenant data isolation
  Ensures tenants can only access and operate on their own data.

  @TISO-01
  Scenario: Prevent cross-tenant inventory access
    Given inventory items exist for multiple tenants
    When a tenant requests inventory items
    Then only inventory items belonging to that tenant must be returned

  @TISO-02
  Scenario: Prevent cross-tenant customer usage
    Given a customer belongs to another tenant
    When a reservation is attempted using that customer
    Then the operation must be rejected

  @TISO-03
  Scenario: Prevent cross-tenant reservation item creation
    Given a reservation belongs to another tenant
    When a reservation item is created
    Then the operation must be rejected

  @TISO-04
  Scenario: Restrict allocation visibility by tenant
    Given inventory allocations exist for multiple tenants
    When allocations are queried
    Then only allocations for the current tenant must be returned

  @TISO-05
  Scenario: Restrict transaction visibility by tenant
    Given transactions exist for multiple tenants
    When transactions are queried
    Then only transactions for the current tenant must be returned
