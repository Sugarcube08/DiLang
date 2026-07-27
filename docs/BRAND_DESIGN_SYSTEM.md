# DiLang Brand Asset Design System

## Master Creative & Production Specification

### 1. Mascot Identity & Character Design
* **Name**: Pixel the DiLang Toucan
* **Species Concept**: Original stylized Budgerigar (Toucan)
* **Personality**: Curious, Intelligent, Friendly, Helpful, Confident, Calm, Cheerful, Expressive, Multilingual, Educational.
* **Design Philosophy**:
  - Soft rounded geometry (pear body, rounded capsule wings, smooth teardrop tail).
  - Material appearance of soft matte polymer clay / resin figurine.
  - Smooth top-left lighting gradients, gentle ambient shadows, no sharp corners or thin lines.

---

### 2. Palette & Design Tokens

| Token Name | Hex Code | Visual Application |
|---|---|---|
| **Fresh Emerald** | `#10B981` | Mascot primary body & wing gradient |
| **Mint Green** | `#34D399` | Body highlight & crown accent |
| **Lime Accent** | `#84CC16` | Wing tips & tail accent feathers |
| **Warm Yellow** | `#FBBF24` / `#F59E0B` | Badges, XP stars & achievements |
| **Coral Orange** | `#F97316` / `#FB923C` | Beak & feet gradient |
| **Dark Navy** | `#0F172A` | Expressive eyes, eyebrows & dark backgrounds |
| **Soft Pink/Rose** | `#FB7185` | Cheek blushes |
| **Warm White** | `#F8FAFC` / `#ECFDF5` | Soft belly patch & light backgrounds |

---

### 3. SVG Group Construction Standards (`<g>`)
Every mascot asset adheres to clean, semantic SVG grouping for direct animation support in Flutter (`flutter_svg`), Rive, or Lottie:

```xml
<g id="Mascot">
  <g id="Shadow"><!-- Ambient drop shadow --></g>
  <g id="Feet"><!-- Left & Right rounded feet --></g>
  <g id="Tail"><!-- 3 layered feather shapes --></g>
  <g id="Body">
    <path id="PearBody" .../>
    <path id="BellyPatch" .../>
  </g>
  <g id="LeftWing"><!-- Layered wing paths --></g>
  <g id="RightWing"><!-- Layered wing paths --></g>
  <g id="Head">
    <path id="HeadBase" .../>
    <path id="CrownCap" .../>
    <ellipse id="CheekLeft" .../>
    <ellipse id="CheekRight" .../>
  </g>
  <g id="Face">
    <g id="Eyebrows"><!-- Responsive eyebrows --></g>
    <g id="Eyes">
      <g id="LeftEye"><!-- Dark eye + double catchlight --></g>
      <g id="RightEye"><!-- Dark eye + double catchlight --></g>
    </g>
    <g id="Beak"><!-- Coral gradient beak --></g>
  </g>
</g>
```

---

### 4. Generated Brand Asset Directory Structure

```
assets/
├── illustrations/
│   ├── brand_banner.svg            (1200x630 GitHub / Web / Store Hero)
│   ├── ai_tutor.svg                (AI Tutor with headset & halo)
│   ├── toucan_expressions_grid.svg (Master 12-expression catalog)
│   └── expressions/
│       ├── toucan_happy.svg
│       ├── toucan_thinking.svg
│       ├── toucan_speaking.svg
│       ├── toucan_listening.svg
│       ├── toucan_surprised.svg
│       ├── toucan_celebrating.svg
│       ├── toucan_reading.svg
│       ├── toucan_sleeping.svg
│       ├── toucan_confused.svg
│       ├── toucan_encouraging.svg
│       ├── toucan_excited.svg
│       └── toucan_focused.svg
├── logos/
│   ├── icon/
│   │   ├── logo.svg                (App Launcher Icon - Toucan Head)
│   │   ├── logo_launcher.svg       (512x512 High-Res Launcher)
│   │   └── favicon.svg             (16x16 / 32x32 Favicon Face)
│   ├── adaptive/
│   │   ├── ic_launcher_foreground.svg
│   │   └── ic_launcher_background.svg
│   ├── monochrome/
│   │   └── logo_mono.svg           (Android 13 Themed Silhouette)
│   └── full/
│       ├── logo_primary.svg        (Vertical Stacked Lockup)
│       ├── logo_horizontal.svg     (Horizontal Lockup)
│       ├── logo_dark.svg           (Dark Mode Lockup)
│       ├── logo_light.svg          (Light Mode Lockup)
│       └── logo_bubble.svg         (Speech Bubble Lockup)
├── icons/
│   └── notification_toucan.svg     (24dp Ultra-simplified Outline)
├── splash/
│   └── splash_hero.svg             (1080x1920 Mobile Splash Hero)
├── onboarding/
│   ├── scene_1_welcome.svg         (Welcome Scene)
│   ├── scene_2_globe.svg           (World Map & Orbiting Nodes)
│   ├── scene_3_speech.svg          (Voice AI & Translation)
│   └── scene_4_celebration.svg     (XP & Streak Celebration)
├── empty_states/
│   ├── empty_offline.svg           (Unplugged Cable)
│   ├── empty_downloads.svg         (Download Box)
│   ├── empty_no_lessons.svg       (Tiny Book)
│   ├── empty_search.svg           (Magnifying Glass)
│   ├── empty_completed.svg        (Cheering with Trophy)
│   └── empty_error.svg            (Broken Flashcard)
└── achievements/
    ├── badge_graduation_cap.svg
    ├── badge_champion_medal.svg
    ├── badge_fire_streak.svg
    ├── badge_diamond_trophy.svg
    ├── badge_golden_crown.svg
    └── badge_master_certificate.svg
```

---

### 5. Flutter Integration Code Example

To render these clean, scalable SVGs in Flutter apps (`apps/mobile`), use `flutter_svg`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ToucanMascotWidget extends StatelessWidget {
  final String expression; // e.g. 'happy', 'thinking', 'speaking'
  final double size;

  const ToucanMascotWidget({
    Key? key,
    this.expression = 'happy',
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/illustrations/expressions/toucan_$expression.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
```

---

### 6. HTML Interactive Design System Showcase
To preview all assets live in a web browser, open:
`docs/brand_design_system.html`
