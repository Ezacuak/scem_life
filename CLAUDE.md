# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Scem Life** is a Godot 4.6 2D game project built with GDScript. The game features a player-controlled character navigating levels with dialogue-driven interactions.

### Tech Stack
- **Engine**: Godot 4.6 (GL Compatibility rendering)
- **Scripting**: GDScript
- **Rendering**: OpenGL Compatibility (mobile-compatible)
- **Window**: 1080x720 viewport with canvas scaling
- **Physics**: Jolt Physics engine (3D physics module)
- **Assets**: Kenney's RPG Urban Kit (sprites and tilesets)

## Architecture

### Core Systems

#### 1. **Player System** (`Player/`)
- **Script**: `Player/Scripts/player.gd` extends CharacterBody2D
- **Animations**: Two sprite states (Idle and Move) with 4-directional animations
- **Movement**: Uses `Input.get_vector()` for WASD/arrow key input at configurable speed (default 70)
- **AnimationTree**: Blends between idle/move states based on input direction
- **Key nodes**:
  - PlayerIdle: Idle animation sprites (body and head)
  - PlayerMove: Movement animation sprites (body and head)
  - AnimationTree: Manages animation state machine with blend spaces

#### 2. **Dialog System** (`dialogs/`, `DialogManager.gd`)
- **Class**: `DialogManager` (extends Resource)
- **Loading**: Loads JSON dialog files from `dialogs/` folder
- **Structure**: Each dialog JSON contains:
  - `dialogs`: Dictionary of dialog ID → array of choice objects
  - `starting_dialog`: Initial dialog to show
  - **Choice objects**:
    - `text`: Display text for the choice
    - `requirements`: Array of `{name, value}` to check if choice is available
    - `impacts`: Array of `{name, value}` state changes when chosen
    - `nextDialog`: Dialog ID to transition to
- **State Management**: Tracks `choices` dict for requirement checking and state updates
- **Key methods**:
  - `get_current_dialog()`: Returns current dialog ID
  - `get_available_answers()`: Returns array of text for available choices
  - `choose_dialog(choiceText)`: Transitions to next dialog and applies impacts

#### 3. **Levels & Maps** (`Levels/`, `map/`)
- **Level Scenes**: `Levels/Scenes/level_1.tscn` and others
- **Map**: Tilemap-based with tile layers (`Layer_0_1.tscn`, `Layer_1_0.tscn`, `Map.tscn`)
- **Tile Data**: `map/tile_data.json` (map configuration)

### Scene Structure
- **Main Scene**: Currently using `main.gd` (prototype/test scene) - should be replaced with actual game level
- **Node hierarchy**:
  - Player: CharacterBody2D with player controller script
  - AnimationTree: Drives all animations
  - AnimationPlayer: Stores animation library

## Development Workflow

### Godot Project Setup
- **Project file**: `project.godot` - configuration is editor-managed
- **Scenes**: `.tscn` (text-based, git-friendly)
- **Scripts**: `.gd` files (GDScript)
- **Assets**: Imported in `.godot/imported/` directory (git-ignored)
- **UIDs**: Godot generates `.uid` files for resource tracking (git-tracked)

### Running the Game
1. Open in Godot Editor 4.6+
2. Click "Run" (F5) or select `Project > Run`
3. Main scene is configured in `project.godot` (currently set via `run/main_scene` UID)

### Adding Dialog
1. Create a JSON file in `dialogs/` folder (e.g., `npc_name.json`)
2. Structure must match the format in `lauRax.json` or `profLog.json`
3. Instantiate DialogManager in GDScript: `var dm = DialogManager.new("npc_name", choices_dict)`
4. Use `get_available_answers()` and `choose_dialog()` for UI interaction

### Player Animation States
- **Idle animations**: 4 directions, ~2-2.3 second loops
- **Move animations**: 4 directions, ~1.1 second loops
- **Blend space**: Uses Vector2 input direction to smoothly transition between animations
- Sprite sheets: 12×4 frames (idle), 6×4 frames (movement)

## File Organization

```
.
├── main.gd                      # Test/entry point (should be updated)
├── DialogManager.gd             # Dialog system class (root level backup copy)
├── project.godot                # Godot project config
├── Player/
│   ├── Scripts/player.gd        # Player controller
│   └── Scenes/player.tscn       # Player scene with animations
├── Levels/
│   └── Scenes/level_1.tscn      # Level 1 scene
├── dialogs/
│   ├── DialogManager.gd         # Dialog system (actual active copy)
│   ├── lauRax.json              # NPC dialog example
│   ├── profLog.json             # Professor Log dialog
│   └── test.json                # Test dialog
├── map/
│   ├── tile_data.json           # Map configuration
│   ├── Map.tscn                 # Main tilemap
│   └── Layer_*.tscn             # Tilemap layers
├── Sprites/                     # Character sprite assets
├── kenney_rpgUrbanKit/          # Kenney asset pack (tiles, sprites)
└── icon.svg                     # Project icon
```

## Key Implementation Notes

### Dialog JSON Format
Each choice object supports conditional availability based on game state. Use `requirements` to gate choices and `impacts` to track story progress. Examples: `infoMail`, `mailEnvoye`, `archiveComplete` are state flags in the lauRax dialog.

### Animation Tree
The player uses AnimationTree with a StateMachine containing Idle/Move blend spaces. Each blend space uses 2D blending on input direction (left/right, up/down). Transitions use `anim_state.travel()` to switch states.

### Physics
Player uses `move_and_slide()` (built-in character physics). Collision shape is a small rectangle (7×7) positioned at character feet.

## Common Tasks

### Test Dialog Changes
Modify the JSON file and run `main.gd` to see printed dialog output via the test code.

### Add New Level
1. Create scene in `Levels/Scenes/level_*.tscn`
2. Instance player scene and map/dialog components
3. Update main scene reference in `project.godot` or link from a level selector

### Extend Dialog System
Add new methods to DialogManager for:
- Saving/loading state to disk
- Visual dialog UI (currently prints to console)
- Quest/objective tracking
- Conditional dialog branches beyond current requirements system

### Update Animations
Edit `Player/Scenes/player.tscn` in the Godot editor:
1. Select AnimationPlayer node
2. Edit animations in the Animation panel
3. Adjust frame timing, blend space positions, or add new directions

## Debugging

### GDScript
- Use `print()` for console output
- Use `printerr()` for error output (visible in Output panel)
- Godot debugger: Breakpoints and stepping via Debug menu

### Dialog Issues
- Check JSON syntax in dialog files (must be valid JSON)
- Verify `starting_dialog` key exists in JSON root
- Verify `dialogs` key contains all referenced dialog IDs
- Check console output in main.gd for parsing errors
