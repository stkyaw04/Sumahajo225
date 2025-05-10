#  Draft Race
A fun, interactive writing app where you race a tortoise against a virtual hare by reaching your word goal before the hare catches up. It features animated sprites, custom fonts, and an integrated draft library.

##Table of Contents
1. [Features](#features)
2. [Dependencies](#dependencies)
3. [How It Works](#how-it-works)
4. [Usage Guide](#usage-guide)
5. [App Structure](#app-structure)
6. [Draft Management](#draft-management)
7. [Game Modes & Difficulty](#game-modes--difficulty)
8. [Important Notes](#important-notes)
                               

##Features

Writing Race: Reach your set word goal before the animated hare catches up.

Animated Sprites: Tortoise and hare move across the screen as you write.

Custom Font: Uses a pixel-style font for retro aesthetics.

Draft Saving & Editing: Save, search, and edit your drafts.

Difficulty Levels: Adjust how fast the hare chases you.

Celebratory Confetti: Visual feedback when you win.

##Dependencies

SwiftUI (macOS app)

AppKit (for some macOS-specific features)

ConfettiSwiftUI (confetti animation)

Pow (button effects)

Custom Font (FatPix-Regular)

Image Assets (sprite frames and backgrounds)


##How It Works
Start Screen: Choose your word goal and difficulty. You can also search, open, or delete previous drafts.

Writing Race: As you type, the tortoise moves forward. If you stop, the hare starts chasing based on the difficulty level.

Win Condition: Reach your word goal before the hare catches up.

Draft Management: Save your finished drafts, name them, and revisit or edit them later.

# Usage Guide

1. **Launch the App:**  
   The app starts in fullscreen with the Start Screen.

2. **Set Up Your Race:**  
   - Enter your word goal.
   - Choose a difficulty (Easy, Medium, Hard).
   - Click "Start Writing" to begin.

3. **Writing Interface:**  
   - Type in the editor. Your word count and progress are shown.
   - Animated tortoise (you) and hare (AI) move as you write.
   - Adjust font size with plus/minus buttons.
   - Save your draft when you reach your goal.

4. **Manage Drafts:**  
   - View, search, open, and delete saved drafts from the start screen.
   - Edit drafts by opening them from the library.

---
## App Structure

| File                         | Purpose                                                    |
|------------------------------|------------------------------------------------------------|
| `SumahajoApp.swift`          | App entry point, launches fullscreen, loads root view      |
| `ViewHandler.swift`          | Handles navigation between start screen and writing view   |
| `StartScreenUIView.swift`    | Start screen: set word goal, difficulty, manage drafts     |
| `DraftView.swift`            | Main writing interface, race logic, draft saving           |
| `HareLogicHandler.swift`     | Controls hare’s speed and game-over logic                  |
| `RaceAnimationView.swift`    | Animates tortoise and hare sprites                         |
| `TortoiseAnimationView.swift'| Animates tortoise for background visuals                   |
| `FontHandler.swift`          | Adds custom font support                                   |
| `NoteViewModel.swift`        | Handles file saving, loading, and deletion for drafts      |
| `EditDraftView.swift`        | Lets you edit saved drafts                                 |

#Draft Management
Saving: Click "Save Your Draft" after reaching your goal.

Naming: Enter a name for your draft in the popup.

Editing: Open drafts from the library to edit and re-save.

Deleting: Remove drafts from the library with the "Delete" button.

## Game Modes & Difficulty

| Difficulty | Hare Wait Time | Hare Speed | Description                           |
|------------|----------------|-------------|--------------------------------------|
| Easy       | 3.5 seconds    | Slow        | Hare starts moving after 3.5s idle   |
| Medium     | 2 seconds      | Medium      | Hare starts after 2s, moves faster   |
| Hard       | 0.5 seconds    | Fast        | Hare chases quickly after 0.5s idle  |
------------------------------------------------------------------------------------
- If you stop typing, the hare starts chasing after the set delay.
- Win by reaching your word goal before the hare does.
- Lose if the hare catches up.

## Important Notes

- **Fullscreen:** The app opens in fullscreen by default.
- **Sprite Assets:** Make sure all image assets (tortoise, hare frames, backgrounds) are included in the asset catalog.
- **macOS Only:** Uses AppKit features, so it is not iOS compatible out of the box.
- **Drafts Location:** Drafts are saved as files in the app’s Documents directory.


## Credits

- **Authors:** Joseph Saputra, Harold Ponce, Su Thiri Kyaw, Makol Chuol
