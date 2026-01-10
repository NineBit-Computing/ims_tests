Feature: Create reusable tenant test data
 
Background:
  * url baseUrl
  * def tenantA = tenants.tenantA
  * def tenantB = tenants.tenantB
 
Scenario: Create minimal tenant data
 
  ###########################
  # INVENTORIES
  ###########################
 
  # Inventory A1
  Given path 'inventory'
  And header X-Tenant-ID = tenantA.id
  And request
  """
  {
    "name": "Mobile Phone A1",
    "category": "electronics",
    "total_quantity": 10,
    "cost_per_unit": 5000,
    "rental_price": 500,
    "security_deposit": 1000
  }
  """
  When method POST
  Then status 201
  * def inventoryA1 = response.item_id
  * print 'Created inventory for Tenant A: ' + inventoryA1
 
  # Inventory A2
  Given path 'inventory'
  And header X-Tenant-ID = tenantA.id
  And request
  """
  {
    "name": "Laptop A2",
    "category": "electronics",
    "total_quantity": 7,
    "cost_per_unit": 7000,
    "rental_price": 800,
    "security_deposit": 1500
  }
  """
  When method POST
  Then status 201
  * def inventoryA2 = response.item_id
  * print 'Created inventory for Tenant A: ' + inventoryA2
 
  # Inventory B1
  Given path 'inventory'
  And header X-Tenant-ID = tenantB.id
  And request
  """
  {
    "name": "Mobile Phone B1",
    "category": "electronics",
    "total_quantity": 5,
    "cost_per_unit": 4000,
    "rental_price": 400,
    "security_deposit": 800
  }
  """
  When method POST
  Then status 201
  * def inventoryB1 = response.item_id
  * print 'Created inventory for Tenant B: ' + inventoryB1
 
  # Inventory B2
  Given path 'inventory'
  And header X-Tenant-ID = tenantB.id
  And request
  """
  {
    "name": "Tablet B2",
    "category": "electronics",
    "total_quantity": 3,
    "cost_per_unit": 6000,
    "rental_price": 600,
    "security_deposit": 1200
  }
  """
  When method POST
  Then status 201
  * def inventoryB2 = response.item_id
  * print 'Created inventory for Tenant B: ' + inventoryB2
 
  ###########################
  # CUSTOMERS
  ###########################
 
  # Customer for Tenant A
  Given path 'customers'
  And header X-Tenant-ID = tenantA.id
  And request
  """
  {
    "name": "Customer A1",
    "phone": "9999991111",
    "address": "Indore"
  }
  """
  When method POST
  Then status 201
  * def customerA1 = response.customer_id
  * print 'Created customer for Tenant A: ' + customerA1
 
  # Customer for Tenant B
  Given path 'customers'
  And header X-Tenant-ID = tenantB.id
  And request
  """
  {
    "name": "Customer B1",
    "phone": "9999992222",
    "address": "Mumbai"
  }
  """
  When method POST
  Then status 201
  * def customerB1 = response.customer_id
  * print 'Created customer for Tenant B: ' + customerB1
 
  ###########################
  # RESERVATIONS
  ###########################
 
  # Reservation for Tenant A
  Given path 'reservations'
  And header X-Tenant-ID = tenantA.id
  And request
  """
  {
    "customer_id": "#(customerA1)",
    "inventory_id": "#(inventoryA1)"
  }
  """
  When method POST
  Then status 201
  * def reservationA1 = response.reservation_id
  * print 'Created reservation for Tenant A: ' + reservationA1
 
  # Reservation for Tenant B
  Given path 'reservations'
  And header X-Tenant-ID = tenantB.id
  And request
  """
  {
    "customer_id": "#(customerB1)",
    "inventory_id": "#(inventoryB1)"
  }
  """
  When method POST
  Then status 201
  * def reservationB1 = response.reservation_id
  * print 'Created reservation for Tenant B: ' + reservationB1
 
  ###########################
  # TRANSACTIONS (Tenant A example)
  ###########################
 
  # Transaction 1
  Given path 'transactions'
  And header X-Tenant-ID = tenantA.id
  And request
  """
  {
    "tenant_id": "#(tenantA.id)",
    "customer_id": "#(customerA1)",
    "reservation_id": "#(reservationA1)",
    "amount": 9000,
    "payment_date": "2025-12-18"
  }
  """
  When method POST
  Then status 201
  * def transactionA1 = response
  * print 'Created transaction for Tenant A: ' + transactionA1
 
  # Transaction 2
  Given path 'transactions'
  And header X-Tenant-ID = tenantA.id
  And request
  """
  {
    "tenant_id": "#(tenantA.id)",
    "customer_id": "#(customerA1)",
    "reservation_id": "#(reservationA1)",
    "amount": 5000,
    "payment_date": "2025-12-19"
  }
  """
  When method POST
  Then status 201
  * def transactionA2 = response
  * print 'Created transaction for Tenant A: ' + transactionA2
 
  ###########################
  # DATA OBJECT
  ###########################
 
  * def tenantData =
  """
  {
    "tenantA": {
      "inventories": ["#(inventoryA1)", "#(inventoryA2)"],
      "customers": ["#(customerA1)"],
      "reservations": ["#(reservationA1)"],
      "transactions": ["#(transactionA1)", "#(transactionA2)"]
    },
    "tenantB": {
      "inventories": ["#(inventoryB1)", "#(inventoryB2)"],
      "customers": ["#(customerB1)"],
      "reservations": ["#(reservationB1)"]
    }
  }
  """
  * print 'All tenant data:', tenantData