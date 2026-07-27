#!/usr/bin/env python3
import os
import shutil

ROOT_DIR = "/home/sugarcube/Desktop/Documents/Code-Server/@PRODUCTS/DiLang-v2"
ASSETS_DIR = os.path.join(ROOT_DIR, "assets")
MOBILE_ASSETS_DIR = os.path.join(ROOT_DIR, "apps/mobile/assets")

# Folders to remove
folders_to_remove = [
    "achievements", "empty_states", "illustrations", "onboarding", "splash", "icons"
]

for base_dir in [ASSETS_DIR, MOBILE_ASSETS_DIR]:
    for folder in folders_to_remove:
        path = os.path.join(base_dir, folder)
        if os.path.exists(path):
            shutil.rmtree(path)
            print(f"Removed: {path}")

# Ensure clean basic logo directories
for base_dir in [ASSETS_DIR, MOBILE_ASSETS_DIR]:
    os.makedirs(os.path.join(base_dir, "logos/icon"), exist_ok=True)
    os.makedirs(os.path.join(base_dir, "logos/full"), exist_ok=True)
    os.makedirs(os.path.join(base_dir, "logos/monochrome"), exist_ok=True)

LOGO_ICON = """<svg width="512" height="512" viewBox="0 0 512 512" fill="none" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="logoGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#10B981" />
      <stop offset="100%" stop-color="#059669" />
    </linearGradient>
    <linearGradient id="innerGlow" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#34D399" />
      <stop offset="100%" stop-color="#06B6D4" />
    </linearGradient>
  </defs>

  <rect x="32" y="32" width="448" height="448" rx="112" fill="url(#logoGradient)" />

  <path d="M160 160C160 142.327 174.327 128 192 128H320C337.673 128 352 142.327 352 160V272C352 289.673 337.673 304 320 304H248L192 352V304H192C174.327 304 160 289.673 160 272V160Z" 
        fill="none" 
        stroke="#FFFFFF" 
        stroke-width="24" 
        stroke-linecap="round" 
        stroke-linejoin="round"/>

  <circle cx="224" cy="216" r="16" fill="url(#innerGlow)" />
  <circle cx="288" cy="216" r="16" fill="url(#innerGlow)" />
  <line x1="224" y1="216" x2="288" y2="216" stroke="#FFFFFF" stroke-width="12" stroke-linecap="round" />
</svg>"""

LOGO_FULL = """<svg width="600" height="200" viewBox="0 0 600 200" fill="none" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="logoGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#10B981" />
      <stop offset="100%" stop-color="#059669" />
    </linearGradient>
  </defs>
  <rect x="20" y="20" width="160" height="160" rx="40" fill="url(#logoGradient)" />
  <path d="M70 70C70 62 76 56 84 56H136C144 56 150 62 150 70V110C150 118 144 124 136 124H110L86 144V124H84C76 124 70 118 70 110V70Z" fill="none" stroke="#FFFFFF" stroke-width="10" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="98" cy="90" r="7" fill="#34D399" />
  <circle cx="122" cy="90" r="7" fill="#34D399" />
  <line x1="98" y1="90" x2="122" y2="90" stroke="#FFFFFF" stroke-width="5" stroke-linecap="round" />
  <text x="220" y="115" font-family="'Inter', sans-serif" font-weight="800" font-size="64" letter-spacing="-2" fill="#0F172A">Di<tspan fill="#10B981">Lang</tspan></text>
  <text x="225" y="150" font-family="'Inter', sans-serif" font-weight="600" font-size="16" letter-spacing="3" fill="#64748B">OFFLINE AI PLATFORM</text>
</svg>"""

LOGO_MONO = """<svg width="512" height="512" viewBox="0 0 512 512" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="32" y="32" width="448" height="448" rx="112" fill="#FFFFFF" />
  <path d="M160 160C160 142.327 174.327 128 192 128H320C337.673 128 352 142.327 352 160V272C352 289.673 337.673 304 320 304H248L192 352V304H192C174.327 304 160 289.673 160 272V160Z" 
        fill="none" 
        stroke="#000000" 
        stroke-width="24" 
        stroke-linecap="round" 
        stroke-linejoin="round"/>
  <circle cx="224" cy="216" r="16" fill="#000000" />
  <circle cx="288" cy="216" r="16" fill="#000000" />
  <line x1="224" y1="216" x2="288" y2="216" stroke="#000000" stroke-width="12" stroke-linecap="round" />
</svg>"""

def write_asset(rel_path, content):
    for base_dir in [ASSETS_DIR, MOBILE_ASSETS_DIR]:
        full_path = os.path.join(base_dir, rel_path)
        os.makedirs(os.path.dirname(full_path), exist_ok=True)
        with open(full_path, "w", encoding="utf-8") as f:
            f.write(content.strip() + "\n")
        print(f"Wrote basic asset: {full_path}")

write_asset("logos/icon/logo.svg", LOGO_ICON)
write_asset("logos/full/logo_full.svg", LOGO_FULL)
write_asset("logos/monochrome/logo_mono.svg", LOGO_MONO)

print("Restored basic logo assets successfully.")
