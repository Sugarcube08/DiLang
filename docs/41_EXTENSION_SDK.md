# 41. Extension SDK & Plugin Marketplace Specification — DiLang

**Document Version:** 2.0.0  
**Status:** Approved / Source of Truth — Platform Extension SDK

---

## 1. Extension SDK Overview

The **Extension SDK** defines how third-party developers, researchers, and institutions contribute new language packs, AI models, custom exercise widgets, and assessment rules to DiLang through stable public interfaces.

```
 +-------------------------------------------------------------------------+
 |                           EXTENSION SDK APIs                            |
 |  LanguagePackContract | ModelPackContract | CurriculumPackContract      |
 +------------------------------------+------------------------------------+
                                      |
                                      v
 +-------------------------------------------------------------------------+
 |                            PLUGIN HOST                                  |
 |  PluginHostContract -> CapabilityRegistry -> SystemBootstrapper         |
 +-------------------------------------------------------------------------+
```
