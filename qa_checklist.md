# QA Checklist Template (Traceable)

> File: `docs/qa/qa_checklist_template.md`

---

## Document Metadata

```markdown
Project: IMS
Module: Inventory & Reservations
Release Version: ****\_\_****
Test Cycle: ****\_\_****
Prepared By: ****\_\_****
Reviewed By: ****\_\_****
Date: ****\_\_****
```

---

## Traceability Legend

| Symbol | Meaning                      |
| ------ | ---------------------------- |
| ✅     | Must pass (Blocker)          |
| ⚠️     | High priority                |
| 🧪     | Covered by automated Gherkin |
| 🖐     | Manual verification required |

---

## 1. Relational Integrity & Deletion Safety

### Tenant Safety

| Check                                       | Priority | Gherkin Ref | Status | Notes |
| ------------------------------------------- | -------- | ----------- | ------ | ----- |
| Tenant with business data cannot be deleted | ✅       | `RINT-01`   | ⬜     |       |
| Tenant with only users can be deleted       | ⚠️       | `RINT-02`   | ⬜     |       |
| Tenant deletion removes users only          | ⚠️       | `RINT-02`   | ⬜     |       |
| No orphan records after tenant deletion     | ✅       | `RINT-03`   | ⬜     |       |

---

### Customer Integrity

| Check                                           | Priority | Gherkin Ref | Status | Notes |
| ----------------------------------------------- | -------- | ----------- | ------ | ----- |
| Customer deletion blocked if reservations exist | ✅       | `RINT-04`   | ⬜     |       |
| Customer cannot cross tenants                   | ✅       | `TISO-02`   | ⬜     |       |
| Risk flag count cannot go below zero            | ⚠️       | `CUST-01`   | ⬜     |       |
| Phone number format enforced                    | ⚠️       | `CUST-02`   | ⬜     |       |

---

## 2. Reservation → Item → Allocation Flow

### Reservation Items

| Check                                              | Priority | Gherkin Ref | Status | Notes |
| -------------------------------------------------- | -------- | ----------- | ------ | ----- |
| Reservation item requires valid reservation        | ✅       | `FLOW-01`   | ⬜     |       |
| Quantity must be greater than zero                 | ⚠️       | `FLOW-02`   | ⬜     |       |
| End date must be after start date                  | ⚠️       | `FLOW-03`   | ⬜     |       |
| Reservation item tenant matches reservation tenant | ✅       | `TISO-03`   | ⬜     |       |

---

### Inventory Allocations

| Check                                        | Priority | Gherkin Ref | Status | Notes |
| -------------------------------------------- | -------- | ----------- | ------ | ----- |
| Allocations created per item per day         | ✅       | `ALLOC-01`  | ⬜     |       |
| Allocation quantities match reservation item | ✅       | `ALLOC-02`  | ⬜     |       |
| Allocation date range matches reservation    | ✅       | `ALLOC-03`  | ⬜     |       |
| Allocations removed on reservation cancel    | ⚠️       | `ALLOC-04`  | ⬜     |       |
| No duplicate allocations per day             | ✅       | `ALLOC-05`  | ⬜     |       |

---

## 3. Inventory Availability & Overselling Prevention

### Availability Validation

| Check                                  | Priority | Gherkin Ref | Status | Notes |
| -------------------------------------- | -------- | ----------- | ------ | ----- |
| Availability checked per day           | ✅       | `INV-01`    | ⬜     |       |
| Allocated quantity never exceeds total | ✅       | `INV-02`    | ⬜     |       |
| Overlapping reservations aggregated    | ⚠️       | `INV-03`    | ⬜     |       |
| Partial overlaps handled correctly     | ⚠️       | `INV-04`    | ⬜     |       |

---

### Overselling Prevention

| Check                                   | Priority | Gherkin Ref | Status | Notes |
| --------------------------------------- | -------- | ----------- | ------ | ----- |
| Overselling reservation rejected        | ✅       | `INV-05`    | ⬜     |       |
| Reservation update validated            | ⚠️       | `INV-06`    | ⬜     |       |
| Allocation rollback on failure          | ✅       | `ERR-01`    | ⬜     |       |
| Concurrent reservations do not oversell | ✅       | `CONC-01`   | ⬜     |       |

---

## 4. Tenant Isolation & Data Ownership

### Data Access

| Check                               | Priority | Gherkin Ref | Status | Notes |
| ----------------------------------- | -------- | ----------- | ------ | ----- |
| Inventory access is tenant-scoped   | ✅       | `TISO-01`   | ⬜     |       |
| Customer access is tenant-scoped    | ✅       | `TISO-02`   | ⬜     |       |
| Reservation access is tenant-scoped | ✅       | `TISO-03`   | ⬜     |       |
| Allocation access is tenant-scoped  | ✅       | `TISO-04`   | ⬜     |       |
| Transaction access is tenant-scoped | ✅       | `TISO-05`   | ⬜     |       |

---

## 5. Transactions & Financial Integrity

| Check                                        | Priority | Gherkin Ref | Status | Notes |
| -------------------------------------------- | -------- | ----------- | ------ | ----- |
| Transaction amount must be positive          | ⚠️       | `TXN-01`    | ⬜     |       |
| Transactions cannot be deleted accidentally  | ✅       | `TXN-02`    | ⬜     |       |
| Transactions preserved on reservation update | ✅       | `TXN-03`    | ⬜     |       |
| Transactions are tenant-isolated             | ✅       | `TISO-05`   | ⬜     |       |

---

## 6. Error Handling & Rollback

| Check                                    | Priority | Gherkin Ref | Status | Notes |
| ---------------------------------------- | -------- | ----------- | ------ | ----- |
| Failed reservations leave no allocations | ✅       | `ERR-01`    | ⬜     |       |
| Failed updates do not corrupt data       | ✅       | `ERR-02`    | ⬜     |       |
| FK violations return meaningful errors   | ⚠️       | `ERR-03`    | ⬜     |       |

---

## 7. Release Sign-off

```markdown
All blocker checks passed: ⬜ YES / ⬜ NO
All high-priority checks passed: ⬜ YES / ⬜ NO

QA Sign-off Name: ********\_\_\_\_********
Date: **************\_\_\_**************
```

---
