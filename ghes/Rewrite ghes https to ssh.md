# Git HTTPS to SSH Rewrite for A*STAR GitHub Enterprise

## Purpose

This configuration allows Git repositories and `.gitmodules` files to continue using HTTPS URLs while Git automatically connects using SSH.

For example:

HTTPS:

https://ghes.a-star.edu.sg/tangtwk/test.git

is automatically rewritten to:

git@ghes.a-star.edu.sg:tangtwk/test.git

This is useful when you do not have HTTPS credentials but have a working SSH key.

It also works with TortoiseGit because TortoiseGit uses Git's configuration.

---

## 1. Configure the Git URL Rewrite

Run this command in Git Bash, PowerShell, or Command Prompt:

```bash
git config --global url."git@ghes.a-star.edu.sg:".insteadOf "https://ghes.a-star.edu.sg/"
```bash

## 2. Select the SSH Client in TortoiseGit

In TortoiseGit, open **Settings > Network > SSH Client** and select the SSH client that matches your key setup.

For Git's standard OpenSSH client, select or browse to:

ssh.exe or 

```text
C:\Program Files\Git\usr\bin\ssh.exe
```

If you use a PuTTY-format key with Pageant, select **TortoisePlink** instead and use the corresponding `TortoisePlink.exe` executable. The selected client must be able to access the SSH key for `ghes.a-star.edu.sg`.


## 8. Undo / Remove the SSH Rewrite

If you want Git to stop automatically converting the A*STAR HTTPS URLs to SSH, remove the global rewrite rule:


git config --global --unset url."git@ghes.a-star.edu.sg:".insteadOf