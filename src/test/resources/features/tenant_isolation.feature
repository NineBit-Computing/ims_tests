@tenant_isolation
Feature: Tenant data isolation
  Ensures tenants can only access their own inventory

  Background:
    * url baseUrl
    * def tenantA = tenants.tenantA
    * def tenantB = tenants.tenantB

    # 🔹 Call global reusable setup ONCE
    * def setup = callonce read('classpath:features/setup/tenant_test_data.feature')
    * def tenantData = setup.tenantData

    # 🔹 Pick one inventory per tenant from setup data
    * def tenantAItemId = tenantData.tenantA.inventories[0]
    * def tenantBItemId = tenantData.tenantB.inventories[0]

  @TISO-01
  Scenario: Prevent cross-tenant inventory access

    * print 'Tenant A inventory ID:', tenantAItemId
    * print 'Tenant B inventory ID:', tenantBItemId

    # --- Fetch inventory as Tenant A ---
    Given path 'tenants', 'inventory'
    And header X-Tenant-ID = tenantA.id
    When method GET
    Then status 200

    # Assertions for Tenant A: only their items
    And match each response[*].tenant_id == tenantA.id
    And match response[*].item_id contains tenantAItemId
    And match response[*].item_id !contains tenantBItemId

    # --- Fetch inventory as Tenant B ---
    Given path 'tenants', 'inventory'
    And header X-Tenant-ID = tenantB.id
    When method GET
    Then status 200

    # Assertions for Tenant B: only their items
    And match each response[*].tenant_id == tenantB.id
    And match response[*].item_id contains tenantBItemId
    And match response[*].item_id !contains tenantAItemId

@TISO-02
Scenario: Prevent cross-tenant customer usage

  # 🔹 Reuse global setup data
  * def tenantBCustomerId = tenantData.tenantB.customers[0]
  * def tenantAItemId = tenantData.tenantA.inventories[0]

  * print 'Tenant B customer:', tenantBCustomerId
  * print 'Tenant A inventory:', tenantAItemId

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

  * print 'Reservation attempt correctly rejected for cross-tenant customer'


@TISO-03
Scenario: Prevent cross-tenant reservation item creation

  # 🔹 Reuse global setup data (Tenant A)
  * def tenantAInventoryId = tenantData.tenantA.inventories[0]
  * def tenantAReservationId = tenantData.tenantA.reservations[0]

  * print 'Tenant A inventory:', tenantAInventoryId
  * print 'Tenant A reservation:', tenantAReservationId

  # ❌ Tenant B tries to add item to Tenant A reservation
  Given path 'reservation-items', 'add-to-reservation', tenantAReservationId
  And header x-tenant-id = tenantB.id
  And request
    """
    [
      {
        "item_id": "#(tenantAInventoryId)",
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

  * print 'Cross-tenant reservation item creation correctly blocked'

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

