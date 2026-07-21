# 31. Pronunciation & Phonetic Pipeline Specification — DiLang

**Document Version:** 2.0.0  
**Status:** Approved / Source of Truth

---

## 1. Acoustic Phoneme Alignment Pipeline

Audio input is processed through `whisper.cpp` to extract timestamped phoneme arrays, comparing target IPA transcriptions against actual acoustic alignment scores.
