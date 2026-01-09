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

  @TISO-02
  Scenario: Prevent cross-tenant customer usage

    # --- Create a customer for Tenant B ---
    Given path 'customers'
    And header X-Tenant-ID = tenantB.id
    And request
      """
      {
        "name": "Customer B1",
        "phone": "9876543210",
        "address": "Indore"
      }
      """
    When method POST
    Then status 201
    * def tenantBCustomerId = response.customer_id
    * print 'Tenant B customer created:', tenantBCustomerId

    # --- Attempt a reservation on Tenant A's inventory using Tenant B's customer ---
    Given path 'reservations'
    And header X-Tenant-ID = tenantA.id
    And request

      """
      {
        "customer_id": "#(tenantBCustomerId)",
        "inventory_id": "#(tenantAItemId)",
        "start_date": "2026-01-10",
        "end_date": "2026-01-12"
      }
      """
    When method POST
    Then status 400
    * print 'Reservation attempt rejected for cross-tenant customer'


  @TISO-03
  Scenario: Prevent cross-tenant reservation item creation

    # Tenant A creates INVENTORY
    Given path 'inventory'
    And header x-tenant-id = tenantA.id
    And request
      """
      {
        "name": "Camera",
        "category": "electronics",
        "total_quantity": 10,
        "cost_per_unit": 5000,
        "rental_price": 800,
        "security_deposit": 2000
      }
      """
    When method POST
    Then status 201
    * def inventoryId = response.item_id
    * print 'Inventory created by Tenant A:', inventoryId

    # Tenant A creates CUSTOMER
    Given path 'customers'
    And header x-tenant-id = tenantA.id
    And request
      """
      {
        "name": "Tenant A Customer",
        "phone": "9999999999",
        "address": "Indore"
      }
      """
    When method POST
    Then status 201
    * def customerId = response.customer_id
    * print 'Customer created by Tenant A:', customerId

    # Tenant A creates RESERVATION
    Given path 'reservations'
    And header x-tenant-id = tenantA.id
    And request
      """
      {
        "customer_id": "#(customerId)"
      }
      """
    When method POST
    Then status 201
    * def reservationId = response.reservation_id
    * print 'Reservation created by Tenant A:', reservationId

    # Tenant B tries to add item to Tenant A reservation ❌
    Given path 'reservation-items', 'add-to-reservation', reservationId
    And header x-tenant-id = tenantB.id
    And request
      """
      [
        {
          "item_id": "#(inventoryId)",
          "quantity": 2,
          "start_date": "2026-01-13",
          "end_date": "2026-01-15",
          "accrued_payable_amt": 1600
        }
      ]
      """
    When method POST
    Then status 400
    And match response.error contains 'Reservation not found'


  @TISO-05
  Scenario: Restrict transaction visibility by tenant

    # --- Fetch transactions as Tenant A ---
    Given path 'tenants', 'transactions'
    And header X-Tenant-ID = tenantA.id
    When method GET
    Then status 200
    * print 'Tenant A transactions:', response
    And match each response[*].tenant_id == tenantA.id


    # --- Fetch transactions as Tenant B ---
    Given path 'tenants', 'transactions'
    And header X-Tenant-ID = tenantB.id
    When method GET
    Then status 200
    * print 'Tenant B transactions:', response
    And match each response[*].tenant_id == tenantB.id

