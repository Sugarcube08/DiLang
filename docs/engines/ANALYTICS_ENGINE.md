# DiLang Analytics Engine Specification

## 1. Executive Summary

The DiLang Analytics Engine (`dilang_analytics`) collects, processes, and presents user learning metrics, retention curves, speech fluency velocities, and cognitive load indicators. In strict accordance with DiLang's Zero-Telemetry philosophy, all analytics calculation and database storage occur locally on the user's device.

---

## 2. Privacy-Preserving Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 Local System Activity Logs                  │
└──────┬──────────────────────┬───────────────────────┬───────┘
       │                      │                       │
       ▼                      ▼                       ▼
┌──────────────┐      ┌──────────────┐      ┌──────────────────┐
│  FSRS Logs   │      │ Speech Logs  │      │  Curriculum Logs │
└──────┬───────┘      └──────┬───────┘      └────────┬─────────┘
       │                      │                      │
       └──────────────┬───────┴──────────────────────┘
                      ▼
       ┌──────────────────────────────┐
       │ In-Memory Aggregator (Rust)  │
       └──────────────┬───────────────┘
                      ▼
       ┌──────────────────────────────┐
       │ Local SQLite Analytics Store │
       └──────────────┬───────────────┘
                      ▼
       ┌──────────────────────────────┐
       │ Flutter UI Data Providers    │
       └──────────────────────────────┘
```

---

## 3. Core Metric Calculations

### 3.1 Speech Fluency Velocity ($V_{\text{speech}}$)
Tracks user articulation speed in words per minute (WPM) excluding unfilled pauses:

$$V_{\text{speech}} = \frac{\text{Total Tokens Spoken}}{\text{Audio Duration Seconds} - \text{Pause Duration Seconds}} \times 60$$

### 3.2 Target Retention Rate ($R_{\text{target}}$)
Aggregates expected retrievability across active FSRS cards:

$$\bar{R} = \frac{1}{N} \sum_{i=1}^{N} \left(1 + \frac{t_i}{9 \cdot S_i}\right)^{-1}$$

Where $N$ is the total active card count, $t_i$ is elapsed days since last review, and $S_i$ is stability.

### 3.3 Hesitation Index ($H$)
Measures cognitive load during spoken output based on silent pauses ($>400\text{ms}$) per minute.

---

## 4. SQLite Analytics Schema (`dilang_sqlite`)

```sql
CREATE TABLE IF NOT EXISTS daily_analytics (
    date TEXT PRIMARY KEY, -- ISO 8601 YYYY-MM-DD
    total_review_count INTEGER NOT NULL DEFAULT 0,
    time_spent_seconds INTEGER NOT NULL DEFAULT 0,
    mean_retention REAL NOT NULL DEFAULT 0.0,
    speech_wpm REAL NOT NULL DEFAULT 0.0,
    error_count_grammar INTEGER NOT NULL DEFAULT 0,
    error_count_vocab INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS skill_retention_snapshots (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp INTEGER NOT NULL, -- Unix epoch
    cefr_level TEXT NOT NULL,
    estimated_vocabulary_size INTEGER NOT NULL,
    active_grammar_rules INTEGER NOT NULL
);
```

---

## 5. Local Differential Privacy Aggregation

If a user explicitly chooses to export anonymized statistics for self-analysis or device migration, the engine applies Laplacian noise injection:

$$\tilde{X} = X + \text{Laplace}\left(0, \frac{\Delta f}{\epsilon}\right)$$

Ensuring individual session records cannot be reconstructed.
