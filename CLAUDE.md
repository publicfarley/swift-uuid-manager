# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Build and Run
```bash
# Build the project
swift build

# Build release version (faster execution)
swift build -c release

# Run directly with Swift
swift run

# Run built executable
./.build/debug/uuid-manager

# Run release build
./.build/release/uuid-manager

# Clean build artifacts
swift package clean
```

### Xcode Integration (Optional)
```bash
# Generate Xcode project
swift package generate-xcodeproj
```

## Architecture Overview

This is a command-line UUID manager written in Swift that provides an interactive interface for managing UUIDs with descriptions. The architecture follows a clean separation of concerns:

### Core Components

- **UUIDEntry** (`UUIDEntry.swift`): Core data model containing UUID, timestamp, and description. Implements `Codable` for JSON serialization and provides computed properties for date formatting and "created today" detection.

- **Storage** (`Storage.swift`): JSON-based persistence layer that saves data to `~/Library/Application Support/uuid-manager/uuids.json`. Handles directory creation and uses ISO 8601 date encoding.

- **App** (`App.swift`): Central application state and business logic. Manages the list of UUIDs, selection state, input modes (normal/editing), and coordinates with storage. Contains methods for CRUD operations and navigation.

- **main.swift**: Command-line interface and user interaction loop. Implements the interactive terminal UI with color-coded output (green for today's UUIDs) and handles all user input parsing.

### Key Patterns

- **Dependency**: Uses Swift ArgumentParser for CLI structure (though minimal usage in interactive mode)
- **Storage Location**: Application Support directory following macOS conventions
- **Error Handling**: Uses Swift's `throws` pattern throughout for error propagation
- **State Management**: Centralized in App class with clear separation between UI and business logic
- **Date Handling**: ISO 8601 format for storage, human-readable format for display

### Interactive Commands

The app provides a terminal-based interface with these commands:
- `n`/`new`: Create new UUID
- `i`/`input`: Enter description mode
- `d`/`delete`: Delete selected UUID
- `c`/`copy`: Copy UUID to `/tmp/uuid_manager_copy.txt`
- `l`/`list`: Refresh display
- `↑`/`↓` or `up`/`down`: Navigate selection
- `0-9`: Direct selection by index
- `q`/`quit`: Exit

The interface uses ANSI color codes for visual indicators and maintains selection state across operations.