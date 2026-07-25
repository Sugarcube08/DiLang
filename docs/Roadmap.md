# DiLang — Product Implementation Roadmap

**Version**: 2.1-FROZEN  
**Status**: Architecture Phase Closed — Engineering Execution Mode  

---

## Product Engineering Sequence

1. **Step 1: Design System** — Theme tokens, color palettes, typography, responsive breakpoints, navigation shell.
2. **Step 2: App Bootstrap** — Dependency injection, `DiLangRuntime` init, router setup.
3. **Step 3: SQLite Infrastructure** — Database engine, DDL migrations, repository implementations.
4. **Step 4: Identity Module** — Onboarding wizard, learner profile creation, persistence, user preferences.
5. **Step 5: AI Infrastructure** — Provider abstraction (`LlmProvider`: Local, Gemini, OpenAI, Claude, Ollama) & prompt pipeline.
6. **Step 6: Speech Infrastructure** — Hardware microphone STT & audio speaker TTS pipeline.
7. **Step 7: Learning Module** — FSRS-4.5 math engine, cognitive modeling, mission generation.
8. **Step 8: Conversation Module** — Scenario execution, turn-by-turn dialogue, replay transcripts.
9. **Step 9: Knowledge Graph Module** — Skill DAG visualizer & vocabulary web persistence.
10. **Step 10: Dashboard Module** — Data-driven TODAY home screen & WHOOP health scorecards.
11. **Step 11: Diagnostics Module** — Runtime logging, performance benchmarks, debug overlays.
