# 17. Storage Architecture & Persistence Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Storage Infrastructure

---

## 1. Storage Architecture & Decoupling

DiLang enforces strict separation between **Storage Contracts** (abstract interfaces owned by domain packages) and **Storage Infrastructure** (concrete Drift SQLite, encryption, and local disk persistence).

```
 +-------------------------------------------------------------------------+
 |                            DOMAIN LAYER                                 |
 |  LearnerGraph | LexicalUnit | FSRS Memory | GrammarRules | DomainEvents |
 +------------------------------------+------------------------------------+
                                      | Depends ONLY on Contracts
                                      v
 +-------------------------------------------------------------------------+
 |                         STORAGE CONTRACTS                               |
 |  LearnerRepository | VocabularyRepository | EventStoreRepository        |
 +------------------------------------+------------------------------------+
                                      ^ Implemented By
                                      |
 +-------------------------------------------------------------------------+
 |                       STORAGE INFRASTRUCTURE                            |
 | Drift SQLite Database | WAL Journal | SQLCipher Encryption | Backup Engine|
 +-------------------------------------------------------------------------+
```

Domain models never import database drivers, SQL statements, or ORM dependencies directly.

---

## 2. Performance SLAs & Metrics

| Operation | Target SLA | Benchmark Metric |
| :--- | :--- | :--- |
| **Database Connection Boot** | `< 40 ms` | WAL mode initialization timing |
| **Single Event Append** | `< 2 ms` | Transaction commit latency |
| **Batch Event Read (1000 events)** | `< 15 ms` | Stream fetch benchmark |
| **Vocabulary Query by Lemma** | `< 1 ms` | Indexed B-tree lookup |
| **Full Snapshot Creation** | `< 100 ms` | Database dump & checksum calculation |

---

## 3. Local Encryption & Security

- **Storage At Rest**: SQLCipher 256-bit AES database encryption.
- **Key Management**: Hardware KeyStore (Android Keystore / iOS Keychain / OS Secret Service) storing local DB encryption keys.
- **Data Integrity**: SHA-256 integrity checksum appended to all local database snapshot exports.
