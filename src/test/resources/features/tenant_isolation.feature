@tenant_isolation
Feature: Tenant data isolation
  Ensures tenants can only access their own inventory

  Background:
    * url baseUrl
    * def tenantA = tenants.tenantA
    * def tenantB = tenants.tenantB

  @TISO-01
  Scenario: Prevent cross-tenant inventory access

    * print 'Hello from Karate'

    # --- Create inventory for Tenant A ---
    Given path 'inventory'
    And header X-Tenant-ID = tenantA.id
    And request
      """
      {
        "name": "Headphones A",
        "category": "electronics",
        "total_quantity": 100,
        "cost_per_unit": 1000,
        "rental_price": 200,
        "security_deposit": 500
      }
      """
    When method POST
    Then status 201
    * def tenantAItemId = response.item_id
    * print 'Tenant A inventory created:', tenantAItemId

    # --- Create inventory for Tenant B ---
    Given path 'inventory'
    And header X-Tenant-ID = tenantB.id
    And request
      """
      {
        "name": "Headphones B",
        "category": "electronics",
        "total_quantity": 50,
        "cost_per_unit": 1200,
        "rental_price": 250,
        "security_deposit": 600
      }
      """
    When method POST
    Then status 201
    * def tenantBItemId = response.item_id
    * print 'Tenant B inventory created:', tenantBItemId

    # --- Fetch inventory as Tenant A ---
    Given path 'tenants', 'inventory'
    And header X-Tenant-ID = tenantA.id
    When method GET
    Then status 200
    * print 'Tenant A inventory list:', response

    # Assertions for Tenant A: only their items
    And match each response[*].tenant_id == tenantA.id
    And match response[*].item_id contains tenantAItemId
    And match response[*].item_id !contains tenantBItemId

    # --- Fetch inventory as Tenant B ---
    Given path 'tenants', 'inventory'
    And header X-Tenant-ID = tenantB.id
    When method GET
    Then status 200
    * print 'Tenant B inventory list:', response

    # Assertions for Tenant B: only their items
    And match each response[*].tenant_id == tenantB.id
    And match response[*].item_id contains tenantBItemId
    And match response[*].item_id !contains tenantAItemId
