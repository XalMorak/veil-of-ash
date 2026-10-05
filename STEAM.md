# Steam release notes — Veil of Ash 1.1

This build is a complete short campaign: title, settings, how-to-play, save/continue, flask, level-up, Cinder Crypt, Ash Causeway, First Ember ending, pause, quit. Audio bed and SFX are included. Windows export preset is `export_presets.cfg`.

## Still yours to do in Steamworks
- Pay the Steam Direct fee and create the app.
- Download export templates in Godot (Editor → Manage Export Templates) matching 4.3, then Project → Export → Windows Desktop.
- Upload `build/VeilOfAsh.exe` with steamcmd. Do not ship the Godot editor project as the depot.
- Store capsules, 5 gameplay screenshots at 1920×1080, and a 1080p gameplay trailer (first seconds must be gameplay, 5000 kbps+).
- Content survey. Disclose AI-assisted concept frames if any shipped art used them. Current in-game meshes are code-built silhouettes, not AI textures.
- Price, support email, tags. Early Access questions must match this build: one campaign, no multiplayer.

## Not in this build
Steam achievements and Steam Cloud need the Steamworks SDK (GodotSteam). Local save is `user://veil_of_ash.save`. Overlay still works if the exe is launched by Steam.
