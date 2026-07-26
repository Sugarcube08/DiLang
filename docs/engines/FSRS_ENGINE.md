# DiLang FSRS Engine Specification

## 1. Executive Summary

The DiLang FSRS Engine (`crates/dilang_fsrs`) implements the Free Spaced Repetition Scheduler v4 (FSRS-4.5) algorithm written natively in Rust. FSRS-v4 replaces legacy SM-2 heuristics with a mathematically optimal memory model parameterizing memory **Stability ($S$)**, **Difficulty ($D$)**, and **Retrievability ($R$)**.

---

## 2. Mathematical Formulation

### 2.1 Retrievability Equation
Retrievability represents the probability that a memory item can be successfully recalled at elapsed time $t$ (in days):

$$R(t, S) = \left(1 + \frac{t}{9 \cdot S}\right)^{-1}$$

### 2.2 Initial Stability ($S_0$) & Difficulty ($D_0$)
Upon the first review with rating $G \in \{1, 2, 3, 4\}$ (1: Again, 2: Hard, 3: Good, 4: Easy):

$$S_0(G) = w_{G-1}$$

$$D_0(G) = w_4 - (G - 3) \cdot w_5$$

Where $\mathbf{w} = [w_0, w_1, \dots, w_{18}]$ is the vector of 19 model parameters.

### 3. Difficulty Updating Equation
Upon subsequent review with rating $G$:

$$\Delta D = -w_6 \cdot (G - 3)$$

$$D' = w_7 \cdot D_0(3) + (1 - w_7) \cdot (D + \Delta D)$$

Bounded such that $D' \in [1.0, 10.0]$.

### 2.4 Stability Updating Equation

#### Success Case ($G \in \{2, 3, 4\}$):
$$S_{\text{new}} = S \cdot \left(1 + e^{w_8} \cdot (11 - D) \cdot S^{-w_9} \cdot (e^{w_{10} \cdot (1 - R)} - 1) \cdot w_{11}^{I(G=2)} \cdot w_{12}^{I(G=4)}\right)$$

Where $I(\cdot)$ is the indicator function.

#### Forget Case ($G = 1$ - Again):
$$S_{\text{new}} = w_{13} \cdot D^{-w_{14}} \cdot \left((S + 1)^{w_{15}} - 1\right) \cdot e^{w_{16} \cdot (1 - R)}$$

---

## 3. Rust Core Implementation (`dilang_fsrs`)

```rust
pub type Rating = u8; // 1 = Again, 2 = Hard, 3 = Good, 4 = Easy

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FsrsCard {
    pub card_id: i64,
    pub stability: f64,
    pub difficulty: f64,
    pub elapsed_days: u32,
    pub scheduled_days: u32,
    pub reps: u32,
    pub lapses: u32,
    pub state: CardState,
    pub last_review: i64, // Unix timestamp
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum CardState {
    New = 0,
    Learning = 1,
    Review = 2,
    Relearning = 3,
}

#[derive(Debug, Clone)]
pub struct FsrsParameters {
    pub w: [f64; 19],
    pub request_retention: f64, // Default: 0.90
    pub maximum_interval: u32,  // Default: 36500 days
}

impl FsrsParameters {
    pub fn default_v4() -> Self {
        Self {
            w: [
                0.4025, 1.1838, 3.1730, 15.6910, 7.1949, 0.5345, 1.4604, 0.0046, 1.5457,
                0.1192, 1.0192, 1.9395, 0.1100, 0.2960, 2.2698, 0.2315, 2.9898, 0.5165, 0.6621,
            ],
            request_retention: 0.90,
            maximum_interval: 36500,
        }
    }
}
```

---

## 4. Next Interval Calculation Function

```rust
pub fn calculate_next_interval(stability: f64, request_retention: f64) -> u32 {
    let interval = stability * 9.0 * (1.0 / request_retention - 1.0);
    interval.round().max(1.0) as u32
}
```

---

## 5. Offline Weight Optimization Engine

The FSRS Engine includes a local gradient descent optimizer using log-loss objective minimization:

$$L(\mathbf{w}) = -\frac{1}{N} \sum_{i=1}^{N} \left[ y_i \ln R_i + (1 - y_i) \ln (1 - R_i) \right]$$

Where $y_i \in \{0, 1\}$ is the actual recall outcome. Training runs in background threads without interfering with UI rendering.
