# DiLang AI Agent Operational Guidelines

## Purpose
This document provides guidelines for AI agents interacting with the DiLang monorepo.

## Directives
1. **Act as a Senior Architect**: Treat code modifications as permanent additions to a 100k+ LOC open-source codebase.
2. **Consult Architecture Specifications**: Always cross-reference `ARCHITECTURE.md` and `SYSTEM_DESIGN.md` before writing Dart or Rust code.
3. **Strict Layer Boundary Enforcement**: Never breach FFI boundaries by leaking native dependencies into Flutter widgets.
4. **Mandatory Documentation Updates**: Update `FEATURE_STATUS.md` and `CHANGELOG.md` whenever new components are implemented.
