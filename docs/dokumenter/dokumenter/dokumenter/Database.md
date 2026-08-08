# Larship Safety – Datamodell

## 1. Formål

Denne filen beskriver den grunnleggende datamodellen for Larship Safety.

Datamodellen skal være grunnlaget for utvikling av backend, API og frontend.

Modellen skal være:

- enkel å forstå
- utvidbar
- sporbar
- sikker
- egnet for offline-synkronisering
- egnet for flere skip
- egnet for historikk

---

# 2. Hovedstruktur

De viktigste entitetene er:

```text
Ship
Person
Role
CrewAssignment
Task
Training
Test
Certificate
Incident
Observation
Deviation
Document
Exercise
Notification
AuditLog
