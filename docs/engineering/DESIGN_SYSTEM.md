# DiLang Design System Specification

## 1. Design Tokens Reference

### Spacing System (8-Point)
`4px, 8px, 12px, 16px, 20px, 24px, 32px, 40px, 48px, 64px`

### Icon Sizes
- Small: `16px`
- Standard: `20px` / `24px`
- Large: `28px` / `32px`

### Touch Target
- Minimum interactive footprint: `48px x 48px`

### Corner Radii
- Small: `8px` (Chips, Input fields, Tooltips)
- Medium: `14px` (Cards, Buttons, List Items)
- Large: `20px` (Modals, Large Cards)
- Floating: `28px` (Floating Action Bars, Player Pill)

### Glassmorphism Rules
- **Blur Radius**: `20px` to `24px`
- **Fill Opacity**: `55%` (`rgba(24, 28, 35, 0.55)` in dark theme, `rgba(255, 255, 255, 0.55)` in light theme)
- **Border**: `1px` stroke with `12%` white opacity (`rgba(255, 255, 255, 0.12)`)
- **Usage**: Restricted to Cards, Floating Panels, Bottom Player, AI Assistant, and Dialogs. Never applied to full pages.

### Motion & Micro-Animations
- **Durations**: `150ms` (hover/tap), `250ms` (transitions), `350ms` (modals/drawers)
- **Easing Curve**: `easeOutCubic` (`Cubic(0.215, 0.61, 0.355, 1.0)`)
