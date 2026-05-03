I'll update the README to document the undo feature. 



Fetched [resource](file:///home/monish/Documents/odin_projects/simulacrum/README.md)

I don't have file editing tools available, but here's the updated README with the undo feature documented. You can replace the current file with this:

```markdown
# Simulacrum

A fast, recursive batch file renaming utility written in Odin, able to process thousands of files in seconds. Rename files across your entire directory tree with a preview before you commit to the changes. 

## Features

- **Recursive directory traversal** — renames all matching files throughout your directory tree
- **Preview mode** — see what will be renamed before confirming
- **Interactive confirmation** — prevents accidental mass renames
- **Skips hidden directories** — dot folders (`.git`, `.node_modules`, etc.) are automatically skipped
- **Undo capability** — revert your last batch rename operation with a single command
- **Cross-platform** — Windows, macOS, and Linux support

## Downloads

Pre-built binaries for Windows, macOS, and Linux are available on the [Releases](https://github.com/thelazybastard/simulacrum/releases) page.

### Download and Use

1. Navigate to the [Releases](https://github.com/thelazybastard/simulacrum/releases) page
2. Download the binary for your operating system:
   - **Windows**: `simulacrum-windows.exe`
   - **macOS**: `simulacrum-macos` 
   - **Linux**: `simulacrum-linux`
3. Make the binary executable (macOS/Linux only):
   ```bash
   chmod +x simulacrum-*
   ```
4. Optionally, add it to your `PATH` for system-wide access:
   - **macOS/Linux**: Move to `/usr/local/bin/` and rename it:
     ```bash
     mv simulacrum-macos /usr/local/bin/simulacrum
     # or for Linux:
     mv simulacrum-linux /usr/local/bin/simulacrum
     ```
   - **Windows**: Move to your desired location and add that directory to your `PATH` environment variable, or rename to `simulacrum.exe`

## Build from Source

### Prerequisites

- [Odin compiler](https://odin-lang.org/) installed and in your `PATH`

### Build Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/thelazybastard/simulacrum.git
   cd simulacrum
   ```

2. Build the project:
   ```bash
   odin build .
   ```

3. The compiled binary will be created in the current directory as `simulacrum` (macOS/Linux) or `simulacrum.exe` (Windows)

4. Optionally, move it to your `PATH` for system-wide access

## Usage

This scans all subdirectories from your current working directory for files matching the specified old filename and renames them to the new filename.

### Rename Command

```bash
simulacrum <old_filename> <new_filename>
```

#### Arguments

- `<old_filename>` — the exact filename to search for (without path)
- `<new_filename>` — the new filename to rename matches to

#### Example

Rename all files named `config.txt` to `settings.txt` in the current directory and all subdirectories:

```bash
simulacrum config.txt settings.txt
```

The tool will:
1. **Preview mode**: Show all matches and what they'll be renamed to
2. **Confirmation prompt**: Ask you to confirm (`y` to proceed, `n` to cancel)
3. **Execution**: Rename all matching files if you confirm

#### Example Output

```
/home/user/project/config.txt -> settings.txt
/home/user/project/src/config.txt -> settings.txt
/home/user/project/tests/config.txt -> settings.txt
Proceed with operation(y/n): y
/home/user/project/config.txt has been renamed to settings.txt
/home/user/project/src/config.txt has been renamed to settings.txt
/home/user/project/tests/config.txt has been renamed to settings.txt
```

### Undo Command

Revert your last batch rename operation:

```bash
simulacrum undo rename
```

This will restore all files renamed in the previous operation to their original names. Undo data is stored in `undo.json` in your current working directory.

#### Example

```bash
simulacrum config.txt settings.txt
# ... confirms the operation ...

# Later, to undo:
simulacrum undo rename
/home/user/project/settings.txt has been reverted to config.txt
/home/user/project/src/settings.txt has been reverted to config.txt
/home/user/project/tests/settings.txt has been reverted to config.txt
```

## How It Works

- The tool walks through your entire directory tree starting from the current working directory
- It skips hidden directories (those starting with `.`) to avoid modifying version control or dependency folders
- In preview mode, it shows all files that match the old filename
- After confirmation, it renames each matching file to the new filename in place
- Rename operations are logged to `undo.json`, allowing you to revert changes if needed
- If any errors occur during renaming, they're reported but don't stop the operation

## License

MIT
```
