# Git Remote Switch to GHES

This folder contains two Windows batch scripts:

* `git_switch_ghes.bat`
* `install_sendto.bat`

These scripts help migrate Git repositories from the old GitLab server to GHES by replacing the hostname while preserving the repository path.

For example:

```text
https://gitlab.i2r.a-star.edu.sg/tangtwk/HFVI
```

becomes:

```text
https://ghes.a-star.edu.sg/tangtwk/HFVI
```

---

## Files

### `install_sendto.bat`

Installs `git_switch_ghes.bat` into your Windows **Send to** menu.

Simply double-click `install_sendto.bat`. It copies `git_switch_ghes.bat` to:

```text
%APPDATA%\Microsoft\Windows\SendTo
```

After installation, you can right-click any Git repository folder and select:

```text
Send to → git_switch_ghes
```

---

### `git_switch_ghes.bat`

This script operates on the selected Git repository.

It performs the following actions:

1. Verifies the selected folder is a Git repository.

2. Reads the current `origin` remote URL.

3. Replaces

   ```text
   gitlab.i2r.a-star.edu.sg
   ```

   with

   ```text
   ghes.a-star.edu.sg
   ```

4. Updates the repository's `origin` remote using:

   ```bash
   git remote set-url origin <new-url>
   ```

5. If a `.gitmodules` file exists:

   * Updates all submodule URLs to use `ghes.a-star.edu.sg`.
   * Runs:

     ```bash
     git submodule sync --recursive
     ```

     to synchronize each submodule's configured `origin` remote with the updated `.gitmodules`.

No repository contents are modified—only the remote URLs.

---

## Installation

Place both scripts in the same directory:

```text
install_sendto.bat
git_switch_ghes.bat
```

Double-click:

```text
install_sendto.bat
```

---

## Usage

1. Open File Explorer.

2. Right-click the root folder of a Git repository.

3. Select:

   ```text
   Send to → git_switch_ghes
   ```

4. The script will:

   * Update the repository's `origin` remote.
   * Update `.gitmodules` (if present).
   * Synchronize all submodule remote URLs.

---

## Requirements

* Windows
* Git installed and available on the `PATH`
* PowerShell (included with modern versions of Windows)

---

## Uninstall

1. Press **Win + R**.

2. Run:

   ```text
   shell:sendto
   ```

3. Delete:

   ```text
   git_switch_ghes.bat
   ```
