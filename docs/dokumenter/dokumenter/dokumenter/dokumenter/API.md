# Larship Safety – API-spesifikasjon

## 1. Formål

Dette dokumentet beskriver API-prinsippene for Larship Safety.

API-et skal være forbindelsen mellom:

- frontend
- mobilklient
- backend
- database
- offline-synkronisering
- AI-tjenester

API-et skal være sikkert, forutsigbart og versjonert.

---

# 2. Hovedprinsipp

Frontend skal ikke kommunisere direkte med databasen.

Arbeidsflyten skal være:

```text
Bruker
  ↓
Frontend
  ↓
API
  ↓
Backend
  ↓
Database
