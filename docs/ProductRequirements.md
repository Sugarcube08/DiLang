# DiLang — Product Requirements Document (PRD)

**Version**: 2.0-RESET  
**Status**: Authoritative  

---

## 1. Primary User Experiences

### 1.1 First Time User Experience (FTUE) Onboarding
- **Learner Identity Setup**: Prompts for learner display name, medium interface language, and target language.
- **Cognitive Strategy Selection**: Configures initial brain model (Conversation First, Grammar First, Vocabulary First, Visual Graph).
- **Target Goals & Persona**: Selects daily goal minutes (e.g., 15 mins) and AI Coach persona (Friendly, Strict, Socratic).
- **Zero Jargon**: Clean setup wizard experience without complex setup terminology.

### 1.2 TODAY Dashboard
- **Welcome & Streak**: Displays active streak counter, completed sessions count, and personalized greeting.
- **Scorecard**: Displays overall language health score, vocabulary retrievability (FSRS), grammar accuracy, and recall stability.
- **Primary Daily Mission**: Single actionable daily scenario recommendation (e.g., "Ordering at a Viennese Café").
- **Coaching Insight**: Actionable feedback derived from recent error cause analysis.

### 1.3 Voice AI Dialogue
- **Interactive Scenarios**: Scenario execution (e.g., Cafe Vienna, Doctor Appointment).
- **Pre-Session Briefing**: Target grammar focus and cultural tips prior to starting.
- **Live Turn Evaluation**: Instant feedback on grammar correctness, corrected response, and phonetic score.
- **Post-Session Debriefing**: Speaking confidence progression tracking and automatic replay persistence to SQLite.

### 1.4 Universal Knowledge Graph
- **Skill DAG**: Interactive visualization of learned nodes (lemmas, grammar rules, phrases) organized by CEFR levels (A1 - C2).
- **Vocabulary Web**: Real-time FSRS retrievability and decay indicator per word node.

### 1.5 Language Health & Settings
- **Cognitive Metrics**: Detailed breakdown of vocabulary mastery, grammar accuracy, listening comprehension, and reading fluency.
- **Profile & Target Language Switching**: Seamlessly update target language and refresh skill graphs.
- **System Operations**: Soft logout and complete SQLite Factory Reset option.
