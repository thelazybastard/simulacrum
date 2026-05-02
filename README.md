# Simulacrum

A fast, recursive batch file renaming utility written in Odin. Rename files across your entire directory tree with a preview before you commit to the changes. 

## Features

- **Recursive directory traversal** — renames all matching files throughout your directory tree
- **Preview mode** — see what will be renamed before confirming
- **Interactive confirmation** — prevents accidental mass renames
- **Skips hidden directories** — dot folders (`.git`, `.node_modules`, etc.) are automatically skipped
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
   - **macOS/Linux**: Move to `/usr/local/bin/` or add to your `PATH` environment variable
   - **Windows**: Add the binary's directory to your `PATH` environment variable

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

This scans all subdirectories from you current working directory for files matching the specified old filename and renames them to the new filename.

```bash
simulacrum <old_filename> <new_filename>
```

### Arguments

- `<old_filename>` — the exact filename to search for (without path)
- `<new_filename>` — the new filename to rename matches to

### Example

Rename all files named `config.txt` to `settings.txt` in the current directory and all subdirectories:

```bash
simulacrum config.txt settings.txt
```

The tool will:
1. **Preview mode**: Show all matches and what they'll be renamed to
2. **Confirmation prompt**: Ask you to confirm (`y` to proceed, `n` to cancel)
3. **Execution**: Rename all matching files if you confirm

### Example Output

```
/home/user/project/config.txt -> settings.txt
/home/user/project/src/config.txt -> settings.txt
/home/user/project/tests/config.txt -> settings.txt
Proceed with operation(y/n): y
/home/user/project/config.txt has been renamed to settings.txt
/home/user/project/src/config.txt has been renamed to settings.txt
/home/user/project/tests/config.txt has been renamed to settings.txt
```

## How It Works

- The tool walks through your entire directory tree starting from the current working directory
- It skips hidden directories (those starting with `.`) to avoid modifying version control or dependency folders
- In preview mode, it shows all files that match the old filename
- After confirmation, it renames each matching file to the new filename in place
- If any errors occur during renaming, they're reported but don't stop the operation

## License

MIT
